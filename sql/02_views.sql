-- 02_views.sql
-- Analysis-ready view (final deliverable)

CREATE OR REPLACE VIEW econ.vw_state_year_panel AS
SELECT
  s.state_fips,
  s.state_abbr,
  s.state_name,
  f.year,
  f.poverty_rate,
  f.median_income,
  f.unemployment_rate,
  f.poverty_population,
  f.labor_force
FROM econ.fact_state_year f
JOIN econ.dim_state s
  ON s.state_fips = f.state_fips;
