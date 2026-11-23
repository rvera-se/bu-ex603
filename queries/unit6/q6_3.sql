-- Task 6.3A: Find the three highest-fare trips for each driver.
-- Question: Which three trips had the highest fare amounts for each driver?

WITH ranked_trips AS (
    SELECT
        t.driver_id,
        d.driver_name,
        t.trip_id,
        t.requested_at,
        t.fare_amount,

        ROW_NUMBER() OVER (
            PARTITION BY t.driver_id
            ORDER BY t.fare_amount DESC, t.requested_at, t.trip_id
        ) AS trip_rank,

        FIRST_VALUE(t.fare_amount) OVER (
            PARTITION BY t.driver_id
            ORDER BY t.fare_amount DESC, t.requested_at, t.trip_id
        ) AS highest_driver_fare

    FROM trips t
    JOIN drivers d
        ON t.driver_id = d.driver_id
)

SELECT
    driver_id,
    driver_name,
    trip_id,
    requested_at,
    fare_amount,
    trip_rank,
    highest_driver_fare
FROM ranked_trips
WHERE trip_rank <= 3
ORDER BY driver_id, trip_rank;

-- This query uses ROW_NUMBER(), so it returns exactly three trips per driver when the driver has
-- at least three trips. If multiple trips have the same fare at third place,
-- the earlier requested_at is selected; trip_id breaks any remaining ties.
-- This is useful for a leaderboard that must display exactly three results rather than
-- expanding beyond three because of ties.

-- Task 6.3B: Compare monthly fare totals with the previous month and identify missing months.
-- Question: Is the platform's monthly fare total increasing or decreasing, and are any months missing trip records?

WITH monthly_totals AS (
    SELECT
        DATE_TRUNC('month', requested_at)::date AS month_start,
        COUNT(*) AS trip_count,
        SUM(fare_amount) AS total_fare
    FROM trips
    GROUP BY DATE_TRUNC('month', requested_at)
),

month_bounds AS (
    SELECT
        MIN(month_start) AS first_month,
        MAX(month_start) AS last_month
    FROM monthly_totals
),

month_calendar AS (
    SELECT
        GENERATE_SERIES(
            first_month,
            last_month,
            INTERVAL '1 month'
        )::date AS month_start
    FROM month_bounds
),

monthly_series AS (
    SELECT
        c.month_start,
        COALESCE(m.trip_count, 0) AS trip_count,
        COALESCE(m.total_fare, 0.00) AS total_fare,

        CASE
            WHEN m.month_start IS NULL THEN TRUE
            ELSE FALSE
        END AS missing_month

    FROM month_calendar c
    LEFT JOIN monthly_totals m
        ON c.month_start = m.month_start
),

monthly_comparison AS (
    SELECT
        month_start,
        trip_count,
        total_fare,
        missing_month,

        LAG(total_fare) OVER (
            ORDER BY month_start
        ) AS previous_month_revenue

    FROM monthly_series
)

SELECT
    month_start,
    trip_count,
    ROUND(total_fare, 2) AS total_fare,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,

    ROUND(
        (
            (total_fare - previous_month_revenue)
            / NULLIF(previous_month_revenue, 0)
        ) * 100,
        2
    ) AS percent_change,

    missing_month

FROM monthly_comparison
ORDER BY month_start;