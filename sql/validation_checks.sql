-- ============================================================
-- VALIDATION CHECKS
-- Run after loading and enriching the data.
-- ============================================================

-- Check 1: Row count and date range
SELECT 
    MIN(flight_date) AS min_date,
    MAX(flight_date) AS max_date,
    COUNT(*)        AS total_rows
FROM flights_enriched;

-- Expected: Jan 2025 – Jan 2026, ~7 million rows.

-- Check 2: Missing critical columns
SELECT
    COUNT(*) AS null_tail,
    COUNT(*) FILTER (WHERE tail_number IS NULL) AS null_tail,
    COUNT(*) FILTER (WHERE arr_delay IS NULL AND cancelled = FALSE AND diverted = FALSE) AS null_arr_delay
FROM flights_enriched;

-- Expected: very few null tails; null_arr_delay should be 0 or near 0.

-- Check 3: Domestic only
SELECT DISTINCT origin, origin_state 
FROM flights_enriched 
WHERE origin_state NOT IN ('AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA',
                           'HI','ID','IL','IN','IA','KS','KY','LA','ME','MD',
                           'MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ',
                           'NM','NY','NC','ND','OH','OK','OR','PA','RI','SC',
                           'SD','TN','TX','UT','VT','VA','WA','WV','WI','WY','DC');
-- Expected: no rows.

-- Check 4: Cancellation codes consistency
SELECT cancellation_code, COUNT(*) 
FROM flights_enriched 
WHERE cancelled = TRUE 
GROUP BY cancellation_code;

-- Check 5: OEM distribution
SELECT oem, COUNT(*) 
FROM flights_enriched 
GROUP BY oem 
ORDER BY COUNT(*) DESC;

-- Check 6: Duplicate flights (a flight should be unique per tail + date + flight number... but we lack flight number, so approximate)
-- For a rough check:
SELECT tail_number, flight_date, origin, dest, COUNT(*) 
FROM flights_enriched 
WHERE tail_number IS NOT NULL
GROUP BY tail_number, flight_date, origin, dest 
HAVING COUNT(*) > 1
LIMIT 10;
