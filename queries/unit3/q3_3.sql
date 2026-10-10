-- 3.3.1 Riders involved in disputed trips and information about those riders
-- Uses Subquery
-- Requirements: WHERE, ORDER BY
SELECT *
FROM riders
WHERE rider_id IN (
    SELECT rider_id
    FROM trips
    WHERE trip_status = 'disputed'
)
ORDER BY rider_id;

-- 3.3.2 Riders involved in disputed trips and information about those riders
-- Uses CTE
-- Requirements: DISTINCT, WHERE, JOIN, ORDER BY
WITH disputed_trips_riders AS (
    SELECT DISTINCT rider_id
    FROM trips
    WHERE trip_status = 'disputed'
)
SELECT r.*
FROM riders AS r
JOIN disputed_trips_riders AS dtr
    ON r.rider_id = dtr.rider_id
ORDER BY r.rider_id;

-- 3.3.3 Riders involved in disputed trips and information about those riders
-- Uses different subquery form
-- Requirements: WHERE, EXISTS, AND, ORDER BY
SELECT r.*
FROM riders AS r
WHERE EXISTS (
    SELECT 1
    FROM trips AS t
    WHERE t.rider_id = r.rider_id
      AND t.trip_status = 'disputed'
)
ORDER BY r.rider_id;

-- 3.3.5
-- There is no input condition involving only NULLs, duplicates, or empty results
-- that makes these exact three queries return different rider sets,
-- assuming the same underlying data and standard SQL behavior.