-- Task 5.1 Q1
-- Question: Which riders performed each trip, which drivers were associated with the trip,
-- and what was the trip's date and time.
-- Requirements: JOIN, ORDER BY
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

-- Task 5.1 Q2
-- Question: Which producers have been awarded badges, and which badges does each producer have?
-- Requirements: JOIN, ORDER BY
SELECT
    d.driver_id,
    d.driver_name,
    b.badge_name,
    a.awarded_on
FROM drivers d
JOIN driver_badge_awards a
    ON d.driver_id = a.driver_id
JOIN driver_badges b
    ON a.badge_id = b.badge_id
ORDER BY d.driver_id, b.badge_name;

-- Task 5.1 Q3
-- Question: Which producers (drivers) live in the same city?
-- Requirements: JOIN, AND, ORDER BY
SELECT
    d1.driver_name AS producer_1,
    d2.driver_name AS producer_2,
    d1.home_city
FROM drivers d1
JOIN drivers d2
    ON d1.home_city = d2.home_city
   AND d1.driver_id < d2.driver_id
ORDER BY d1.home_city, d1.driver_name;