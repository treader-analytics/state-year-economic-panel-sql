-- ============================================
-- 00_schema.sql
-- State-Year Economic Panel (PostgreSQL)
-- ============================================

CREATE SCHEMA IF NOT EXISTS econ;

-- Dimension table: U.S. states
CREATE TABLE IF NOT EXISTS econ.dim_state (
    state_fips CHAR(2) PRIMARY KEY,
    state_abbr CHAR(2) NOT NULL UNIQUE,
    state_name TEXT NOT NULL UNIQUE
);

-- Fact table: one row per state per year
CREATE TABLE IF NOT EXISTS econ.fact_state_year (
    state_fips CHAR(2) NOT NULL
        REFERENCES econ.dim_state(state_fips),
    year SMALLINT NOT NULL
        CHECK (year BETWEEN 1970 AND 2100),

    poverty_rate NUMERIC(5,2)
        CHECK (poverty_rate BETWEEN 0 AND 100),

    median_income INTEGER
        CHECK (median_income >= 0),

    unemployment_rate NUMERIC(5,2)
        CHECK (unemployment_rate BETWEEN 0 AND 100),

    poverty_population INTEGER
        CHECK (poverty_population >= 0),

    labor_force INTEGER
        CHECK (labor_force >= 0),

    PRIMARY KEY (state_fips, year)
);
