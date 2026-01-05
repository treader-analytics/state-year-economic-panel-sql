-- 03_indexes.sql
-- Performance indexes for common filters and joins

CREATE INDEX IF NOT EXISTS ix_fact_year
ON econ.fact_state_year (year);

CREATE INDEX IF NOT EXISTS ix_fact_state_year
ON econ.fact_state_year (state_fips, year);
