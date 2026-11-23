## **1. Is the failure problem getting better or worse?**

The cancellation problem is **getting better compared with the beginning of the year, but the improvement has largely stalled**. I used cancelled trips as the definition of failure and calculated the cancellation rate against all requested trips.

The quarterly results show that the cancellation rate dropped from **22.64% in Q1 to 14.58% in Q2**. However, it increased slightly to **15.69% in Q3** before returning to **14.58% in Q4**. This suggests that the platform made progress, but cancellations remain a recurring problem rather than continuing to decline.

**Query 1 – Quarterly cancellation trend**

```
-- Task: Analyze the quarterly cancellation rate.
-- Question: Is the percentage of cancelled trips improving over time?

SELECT
    DATE_TRUNC('quarter', requested_at)::date AS quarter,
    COUNT(*) AS total_trips,
    COUNT(*) FILTER (
        WHERE trip_status = 'cancelled'
    ) AS cancelled_trips,
    ROUND(
        COUNT(*) FILTER (
            WHERE trip_status = 'cancelled'
        ) * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate
FROM trips
GROUP BY DATE_TRUNC('quarter', requested_at)
ORDER BY quarter;
```

| Quarter | Cancelled trips | Cancellation rate |
| ------- | --------------- | ----------------- |
| Q1 2023 | 12              | 22.64%            |
| Q2 2023 | 7               | 14.58%            |
| Q3 2023 | 8               | 15.69%            |
| Q4 2023 | 7               | 14.58%            |

## **2. What should the team do next quarter?**

The team should focus on reducing cancellations by addressing the most common cancellation reasons. Across the year, there were 34 cancelled trips. Rider no-shows accounted for 12, rider cancellations for 8, payment failures for 7, and driver unavailability for 7. Therefore, I recommend improving rider confirmation and reminder processes, reviewing payment processing issues, and monitoring driver availability.

The team should also investigate drivers with higher cancellation counts. Driver 11 had the highest number of cancellations, with 5, while Drivers 2, 6, and 9 each had 4. These drivers should receive individual reviews to determine whether the cancellations are related to availability or other recurring issues.

**Query 2 – Cancellation reasons**

```
-- Task: Identify the most common cancellation reasons.
-- Question: What are the main causes of failed trips?

SELECT
    cancellation_reason,
    COUNT(*) AS cancellation_count
FROM trips
WHERE trip_status = 'cancelled'
GROUP BY cancellation_reason
ORDER BY cancellation_count DESC;
```

**Query 3 – Drivers with the most cancellations**

```
-- Task: Identify drivers with the highest cancellation counts.
-- Question: Which drivers should receive additional performance reviews?

SELECT
    d.driver_id,
    d.driver_name,
    COUNT(t.trip_id) AS cancelled_trips
FROM drivers d
JOIN trips t
    ON d.driver_id = t.driver_id
WHERE t.trip_status = 'cancelled'
GROUP BY d.driver_id, d.driver_name
ORDER BY cancelled_trips DESC, d.driver_id;
```

**Overall recommendation:** Next quarter, management should prioritize reducing rider no-shows, resolving payment failures, and reviewing driver availability. The team should monitor cancellation rates monthly and compare them with the previous quarter to determine whether these actions are producing measurable improvements.

*Dataset note: The analysis covers January through December 2023. Disputed trips were not counted as failures because this analysis defines failures specifically as cancelled trips.*&#x20;
