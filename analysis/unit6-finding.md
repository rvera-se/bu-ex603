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

| cancellation_reason | cancellation_count |
|---|---:|
| Rider no show | 12 |
| Rider cancelled | 8 |
| Payment failed | 7 |
| Driver unavailable | 7 |

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

| driver_id | driver_name | cancelled_trips |
|---:|---|---:|
| 11 | Driver_11 | 5 |
| 2 | Driver_02 | 4 |
| 6 | Driver_06 | 4 |
| 9 | Driver_09 | 4 |
| 3 | Driver_03 | 3 |
| 5 | Driver_05 | 3 |
| 7 | Driver_07 | 3 |
| 1 | Driver_01 | 2 |
| 4 | Driver_04 | 2 |
| 12 | Driver_12 | 2 |
| 8 | Driver_08 | 1 |
| 13 | Driver_13 | 1 |

**Overall recommendation:** Next quarter, management should prioritize reducing rider no-shows, resolving payment failures, and reviewing driver availability. The team should monitor cancellation rates monthly and compare them with the previous quarter to determine whether these actions are producing measurable improvements.

*Dataset note: The analysis covers January through December 2023. Disputed trips were not counted as failures because this analysis defines failures specifically as cancelled trips.*&#x20;
