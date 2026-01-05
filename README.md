# State-Year Economic Panel (PostgreSQL)

This project builds a clean, analysis-ready **state–year economic panel** in PostgreSQL using reproducible schema design, a staging-based CSV ingestion pipeline, and advanced SQL analytics.

It is designed as the **database layer** for a larger Census/SAIPE-based data pipeline and demonstrates real-world SQL practices used in analytics engineering, public policy analysis, and data science workflows.

---

## Project Overview

The database models U.S. state-level economic indicators at an annual frequency, including:

- Poverty rate  
- Median household income  
- Unemployment rate  

The final deliverable is an analysis-ready SQL view (`econ.vw_state_year_panel`) intended for downstream use in Python, R, or BI tools.

Key objectives:
- Demonstrate relational schema design (dimension + fact tables)
- Enforce data validity with constraints
- Separate raw data ingestion from analytical logic
- Showcase window functions and analytical SQL patterns
- Provide a reproducible, script-based setup

---

## Data Source & Pipeline Context

The full dataset used by this project is derived from U.S. Census Bureau sources (including SAIPE) and is generated upstream in a Python-based data processing pipeline.

That upstream project performs:
- raw Census/SAIPE ingestion
- cleaning and reshaping
- construction of a processed **state–year panel CSV**

This SQL repository represents the **database and analytics layer** built on top of that processed output.

> Raw Census/SAIPE data are **not committed** to this repository due to size.

---

## Repository Structure

```
.
├─ README.md
├─ sql/
│  ├─ 00_schema.sql        # schema, dimension, fact, and staging tables
│  ├─ 01_load_csv.sql      # CSV ingestion and table rebuild pipeline
│  ├─ 02_views.sql         # analysis-ready panel view
│  ├─ 03_indexes.sql       # performance-oriented indexes
│  └─ 04_analysis.sql      # example analytical queries
├─ data/
│  └─ sample/
│     └─ state_year_panel_sample.csv  # small demo dataset
└─ .gitignore
```

---

## Sample vs Full Data

### Sample Data (Included)
A small sample CSV is provided in:

```
data/sample/state_year_panel_sample.csv
```

This file allows anyone to:
- run the full SQL pipeline locally
- validate schema and queries
- explore example analyses quickly

### Full Data (Not Included)
The full Census/SAIPE-derived panel is intentionally excluded due to size.

To load the full dataset:
- update the CSV path in `sql/01_load_csv.sql`, **or**
- use pgAdmin’s Import/Export UI to load the CSV into `econ.stg_state_year`

This mirrors real-world data engineering workflows where raw data is environment-specific.

---

## How to Run the Project

Run the SQL scripts in the following order using pgAdmin or `psql`:

1. **Create schema and tables**
   ```
   sql/00_schema.sql
   ```

2. **Load CSV data and rebuild tables**
   ```
   sql/01_load_csv.sql
   ```

3. **Create analysis-ready view**
   ```
   sql/02_views.sql
   ```

4. **Add indexes**
   ```
   sql/03_indexes.sql
   ```

5. **Run example analyses**
   ```
   sql/04_analysis.sql
   ```

---

## Example Analyses Included

The analysis script demonstrates common analytical SQL patterns, including:

- Ranking states by poverty rate within each year (`DENSE_RANK`)
- Year-over-year poverty changes using `LAG`
- Rolling multi-year averages with window frames
- Within-year z-scores for cross-time comparability
- Segmentation of high-poverty / low-income states
- Data quality audits (null checks)

These queries are written to be:
- readable
- reusable
- representative of real analytics work

---

## Design Notes

- A **staging table** is used to decouple raw CSV structure from analytical tables
- Primary and foreign keys enforce relational integrity
- Constraints prevent invalid values from entering the database
- The final view isolates analytical consumers from underlying schema complexity

---

## Intended Use

This project is intended to demonstrate:
- SQL proficiency beyond basic SELECT statements
- Comfort with real-world data ingestion patterns
- Analytical thinking using window functions
- Clean project organization suitable for collaboration

It can serve as:
- a standalone SQL portfolio project
- the database layer for a Python or R analysis
- a foundation for BI dashboards or reporting

---

## Author

**Trevor Reader**  
Background in Mathematics & Statistics with a focus on applied data analysis, public policy, and reproducible analytics workflows.
