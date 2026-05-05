-- ============================================================
-- BOEING‑FOCUSED KEY PERFORMANCE INDICATORS
-- Run against the flights_enriched table
-- ============================================================

-- ----------------------------------------------------------
-- 1. DISPATCH RELIABILITY by OEM
-- (percentage of flights not cancelled for carrier reasons)
-- ----------------------------------------------------------
SELECT 
    oem,
    COUNT(*) AS total_flights,
    SUM(CASE WHEN cancelled = TRUE AND cancellation_code = 'A' THEN 1 ELSE 0 END) AS carrier_cancellations,
    ROUND(100.0 * (COUNT(*) - SUM(CASE WHEN cancelled = TRUE AND cancellation_code = 'A' THEN 1 ELSE 0 END)) / COUNT(*), 2) AS dispatch_reliability_pct
FROM flights_enriched
GROUP BY oem
ORDER BY dispatch_reliability_pct DESC;


-- ----------------------------------------------------------
-- 2. LATE‑AIRCRAFT CASCADE DELAY (Boeing vs. Airbus families)
-- ----------------------------------------------------------
SELECT 
    aircraft_family,
    COUNT(*) AS flights,
    ROUND(AVG(late_aircraft_delay), 1) AS avg_late_ac_min,
    PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY late_aircraft_delay) AS p90_late_ac_min,
    ROUND(SUM(late_aircraft_delay) * 31.0, 0) AS est_cascade_cost_usd
FROM flights_enriched
WHERE oem IN ('Boeing', 'Airbus')
GROUP BY aircraft_family
ORDER BY avg_late_ac_min DESC;


-- ----------------------------------------------------------
-- 3. CARRIER DELAY BY AIRCRAFT VINTAGE (age buckets)
-- ----------------------------------------------------------
SELECT 
    oem,
    aircraft_family,
    CASE 
        WHEN EXTRACT(YEAR FROM CURRENT_DATE) - aircraft_year < 5  THEN '0-5 yr'
        WHEN EXTRACT(YEAR FROM CURRENT_DATE) - aircraft_year < 15 THEN '5-15 yr'
        ELSE '15+ yr'
    END AS age_bucket,
    COUNT(*) AS flights,
    ROUND(AVG(carrier_delay), 1) AS avg_carrier_delay_min
FROM flights_enriched
WHERE oem IN ('Boeing', 'Airbus')
GROUP BY oem, aircraft_family, age_bucket
ORDER BY avg_carrier_delay_min DESC;


-- ----------------------------------------------------------
-- 4. WORST BOEING ROUTES (controllable delay)
-- ----------------------------------------------------------
SELECT 
    origin,
    dest,
    aircraft_family,
    COUNT(*) AS flights,
    ROUND(AVG(arr_delay), 1) AS avg_arr_delay,
    ROUND(AVG(carrier_delay + late_aircraft_delay), 1) AS avg_controllable_delay
FROM flights_enriched
WHERE oem = 'Boeing'
  AND cancelled = FALSE
  AND diverted = FALSE
GROUP BY origin, dest, aircraft_family
HAVING COUNT(*) >= 50
ORDER BY avg_controllable_delay DESC
LIMIT 20;


-- ----------------------------------------------------------
-- 5. DELAY CAUSE ATTRIBUTION BY OEM (minutes & cost)
-- ----------------------------------------------------------
SELECT 
    oem,
    SUM(carrier_delay)        AS carrier_min,
    SUM(late_aircraft_delay)  AS late_ac_min,
    SUM(weather_delay)        AS weather_min,
    SUM(nas_delay)            AS nas_min,
    SUM(security_delay)       AS sec_min,
    ROUND(SUM(carrier_delay)        * 31.0, 0) AS carrier_cost_usd,
    ROUND(SUM(late_aircraft_delay)  * 31.0, 0) AS late_ac_cost_usd
FROM flights_enriched
WHERE oem IN ('Boeing', 'Airbus')
GROUP BY oem;
