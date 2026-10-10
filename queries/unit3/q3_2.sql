-- 3.2a
-- Filter trips where cancellation_reason is not 'Payment failed'
-- Requirements: WHERE
SELECT trip_id, cancellation_reason
FROM trips
WHERE cancellation_reason != 'Payment failed';

-- 3.2a
-- Filter trips where cancellation_reason IS NULL
-- Requirements: WHERE
SELECT trip_id, cancellation_reason
FROM trips
WHERE cancellation_reason IS NULL;

-- 3.2a Counts
-- Count the trips where cancellation_reason is not 'Payment failed' as notNullRowCount
-- Count the trips where cancellation_reason IS NULL as nullRowCount
-- Count the total rows in trips table as totalTableRowsCount
-- Requirements: COUNT, WHEN, CASE, THEN, END, IS, NULL
SELECT
    COUNT(CASE WHEN cancellation_reason != 'Payment failed' THEN 1 END) AS notNullRowCount,
    COUNT(CASE WHEN cancellation_reason IS NULL THEN 1 END) AS nullRowCount,
    COUNT(*) AS totalTableRowsCount
FROM trips;

-- 3.2a Fixed Query
-- Count the trips where cancellation_reason is not 'Payment failed',
-- Include NULL rows and COALESCE into 'Unknown reason'
-- Requirements: COALESCE, WHERE
SELECT trip_id, COALESCE(cancellation_reason, 'Unknown reason') AS cancellation_reason
FROM trips
WHERE COALESCE(cancellation_reason, '') != 'Payment failed';

-- 3.2b Broken query
-- Supposed to return fare amount per kilometer where the amount is greater than two,
-- However, the query fails.
-- Requirements: WHERE
SELECT fare_amount / distance_km as farePerKm
FROM trips
WHERE farePerKm > 2;

-- 3.2b Rewrite 1
-- Fare amount per kilometer where the amount is greater than two by rewriting the equation.
-- Requirements: WHERE
SELECT fare_amount / distance_km as farePerKm
FROM trips
WHERE fare_amount / distance_km > 2;

-- 3.2b Rewrite 2
-- Fare amount per kilometer where the amount is greater than two using a CTE
-- Requirements: WITH, WHERE
WITH fares_per_kilometer AS (
    SELECT
        fare_amount / distance_km as farePerKm
    FROM trips
)
SELECT farePerKm
FROM fares_per_kilometer
WHERE farePerKm > 2;