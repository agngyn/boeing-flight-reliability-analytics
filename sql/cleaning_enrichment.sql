-- ============================================================
-- CLEANING & ENRICHMENT
-- 1. Filter domestic flights (U.S. origins and destinations)
-- 2. Trim tail numbers and join with FAA lookup
-- 3. Add OEM, aircraft family, and numeric times
-- 4. Create materialised table flights_enriched
-- ============================================================

-- A. Create a domestic airport list (50 states + DC)
DROP TABLE IF EXISTS domestic_airports;
CREATE TEMP TABLE domestic_airports AS
SELECT DISTINCT origin AS airport
FROM raw_flights
WHERE origin_state IN (
    'AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA',
    'HI','ID','IL','IN','IA','KS','KY','LA','ME','MD',
    'MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ',
    'NM','NY','NC','ND','OH','OK','OR','PA','RI','SC',
    'SD','TN','TX','UT','VT','VA','WA','WV','WI','WY','DC'
);

-- B. Build the enriched flights table
DROP TABLE IF EXISTS flights_enriched;
CREATE TABLE flights_enriched AS
SELECT
    f.flight_date,
    f.reporting_airline,
    f.dot_id_reporting_airline,
    TRIM(f.tail_number) AS tail_number,
    f.origin_airport_id,
    f.origin,
    f.origin_city_name,
    f.origin_state,
    f.dest_airport_id,
    f.dest,
    f.dest_city_name,
    f.dest_state,
    -- Convert time strings to integers (e.g., '1230' -> 1230)
    NULLIF(f.crs_dep_time, '')::INT AS crs_dep_time,
    NULLIF(f.dep_time, '')::INT    AS dep_time,
    f.dep_delay,
    NULLIF(f.crs_arr_time, '')::INT AS crs_arr_time,
    NULLIF(f.arr_time, '')::INT    AS arr_time,
    f.arr_delay,
    f.cancelled,
    f.cancellation_code,
    f.diverted,
    f.distance,
    COALESCE(f.carrier_delay, 0)        AS carrier_delay,
    COALESCE(f.weather_delay, 0)        AS weather_delay,
    COALESCE(f.nas_delay, 0)            AS nas_delay,
    COALESCE(f.security_delay, 0)       AS security_delay,
    COALESCE(f.late_aircraft_delay, 0)  AS late_aircraft_delay,
    -- Enrichment from FAA lookup
    l.manufacturer,
    l.model,
    l.num_engines,
    l.num_seats,
    l.aircraft_year,
    l.oem,
    l.aircraft_family
FROM raw_flights f
LEFT JOIN faa_lookup l
    ON TRIM(f.tail_number) = l.tail_num
WHERE f.origin IN (SELECT airport FROM domestic_airports)
  AND f.dest   IN (SELECT airport FROM domestic_airports)
  AND f.flight_date BETWEEN '2025-01-01' AND '2026-01-31';

-- C. Add indexes for performance
CREATE INDEX idx_flight_date   ON flights_enriched (flight_date);
CREATE INDEX idx_origin        ON flights_enriched (origin);
CREATE INDEX idx_dest          ON flights_enriched (dest);
CREATE INDEX idx_oem           ON flights_enriched (oem);
CREATE INDEX idx_aircraft_fam  ON flights_enriched (aircraft_family);
