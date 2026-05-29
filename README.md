# EV Charging Station Placement Optimization in San Francisco

## Project Overview

This project aims to identify optimal locations for new Electric Vehicle (EV) charging stations in San Francisco using geospatial analysis and SQL-based data processing.

As EV adoption continues to grow, cities require well-distributed charging infrastructure to ensure accessibility and support sustainable transportation. This project analyses population density, traffic flow, road networks, and existing charging station locations to recommend future charging station placements.

---

## Business Problem

The current EV charging network faces several challenges:

- Uneven charging station distribution
- Charging deserts in underserved areas
- High-traffic zones with insufficient charging capacity
- Misalignment between charging infrastructure and population demand

The objective was to identify locations where new charging stations would provide maximum impact.

---

## Project Objectives

- Analyse existing EV charging station distribution
- Identify underserved areas ("charging deserts")
- Evaluate population density and traffic demand
- Assess charging station coverage across the city
- Recommend optimal locations for future charging stations

---

## Tools & Technologies

- SQL
- PostgreSQL
- QGIS
- Geospatial Analysis
- Spatial Data Processing
- Data Visualization

---

## Data Sources

### Population Data
- Population statistics by ZIP code
- Demographic information

### Income Data
- Household income data by geographic area

### Transportation Data
- Road network data
- Traffic flow data

### EV Infrastructure Data
- Existing EV charging station locations

### Geographic Data
- ZIP code boundaries
- Administrative boundaries

Sources:
- DataSF Open Data Portal
- OpenStreetMap / Overpass Turbo
- Public EV Charging Infrastructure Data

---

## Methodology

### 1. Data Collection
Collected datasets relating to:
- Population density
- ZIP code boundaries
- Road networks
- Traffic flow
- Existing EV charging stations
- Income

### 2. Data Preparation
- Cleaned and validated datasets
- Imported data into PostgreSQL
- Standardised spatial attributes

### 3. Spatial Analysis

Using PostgreSQL and PostGIS, the following analyses were performed:

- Population density analysis
- Charging station distribution analysis
- Buffer analysis around existing charging stations
- Coverage gap identification
- Spatial joins and intersection analysis
- Traffic accessibility analysis
- Demand scoring

QGIS was used to visualise the analysis results and create thematic maps for interpretation and presentation.

### 4. Demand Modelling

A demand scoring framework was developed by combining:

* Traffic volume
* Population density
* EV ownership indicators

Demand Score = Traffic Volume × Population Density × EV Ownership

This approach helped identify areas with the highest potential demand for EV charging infrastructure.

### 5. Location Optimization

Advanced PostGIS spatial techniques were used to recommend new charging station locations, including:

* Buffer analysis around existing charging stations
* Coverage gap identification
* Spatial joins and intersection analysis
* Traffic accessibility analysis
* K-Means clustering for candidate site generation

The final recommended charging station locations were selected based on demand, accessibility, and existing infrastructure coverage.


---
## Advanced Geospatial Analysis

The project used PostgreSQL and PostGIS to perform advanced spatial analytics and optimization.

Key techniques included:

- Spatial joins
- Buffer analysis
- Coverage gap identification
- Traffic demand modelling
- Population density analysis
- Income-based demand analysis
- K-Means clustering
- Demand scoring
- Candidate site optimization

By integrating demographic, transportation, and infrastructure datasets, the project identified underserved regions and proposed optimal charging station locations to improve accessibility and support EV adoption.


## Key Findings

- Identified charging deserts across San Francisco
- Detected clusters of existing charging stations
- Highlighted underserved high-demand regions
- Proposed new charging station locations to improve accessibility and network coverage

---

## Visual Analysis

### Population Density Heatmap
Shows areas with the highest population concentration and potential EV charging demand.

### Existing Charging Infrastructure
Visualisation of current charging station locations across San Francisco.

### Coverage Gap Analysis
Grid-based analysis used to identify underserved regions.

### Traffic Corridor Analysis
Assessment of major traffic routes and charging accessibility.

### Recommended Charging Station Locations
Final proposed locations for future EV charging stations based on the combined analysis.

---

## Repository Structure

```text
EV-Charging-Station-Optimization
│
├── README.md
├── datasets/
├── sql/
├── qgis/
├── screenshots/
└── presentation/
```

---

## Results

The proposed charging station locations support:

- Improved accessibility for EV users
- Better infrastructure distribution
- Increased support for EV adoption
- Data-driven urban planning
- Reduced carbon emissions

---

## Future Improvements

- Real-time traffic integration
- EV ownership forecasting
- Machine learning-based demand prediction
- Cost-benefit optimisation analysis

---

## Author

**Gopika Babu**

MSc Data Science & Analytics  
Maynooth University  
Ireland
