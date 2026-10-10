-- 3.1.1 Active, highly rated drivers — the producers whose records
--    anchor the audit. Requirement: SELECT, WHERE, ORDER BY, LIMIT.
SELECT driver_id, driver_name, avg_rating
FROM  drivers
WHERE is_active = TRUE
AND avg_rating >= 4.5
ORDER BY avg_rating DESC
LIMIT 10;

-- 3.1.2 All possible event (trips) statuses
-- Requirements: SELECT, DISTINCT
SELECT DISTINCT trip_status
FROM trips;

-- 3.1.3a Filters trips that are longer than 10 km.
-- Requirements: WHERE
SELECT *
FROM trips
WHERE distance_km >= 10.00;

-- 3.1.3b Filters trips from a specific list of cities.
-- Requirements: WHERE, IN
SELECT *
FROM trips
WHERE pickup_city IN ('Hue','Haiphong','Danang');

-- 3.1.4a Find drivers whose names end with 5.
SELECT driver_name
FROM drivers
WHERE driver_name LIKE '%5';

-- 3.1.4b Find trips where cancellation_reason is NULL. Label NULL reasons as "Unknown"
-- Requirements: COALESCE, WHERE, IS
SELECT trip_id, COALESCE(cancellation_reason, 'Unknown') AS nullCancelReasons
FROM trips
WHERE cancellation_reason IS NULL;

-- 3.1.5 Categorizes the trips by their distance.
-- Requirements: CASE, WHEN, THEN, AND, ELSE, END
SELECT trip_id, distance_km, CASE
    WHEN distance_km < 5.00 THEN 'Short'
    WHEN distance_km >= 5.00 AND distance_km <= 15.00 THEN 'Medium'
    WHEN distance_km > 15.00 THEN 'Long'
    ELSE 'Unknown'
    END
FROM trips;