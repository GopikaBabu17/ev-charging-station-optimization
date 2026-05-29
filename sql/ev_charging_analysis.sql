CREATE EXTENSION postgis;
--inserted zipcode table shp file to sql file
select * from zipcode

--ev charging stations table
CREATE TABLE ev_charging_stations (
    id SERIAL PRIMARY KEY,
    station_name VARCHAR(255),
	zip_code VARCHAR(20),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION
);
ALTER TABLE ev_charging_stations ADD COLUMN geom geometry(Point, 4326);
UPDATE ev_charging_stations SET geom = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326);
SELECT * FROM ev_charging_stations;
--ev sales data--

CREATE TABLE ev_sales (
    data_year INT,         
    zip VARCHAR(10),       
    number_of_vehicles INT 
);
select * from ev_sales

--population data--
create table pop_data(
	zipcode VARCHAR(10),
	latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
	population int,
	density double precision
)
ADD COLUMN pointgeom geometry(Point,4269);
UPDATE pop_data
SET pointgeom = ST_SetSRID(ST_MakePoint(longitude, latitude), 4269);
ALTER TABLE pop_data
ADD COLUMN areageom geometry(MultiPolygon, 4269);
UPDATE pop_data
SET areageom = zipcode.wkb_geometry
FROM zipcode
WHERE pop_data.zipcode = zipcode.zcta5ce20;

select * from pop_data


--traffic data

create table traffic(
	id integer,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
	count int,
	geom geometry(Point, 4326)
)
update traffic set geom = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)
select * from traffic

--created a view joining the zipcode and ev_sales table since ev_sales doesnt have geom
CREATE VIEW sales AS
SELECT 
    z.zcta5ce20 as zipcode, 
    z.wkb_geometry  as geom, 
    SUM(e.number_of_vehicles) AS total_vehicles
FROM 
    zipcode z
LEFT JOIN 
    ev_sales e ON z.zcta5ce20 = e.zip
GROUP BY 
    z.zcta5ce20, z.wkb_geometry;

--created a 1km buffer--
CREATE view charging_station_buffers AS
SELECT 
    id,
    ST_Buffer(geom::geography, 1000)::geometry AS buffer_geom
FROM 
    ev_charging_stations;

-- Identify traffic points not covered by existing charging stations
CREATE TABLE uncovered_traffic AS
SELECT 
    t.id AS traffic_id,
    t.geom AS traffic_geom,
	t.count as traffic_count
FROM 
    traffic t
LEFT JOIN 
    charging_station_buffers b
ON 
    ST_Intersects(t.geom, b.buffer_geom)
WHERE 
    b.id IS NULL;

--Combine uncovered traffic with population data and finding areas which require charging station at high demand
CREATE view demand_areas AS
SELECT 
    ut.traffic_id,
    ut.traffic_geom,
    ut.traffic_count,
    p.density,
    s.total_vehicles, -- Assuming sales data comes from a sales table or column
    ut.traffic_count * p.density * s.total_vehicles AS demand_score,
    RANK() OVER (ORDER BY ut.traffic_count * p.density * s.total_vehicles DESC) AS rank
FROM 
    uncovered_traffic ut
JOIN 
    pop_data p
ON 
    ST_Intersects(ut.traffic_geom, ST_Transform(p.areageom, 4326))
LEFT JOIN 
    sales s
ON 
    ST_Intersects(ut.traffic_geom, st_transform(s.geom,4326));

-- Step 1: Create a table with clusters
CREATE VIEW demand_clusters AS
SELECT 
    ST_ClusterKMeans(traffic_geom, 30) OVER () AS cluster_id, 
    traffic_geom
FROM 
    demand_areas;

--created a vector grid and inserted it here and showed areas with higher demand
select * from grid;

ALTER TABLE grid ADD COLUMN total_demand DOUBLE PRECISION;

UPDATE grid
SET total_demand = (
    SELECT SUM(demand_score)
    FROM demand_areas
    WHERE ST_Intersects(grid.wkb_geometry, ST_Transform(demand_areas.traffic_geom, 3857))
);

-- Step 2: Create a view with centroids of clusters
CREATE VIEW cluster_centroids AS
SELECT 
    cluster_id,
    ST_Centroid(ST_Collect(traffic_geom)) AS station_location 
FROM 
    demand_clusters
GROUP BY 
    cluster_id;

-- Step 3: Create a view for station coverage areas
CREATE VIEW station_coverage AS
WITH coverage_areas AS (
    SELECT 
        cluster_id,
        station_location,
        ST_Buffer(station_location::geography, 1000)::geometry AS coverage_area  
    FROM 
        cluster_centroids
)
SELECT 
    ca.cluster_id,
    ca.station_location,
    ca.coverage_area,
    COUNT(da.traffic_geom) AS points_covered 
FROM 
    coverage_areas ca
LEFT JOIN 
    demand_areas da
ON 
    ST_Within(da.traffic_geom, ca.coverage_area)
GROUP BY 
    ca.cluster_id, ca.station_location, ca.coverage_area;






