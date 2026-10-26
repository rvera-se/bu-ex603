-- 4.2 Part A
-- Compute the total number of trips and the total number of trips classified as failures per driver
-- Requirements: COUNT, SUM, CASE, WHEN, THEN, ELSE, GROUP BY, ORDER BY, DESC
SELECT
    driver_id AS driver,
    COUNT(*) AS total_trips,
    SUM(
        CASE
            WHEN trip_status = 'cancelled' THEN 1
            ELSE 0
        END
    ) AS failed_trips
FROM trips
GROUP BY driver_id
ORDER BY failed_trips DESC;

-- 4.2 Part B
-- Produces regional subtotals and a platform-wide grand total
-- Without including the individual detail rows.
-- Requirements: CASE, WHEN, THEN, COUNT, SUM, GROUP BY, ORDER BY, ROLLUP
SELECT
    CASE
        WHEN GROUPING(pickup_city) = 1 THEN 'GRAND TOTAL'
        ELSE pickup_city
    END AS region,
    COUNT(*) AS total_trips,
    SUM(
        CASE
            WHEN trip_status = 'cancelled' THEN 1
            ELSE 0
        END
    ) AS failed_trips
FROM trips
GROUP BY ROLLUP (pickup_city)
ORDER BY
    GROUPING(pickup_city),
    pickup_city;

-- 4.2 Part C
-- Create an intermediate result that summarizes performance for each producer,
-- Then use a second aggregation or filter on that intermediate result to
-- Calculate a baseline for high-volume producers.
-- Requirements: WITH, COUNT, SUM, CASE, WHEN, THEN, GROUP BY, AVG, NULLIF
WITH driver_performance AS (
    SELECT
        driver_id AS driver,
        COUNT(*) AS total_trips,
        SUM(
            CASE
                WHEN trip_status = 'cancelled' THEN 1
                ELSE 0
            END
        ) AS failed_trips
    FROM trips
    GROUP BY driver_id
)
SELECT
    COUNT(*) AS high_volume_drivers,
    AVG(total_trips) AS avg_trips,
    AVG(failed_trips) AS avg_failed_trips,
    AVG(
        ROUND(
                1.0 * failed_trips / NULLIF(total_trips, 0)
        , 4)
    ) AS avg_failure_rate
FROM driver_performance
WHERE total_trips >= 15;
