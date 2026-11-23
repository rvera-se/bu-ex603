-- Task 6.1.1A: Compare each event's fare to its producer's average fare.
-- Question: What is each trip's fare, and what is the average fare of the driver who provided it?

SELECT
    trip_id,
    driver_id,
    fare_amount,
    AVG(fare_amount) OVER (
        PARTITION BY driver_id
    ) AS producer_avg_fare
FROM trips
ORDER BY driver_id, trip_id;

-- Task 6.1.1B: Calculate the average fare for each producer.
-- Question: What is the average fare across all trips for each driver?

SELECT
    d.driver_id,
    d.driver_name,
    AVG(t.fare_amount) AS producer_avg_fare
FROM drivers d
JOIN trips t
    ON d.driver_id = t.driver_id
GROUP BY
    d.driver_id,
    d.driver_name
ORDER BY d.driver_id;

-- Window function displays 200 rows. Shows every trip, alongside its driver's average fare
-- GROUP BY	version displays 13 rows. Shows one average per driver who has trips
-- The window function calculates the average without collapsing individual trip records.
-- The GROUP BY version combines the trips into one result per driver,
-- losing the individual trip details and making it impossible to compare each trip's fare directly
-- with the average in that same result.

-- Task 6.1.2: Rank producers by their number of events using three methods.
-- Question: How does each driver's position change when using ROW_NUMBER(), RANK(), and DENSE_RANK()?

SELECT
    d.driver_id,
    d.driver_name,
    COUNT(t.trip_id) AS event_count,

    ROW_NUMBER() OVER (
        ORDER BY COUNT(t.trip_id) DESC, d.driver_id
    ) AS row_number_rank,

    RANK() OVER (
        ORDER BY COUNT(t.trip_id) DESC
    ) AS rank_position,

    DENSE_RANK() OVER (
        ORDER BY COUNT(t.trip_id) DESC
    ) AS dense_rank_position

FROM drivers d
LEFT JOIN trips t
    ON d.driver_id = t.driver_id
GROUP BY
    d.driver_id,
    d.driver_name
ORDER BY
    event_count DESC,
    d.driver_id;

-- Task 6.1.3: Divide producers into four groups based on their number of events.
-- Question: Which group does each driver belong to when drivers are sorted by trip count?

WITH producer_event_counts AS (
    SELECT
        d.driver_id,
        d.driver_name,
        COUNT(t.trip_id) AS event_count
    FROM drivers d
    LEFT JOIN trips t
        ON d.driver_id = t.driver_id
    GROUP BY
        d.driver_id,
        d.driver_name
)

SELECT
    driver_id,
    driver_name,
    event_count,
    NTILE(4) OVER (
        ORDER BY event_count DESC, driver_id
    ) AS producer_band
FROM producer_event_counts
ORDER BY
    producer_band,
    event_count DESC,
    driver_id;