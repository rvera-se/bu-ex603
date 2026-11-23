# Task 6.1

## **1. Why compare each event to its group’s average?**

A useful question would be: **Was a particular trip's fare unusually high or low compared with the average fare of the driver who provided it?**

Showing each trip alongside its driver's average fare allows leadership to identify individual trips that differ significantly from that driver's typical fares. The `AVG() OVER (PARTITION BY driver_id)` window function makes this comparison possible because it calculates the average while keeping every trip as a separate row.

A `GROUP BY` query only returns the average fare for each driver. It combines all that driver's trips into one result, removing the individual trip information. Therefore, the average alone cannot show which specific trips were above or below the driver's average.

## **2. Ranking and fairness**

A platform feature that could use producer rankings is a **driver leaderboard** that displays the drivers with the most completed trips. I would use `DENSE_RANK()` because drivers who complete the same number of trips should receive the same ranking. Unlike `RANK()`, it does not skip positions after a tie, making the leaderboard easier to understand. It also avoids arbitrarily placing one driver above another when their performance is equal.

`ROW_NUMBER()` would not be the best choice because it assigns every driver a different position, even when they have the same number of trips. `RANK()` handles ties fairly but skips positions afterward. `DENSE_RANK()` recognizes equal performance without creating gaps in the leaderboard.

# Task 6.2

## **1. What would a large delta tell someone about your platform, and what should they do about it?**

A large delta indicates a significant change in the fare between consecutive trips. A sudden increase could be caused by a longer trip, higher surge pricing, or a change in demand. A sudden decrease could indicate a shorter trip, lower pricing, or a cancelled trip with a fare of zero. Leadership should investigate the trip details, including distance, surge multiplier, trip status, and cancellation reason, to determine whether the change is expected or indicates a potential issue.

## **2. Why does a running total answer a question that a plain SUM cannot?**

A plain `SUM()` calculates the total fare revenue across all trips, but it does not show how that total accumulated over time. A running total shows the cumulative revenue after each trip, allowing leadership to see how revenue developed, identify when the platform reached certain milestones, and determine how close it was to the $5,000 target at different points in the year.

## **3. Why did you pick your moving-average window size? A different size tells a different story.**

I chose a seven-trip moving average because it provides a short-term view of recent fare activity while reducing the effect of unusually high or low individual fares. A smaller window would react more quickly to individual changes, while a larger window would produce a smoother trend but could hide recent changes in platform activity. Since the window uses seven rows rather than seven calendar days, the period it represents depends on how frequently trips occur.

## **4. What does a gap mean in your platform: a data quality problem, a real stop in activity, or a side effect of how events were recorded? Each needs a different response. Say which one yours is and how you know.**

The gap identified for Driver 5 shows that no trips were recorded between February 1, 2023, and May 5, 2023, approximately 93 days. I would classify this as a period of recorded inactivity rather than immediately assuming a data quality problem. The database confirms that the driver had trips before and after this period, but it does not provide enough historical information to determine why the gap occurred. Driver 5 is currently marked as active in the drivers table, but that does not establish whether the driver was active throughout the missing period. Leadership should investigate historical driver activity records to determine whether the driver temporarily stopped accepting trips or whether some events were not recorded.

# Task 6.3
