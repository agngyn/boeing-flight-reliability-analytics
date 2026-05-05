-- ============================================================
-- RAW FLIGHTS TABLE (BTS On-Time Performance, Jan 2025 – Jan 2026)
-- 33 columns selected from TranStats
-- ============================================================
CREATE TABLE IF NOT EXISTS raw_flights (
    year                INT,
    month               INT,
    day_of_month        INT,
    day_of_week         INT,
    flight_date         DATE,
    reporting_airline   TEXT,
    dot_id_reporting_airline INT,
    tail_number         TEXT,
    origin_airport_id   INT,
    origin              TEXT,
    origin_city_name    TEXT,
    origin_state        TEXT,
    origin_state_name   TEXT,
    dest_airport_id     INT,
    dest                TEXT,
    dest_city_name      TEXT,
    dest_state          TEXT,
    dest_state_name     TEXT,
    crs_dep_time        TEXT,
    dep_time            TEXT,
    dep_delay           REAL,
    crs_arr_time        TEXT,
    arr_time            TEXT,
    arr_delay           REAL,
    cancelled           BOOLEAN,
    cancellation_code   TEXT,
    diverted            BOOLEAN,
    distance            REAL,
    carrier_delay       REAL,
    weather_delay       REAL,
    nas_delay           REAL,
    security_delay      REAL,
    late_aircraft_delay REAL
);

-- ============================================================
-- FAA AIRCRAFT LOOKUP TABLE (populated by Python script)
-- ============================================================
CREATE TABLE IF NOT EXISTS faa_lookup (
    tail_num        TEXT PRIMARY KEY,
    manufacturer    TEXT,
    model           TEXT,
    num_engines     INT,
    num_seats       INT,
    aircraft_year   INT,
    oem             TEXT,          -- 'Boeing', 'Airbus', or 'Other'
    aircraft_family TEXT           -- '737 Family', '787 Family', 'A320 Family', or 'Other'
);

-- ============================================================
-- ENRICHED FLIGHTS VIEW (join raw_flights + faa_lookup)
-- Created and materialised by cleaning_enrichment.sql
-- ============================================================
-- (Not created here; see cleaning_enrichment.sql)
