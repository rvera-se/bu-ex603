-- Task 5.3 A1
-- Source tables are drivers and driver_badges
-- Question: How many drivers and badges will be included in the CROSS JOIN?
-- Requirements: COUNT, ORDER BY, LIMIT
SELECT COUNT(*) AS driver_count
FROM (
    SELECT driver_id
    FROM drivers
    ORDER BY driver_id
) AS selected_drivers;

SELECT COUNT(*) AS badge_count
FROM (
    SELECT badge_id
    FROM driver_badges
    ORDER BY badge_id
) AS selected_badges;

-- Task 5.3 A2
-- Question: What combinations are produced by combining drivers with driver_badges?
-- The result matches the multiplication of the source table counts: 15 x 5 = 75
-- Requirements: ORDER BY, CROSS JOIN
SELECT
    d.driver_id,
    d.driver_name,
    b.badge_id,
    b.badge_name
FROM (
    SELECT driver_id, driver_name
    FROM drivers
    ORDER BY driver_id
) AS d
CROSS JOIN (
    SELECT badge_id, badge_name
    FROM driver_badges
    ORDER BY badge_id
) AS b
ORDER BY d.driver_id, b.badge_id;

-- Question: How many rows are in each source table, and how many rows does their CROSS JOIN produce?
-- Requirements: ORDER BY, WITH, COUNT, CROSS JOIN
WITH selected_drivers AS (
    SELECT driver_id
    FROM drivers
    ORDER BY driver_id
),
selected_badges AS (
    SELECT badge_id
    FROM driver_badges
    ORDER BY badge_id
)
SELECT
    (SELECT COUNT(*) FROM selected_drivers) AS driver_count,
    (SELECT COUNT(*) FROM selected_badges) AS badge_count,
    (
        SELECT COUNT(*)
        FROM selected_drivers
        CROSS JOIN selected_badges
    ) AS cross_join_count;

-- Task 5.3 A3
-- A Cartesian product can be useful when every possible combination of two sets of records is needed.
-- For example, leadership could use a CROSS JOIN to generate combinations of drivers
-- and available badges when planning potential badge assignments.
-- However, a CROSS JOIN can indicate a query error when the intention was to match related records
-- but a join condition was accidentally omitted.
-- This can produce an unexpectedly large number of rows, increase query execution time,
-- and return misleading results.

-- Task 5.3 B
-- Question: How does the database plans to execute this query?
-- Requirements: JOIN, ORDER BY
EXPLAIN
SELECT
    r.rider_name AS actor,
    d.driver_name AS producer,
    t.requested_at AS event_date_time
FROM trips t
JOIN riders r
    ON t.rider_id = r.rider_id
JOIN drivers d
    ON t.driver_id = d.driver_id
ORDER BY t.requested_at;

/*
1. Identify the join algorithms used.
The query plan uses two main join algorithms:
- Hash Join: PostgreSQL joins `trips` and `riders` using `t.rider_id = r.rider_id`.
   It builds a hash table from the `riders` table and uses it to find matching riders for each trip.
- Nested Loop Join: PostgreSQL uses a Nested Loop to combine the results with the `drivers` table.
   It looks up the matching driver for each trip using the driver's primary key index.

The plan also uses a Memoize operation, which caches previously retrieved driver records
   to avoid repeating the same index lookup when multiple trips belong to the same driver.
   Finally, a Sort operation orders the results by `t.requested_at`.

2. Why PostgreSQL may have selected these algorithms?
PostgreSQL may have selected the Hash Join because the `riders` and `trips` tables are relatively small,
   making it efficient to build a hash table of riders and match trips against it.
   It selected a Nested Loop for the drivers because `drivers.driver_id` is a primary key with an available index,
   allowing PostgreSQL to quickly find matching drivers. Memoize further improves efficiency by caching repeated driver lookups.

Which part of the query might become less efficient as the dataset grows?
The Nested Loop Join and final Sort operation could become less efficient as the dataset grows.
   More trips could require additional driver lookups and more records to sort by `requested_at`.
   Although the primary key index and Memoize help reduce lookup costs,
   sorting a much larger result set could require more processing time and memory.
   PostgreSQL may eventually choose different execution strategies as the table sizes and data distribution change.
 */