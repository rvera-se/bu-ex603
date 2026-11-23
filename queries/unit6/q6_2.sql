-- Task 6.2A: Compare each trip's fare with the previous and next trip for Driver 5.
-- Question: How does Driver 5's fare change from one trip to the next over time?

SELECT
    trip_id,
    driver_id,
    requested_at,
    fare_amount,

    LAG(fare_amount) OVER (
        PARTITION BY driver_id
        ORDER BY requested_at, trip_id
    ) AS previous_fare,

    LEAD(fare_amount) OVER (
        PARTITION BY driver_id
        ORDER BY requested_at, trip_id
    ) AS next_fare,

    fare_amount - LAG(fare_amount) OVER (
        PARTITION BY driver_id
        ORDER BY requested_at, trip_id
    ) AS fare_delta

FROM trips
WHERE driver_id = 5
ORDER BY requested_at, trip_id;

-- Task 6.2B: Calculate cumulative fare revenue and a seven-trip moving average.
-- Question: How much fare revenue has the platform accumulated over time, and what is its recent average fare?

WITH fare_trends AS (
    SELECT
        trip_id,
        requested_at,
        fare_amount,

        SUM(fare_amount) OVER (
            ORDER BY requested_at, trip_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_total,

        AVG(fare_amount) OVER (
            ORDER BY requested_at, trip_id
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS moving_average

    FROM trips
)

SELECT
    trip_id,
    requested_at,
    fare_amount,
    running_total,
    ROUND(moving_average, 2) AS seven_trip_average,

    5000.00 AS revenue_target,

    ROUND(
        (running_total / 5000.00) * 100,
        2
    ) AS target_percentage,

    ROUND(
        5000.00 - running_total,
        2
    ) AS amount_remaining

FROM fare_trends
ORDER BY requested_at, trip_id;

-- Task 6.2C: Identify gaps longer than 30 days between Driver 5's trips.
-- Question: When did Driver 5 go more than 30 days without a recorded trip before returning?

WITH driver_trip_gaps AS (
    SELECT
        trip_id,
        driver_id,
        requested_at,

        LAG(requested_at) OVER (
            PARTITION BY driver_id
            ORDER BY requested_at, trip_id
        ) AS previous_trip_at

    FROM trips
    WHERE driver_id = 5
),

calculated_gaps AS (
    SELECT
        trip_id,
        driver_id,
        previous_trip_at,
        requested_at AS next_trip_at,
        requested_at - previous_trip_at AS gap_duration

    FROM driver_trip_gaps
    WHERE previous_trip_at IS NOT NULL
)

SELECT
    driver_id,
    previous_trip_at,
    next_trip_at,
    gap_duration,
    ROUND(
        EXTRACT(EPOCH FROM gap_duration) / 86400.0,
        2
    ) AS gap_in_days

FROM calculated_gaps
WHERE gap_duration > INTERVAL '30 days'
ORDER BY gap_duration DESC;