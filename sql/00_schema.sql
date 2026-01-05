-- 00_schema.sql
-- Schema + core tables for the state-year economic panel

CREATE SCHEMA IF NOT EXISTS econ;

-- Dimension: states
CREATE TABLE IF NOT EXISTS econ.dim_state (
  state_fips CHAR(2) PRIMARY KEY,
  state_abbr CHAR(2) NOT NULL UNIQUE,
  state_name TEXT NOT NULL UNIQUE
);

-- Fact: one row per state per year
CREATE TABLE IF NOT EXISTS econ.fact_state_year (
  state_fips CHAR(2) NOT NULL REFERENCES econ.dim_state(state_fips),
  year SMALLINT NOT NULL CHECK (year BETWEEN 1970 AND 2100),

  poverty_rate NUMERIC(5,2) CHECK (poverty_rate BETWEEN 0 AND 100),
  median_income INTEGER CHECK (median_income >= 0),
  unemployment_rate NUMERIC(5,2) CHECK (unemployment_rate BETWEEN 0 AND 100),

  -- placeholders for later expansion (nullable)
  poverty_population INTEGER CHECK (poverty_population >= 0),
  labor_force INTEGER CHECK (labor_force >= 0),

  PRIMARY KEY (state_fips, year)
);

-- Staging table: matches CSV header exactly
-- CSV header: State,state_name,state_fips,year,poverty_rate,median_income,unemployment_rate
DROP TABLE IF EXISTS econ.stg_state_year;

CREATE TABLE econ.stg_state_year (
  state_abbr CHAR(2),
  state_name TEXT,
  state_fips CHAR(2),
  year SMALLINT,
  poverty_rate NUMERIC(5,2),
  median_income INTEGER,
  unemployment_rate NUMERIC(5,2)
);
