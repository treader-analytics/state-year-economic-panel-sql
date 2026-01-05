# State–Year Economic Panel (PostgreSQL)

## Overview
This project builds a **reproducible, analysis‑ready state–year economic panel** in PostgreSQL.  
The pipeline follows an analytics‑engineering pattern:

**Raw CSV → Staging → Fact & Dimension tables → Indexed analytics view → Analytical SQL**

The final deliverable is a clean panel dataset designed for time‑series and cross‑sectional analysis of U.S. state‑level economic conditions.

---

## Final Output: Analytics View

### `econ.vw_state_year_panel`
This view is the **primary product** of the project and serves as the contract for all downstream analysis.

**Schema**
- `state_fips`
- `state_abbr`
- `state_name`
- `year`
- `poverty_rate`
- `median_income`
- `unemployment_rate`

### Example rows
_Note: The final column shown below represents the year-over-year change in poverty rate (derived via window functions in analysis queries)._
```text
CA | 1989 | 12.70
CA | 1993 | 17.40 | +4.70
CA | 2000 | 12.70 | -1.00
CA | 2010 | 15.80 | +1.60
CA | 2020 | 11.50 | -0.30
FL | 1989 | 12.90
FL | 2000 | 11.70 | -0.70
FL | 2010 | 16.50 | +1.50
TX | 1989 | 17.70
TX | 2000 | 14.60 | -0.50
TX | 2010 | 17.90 | +0.80
TX | 2020 | 13.40 | -0.20
```

Values shown illustrate long‑run trends and business‑cycle sensitivity across large U.S. states.

---

## Data Model

### Dimension Table
**`econ.dim_state`**
- One row per state
- Stores stable identifiers (FIPS, abbreviation, name)
- Joined to fact table via `state_fips`

### Fact Table
**`econ.fact_state_year`**
- Grain: **one row per state per year**
- Stores annual economic measures:
  - poverty rate
  - median household income
  - unemployment rate

### Staging Table
**`econ.stg_state_year`**
- Raw CSV landing table
- Decouples ingestion from analytics schema
- Enables full rebuilds and reproducibility

---

## Example Analyses

### 1. Year‑over‑Year Poverty Rate Changes
Using window functions to identify large inter‑temporal shifts:

```sql
poverty_rate
- LAG(poverty_rate) OVER (
    PARTITION BY state_fips
    ORDER BY year
) AS poverty_yoy_change
```

**Observed patterns**
- Sharp increases during recessionary periods (early 1990s, Great Recession)
- Broad declines during sustained expansions (late 1990s, mid‑2010s)
- Pandemic‑era volatility with heterogeneous state responses

---

### 2. Within‑Year Poverty Ranking
States are ranked within each year using `DENSE_RANK()`:

```sql
DENSE_RANK() OVER (
  PARTITION BY year
  ORDER BY poverty_rate DESC
)
```

**Illustrative years**
- **1989:** Mississippi, Louisiana, and New Mexico rank highest
- **2000:** Broad nationwide improvement, lower dispersion
- **2010:** Post‑recession re‑ranking with elevated poverty across most states
- **2020:** Persistent regional clustering in the Southeast and Southwest

This demonstrates cross‑sectional comparison within a consistent panel structure.

---

### 3. Data Quality Audit
Basic completeness checks on the final analytics view:

```text
total_rows | poverty_nulls | income_nulls | unemployment_nulls
1581       | 0             | 0            | 0
```

All measures are fully populated across the panel.

---

## Reproducibility

Scripts are intended to be run **top‑to‑bottom in numeric order**:

1. `00_schema.sql` – schema, tables, constraints
2. `01_staging_load.sql` – CSV ingestion
3. `02_dimensions.sql` – dimension build
4. `03_facts.sql` – fact table build
5. `04_analysis.sql` – analytical queries

A sample CSV is included to allow the full pipeline to be executed locally.

---

## Why This Project
This project emphasizes:
- relational data modeling
- clear grain definition
- window‑function analytics
- reproducible database pipelines

It mirrors the structure of production analytics databases used in policy analysis, public health, and economic research.

---

## Author

**Trevor Reader**
B.A. Mathematics & Statistics 
Analytics Engineering • Economic Data • SQL
