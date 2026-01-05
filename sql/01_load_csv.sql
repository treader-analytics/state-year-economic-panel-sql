-- 01_load_csv.sql
-- Load full panel CSV into staging, rebuild dim + fact.
-- Update the path in COPY to your local file location.
--
-- For demo purposes, a small sample CSV is provided in:
--   data/sample/state_year_panel_sample.csv
--
-- The full Census/SAIPE-derived panel is not committed due to size.
-- To load the full dataset, update the COPY path below or use
-- pgAdmin's Import/Export UI to load into econ.stg_state_year.

-- 1) Clear staging then load CSV
TRUNCATE TABLE econ.stg_state_year;

COPY econ.stg_state_year (
  state_abbr,
  state_name,
  state_fips,
  year,
  poverty_rate,
  median_income,
  unemployment_rate
)
FROM 'C:/projects/python-policy-project/data/processed/state_year_panel.csv'
WITH (FORMAT csv, HEADER true);

-- 2) Rebuild dim + fact (truncate both together due to FK)
TRUNCATE TABLE econ.fact_state_year, econ.dim_state;

-- 3) Dimension load
INSERT INTO econ.dim_state (state_fips, state_abbr, state_name)
SELECT DISTINCT
  state_fips,
  state_abbr,
  state_name
FROM econ.stg_state_year
WHERE state_fips IS NOT NULL
  AND state_abbr IS NOT NULL
  AND state_name IS NOT NULL;

-- 4) Fact load
INSERT INTO econ.fact_state_year (
  state_fips,
  year,
  poverty_rate,
  median_income,
  unemployment_rate
)
SELECT
  state_fips,
  year,
  poverty_rate,
  median_income,
  unemployment_rate
FROM econ.stg_state_year
WHERE state_fips IS NOT NULL
  AND year IS NOT NULL;

