-- Task 5.2 A1
-- Question: Which producers have events, and which producers have never had an event?
-- Requirements: LEFT JOIN, ORDER BY
SELECT
    d.driver_id,
    d.driver_name,
    t.trip_id,
    t.requested_at AS event_date_time
FROM drivers d
LEFT JOIN trips t
    ON d.driver_id = t.driver_id
ORDER BY d.driver_id, t.trip_id;

-- Task 5.2 A2
-- Question: Which producers have at least one associated event?
-- Requirements: INNER JOIN, ORDER BY
SELECT
    d.driver_id,
    d.driver_name,
    t.trip_id,
    t.requested_at AS event_date_time
FROM drivers d
INNER JOIN trips t
    ON d.driver_id = t.driver_id
ORDER BY d.driver_id, t.trip_id;

-- Task 5.2 A3
-- Question: How many producers have no associated events and are excluded by INNER JOIN?
-- Requirements: COUNT, NOT EXISTS, WHERE
SELECT
    COUNT(*) AS excluded_producer_count
FROM drivers d
WHERE NOT EXISTS (
    SELECT 1
    FROM trips t
    WHERE t.driver_id = d.driver_id
);

-- Task 5.2 A4
-- The INNER JOIN excludes 2 producers, Driver_14 & Driver_15 because
-- neither Driver_14 nor Driver_15 has any associated records in the trips table.
-- The database contains 15 producers, but only 13 have participated in at least one event.
-- The LEFT JOIN preserves all 15 producers,
-- while the INNER JOIN only returns those with matching events.

-- Task 5.2 B1
-- Question: Which producers have events, and which producers have never had an event?
-- Requirements: RIGHT JOIN, ORDER BY
SELECT
    d.driver_id,
    d.driver_name,
    t.trip_id,
    t.requested_at AS event_date_time
FROM trips t
RIGHT JOIN drivers d
    ON t.driver_id = d.driver_id
ORDER BY d.driver_id, t.trip_id;

-- Task 5.2 B2
-- Question: Which producers have events, which producers have no events,
-- and are there any events without an associated producer?
-- Requirements: CASE, WHEN, IS NULL, THEN, FULL OUTER JOIN, ORDER BY
SELECT
    d.driver_id,
    d.driver_name,
    t.trip_id,
    t.requested_at AS event_date_time,
    CASE
        WHEN d.driver_id IS NULL THEN 'Trips without drivers'
        WHEN t.trip_id IS NULL THEN 'Drivers without trips'
        ELSE 'Matching record'
    END AS record_status
FROM drivers d
FULL OUTER JOIN trips t
    ON d.driver_id = t.driver_id
ORDER BY d.driver_id, t.trip_id;

-- Task 5.2 B3
-- A FULL OUTER JOIN can reveal unmatched records from both tables in a single query.
-- A LEFT JOIN preserves all records from the left table,
-- while a RIGHT JOIN preserves all records from the right table.
-- Neither alone preserves unmatched records from both sides.
-- For example, the previous query can identify drivers who have never participated in a trip
-- and trips that do not have an associated driver.
-- This is useful for identifying missing relationships and potential data integrity issues.

-- Task 5.2 C1
-- Question: Which producers have never had an event?
-- Requirements: WHERE, NOT EXISTS, ORDER BY
SELECT
    d.driver_id,
    d.driver_name
FROM drivers d
WHERE NOT EXISTS (
    SELECT 1
    FROM trips t
    WHERE t.driver_id = d.driver_id
)
ORDER BY d.driver_id;

-- Task 5.2 C2
-- Question: Which producers have never had an event?
-- Requirements: EXCEPT, JOIN, ORDER BY
SELECT
    d.driver_id,
    d.driver_name
FROM drivers d
EXCEPT
SELECT
    d.driver_id,
    d.driver_name
FROM drivers d
JOIN trips t
    ON d.driver_id = t.driver_id
ORDER BY driver_id;

-- Task 5.2 C3
-- NOT EXISTS checks each producer to see whether a matching event exists,
-- while EXCEPT subtracts producers who have events from the complete list of producers.
-- Both approaches identify the same two producers who have never had an event.