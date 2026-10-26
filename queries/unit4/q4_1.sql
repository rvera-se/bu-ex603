-- 4.1.1 Calculate the count, total, average, minimum, and maximum
-- of fare_amount across the whole trips table, and how many distinct actors appear.
-- Requirements: COUNT, SUM, AVG, MIN, MAX, DISTINCT
SELECT
    COUNT(fare_amount) AS fare_count,
    SUM(fare_amount) AS total_fare,
    AVG(fare_amount) AS average_fare,
    MIN(fare_amount) AS minimum_fare,
    MAX(fare_amount) AS maximum_fare,
    COUNT(DISTINCT rider_id) AS distinct_actors
FROM trips;

-- 4.1.2 Calculate the trip count and average fare_amount for each driver.
-- Sort the results from the driver with the most trips to the driver with the fewest.
-- Requirements: COUNT, AVG, GROUP BY, ORDER BY, DESC
SELECT
    driver_id AS driver,
    COUNT(*) AS trip_count,
    AVG(fare_amount) AS average_fare
FROM trips
GROUP BY driver_id
ORDER BY trip_count DESC;

-- 4.1.3 Calculate driver, trip_count, and average_fare per driver of drivers that
-- Have completed at least 15 trips. Group by driver_id and order by trip amount on descending order.
-- I chose a minimum trip-count threshold for drivers.
-- Drivers with more trips generally have averages that are less affected by a few unusual events.
-- A driver with only 3 trips might have an unusually high or low average
-- that doesn't reflect their typical performance.
-- Requiring at least 15 trips allows drivers to be compared
-- with a more substantial amount of data.
-- Requirements: COUNT, AVG, GROUP BY, HAVING, ORDER BY, DESC
SELECT
    driver_id AS driver,
    COUNT(*) AS trip_count,
    AVG(fare_amount) AS average_fare
FROM trips
GROUP BY driver_id
HAVING COUNT(*) >= 15
ORDER BY trip_count DESC;

-- 4.1.4 Calculate the amount of trips, total fare, average fare, minimum fare, and maximum fare
-- of each driver per region.
-- Requirements: COUNT, SUM, AVG, MIN, MAX, GROUP BY, ORDER BY, DESC
SELECT
    pickup_city AS region,
    driver_id AS driver,
    COUNT(*) AS trip_count,
    SUM(fare_amount) AS total_fare,
    AVG(fare_amount) AS average_fare,
    MIN(fare_amount) AS minimum_fare,
    MAX(fare_amount) AS maximum_fare
FROM trips
GROUP BY pickup_city, driver_id
ORDER BY pickup_city, trip_count DESC;
