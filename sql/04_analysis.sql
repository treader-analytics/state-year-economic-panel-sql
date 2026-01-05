-- 04_analysis.sql
-- Example analyses (window functions + QA checks)

-- Row counts (sanity)
SELECT COUNT(*) AS stg_rows FROM econ.stg_state_year;
SELECT COUNT(*) AS dim_states FROM econ.dim_state;
SELECT COUNT(*) AS fact_rows FROM econ.fact_state_year;

-- Preview view
SELECT *
FROM econ.vw_state_year_panel
ORDER BY year, state_abbr
LIMIT 20;

-- A) Rank states by poverty within each year (window)
SELECT
  year,
  state_abbr,
  poverty_rate,
  DENSE_RANK() OVER (PARTITION BY year ORDER BY poverty_rate DESC) AS poverty_rank
FROM econ.vw_state_year_panel
WHERE year IN (1989, 2000, 2010, 2020)
ORDER BY year, poverty_rank
LIMIT 250;

-- B) Year-over-year poverty change per state (LAG)
SELECT
  state_abbr,
  year,
  poverty_rate,
  poverty_rate - LAG(poverty_rate) OVER (PARTITION BY state_fips ORDER BY year) AS poverty_pp_change
FROM econ.vw_state_year_panel
WHERE state_abbr IN ('FL','CA','TX','GA')
ORDER BY state_abbr, year;

-- C) Rolling 3-year poverty average (window frame)
SELECT
  state_abbr,
  year,
  poverty_rate,
  AVG(poverty_rate) OVER (
    PARTITION BY state_fips
    ORDER BY year
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ) AS poverty_3yr_avg
FROM econ.vw_state_year_panel
WHERE state_abbr IN ('FL','CA','TX','GA')
ORDER BY state_abbr, year;

-- D) Within-year z-score of poverty (normalize across years)
SELECT
  year,
  state_abbr,
  poverty_rate,
  (poverty_rate - AVG(poverty_rate) OVER (PARTITION BY year))
  / NULLIF(STDDEV_SAMP(poverty_rate) OVER (PARTITION BY year), 0) AS poverty_z
FROM econ.vw_state_year_panel
WHERE year IN (1989, 2000, 2010, 2020)
ORDER BY year, poverty_z DESC
LIMIT 250;

-- E) “High poverty + low income” segmentation
SELECT
  year,
  state_abbr,
  poverty_rate,
  median_income
FROM econ.vw_state_year_panel
WHERE poverty_rate >= 15
  AND median_income <= 50000
ORDER BY year DESC, poverty_rate DESC
LIMIT 200;

-- F) Data-quality audit (missingness)
SELECT
  COUNT(*) AS total_rows,
  SUM((poverty_rate IS NULL)::int) AS missing_poverty,
  SUM((median_income IS NULL)::int) AS missing_income,
  SUM((unemployment_rate IS NULL)::int) AS missing_unemp
FROM econ.vw_state_year_panel;

-- G) Income bins vs avg poverty (simple relationship check)
SELECT
  year,
  CASE
    WHEN median_income < 40000 THEN '<40k'
    WHEN median_income < 50000 THEN '40–50k'
    WHEN median_income < 60000 THEN '50–60k'
    WHEN median_income < 70000 THEN '60–70k'
    ELSE '70k+'
  END AS income_bin,
  COUNT(*) AS n,
  AVG(poverty_rate) AS avg_poverty
FROM econ.vw_state_year_panel
WHERE year IN (2000, 2010, 2020)
  AND median_income IS NOT NULL
  AND poverty_rate IS NOT NULL
GROUP BY year, income_bin
ORDER BY year, income_bin;
