# Task 6.1

## **1. Why compare each event to its group’s average?**

A useful question would be: **Was a particular trip's fare unusually high or low compared with the average fare of the driver who provided it?**

Showing each trip alongside its driver's average fare allows leadership to identify individual trips that differ significantly from that driver's typical fares. The `AVG() OVER (PARTITION BY driver_id)` window function makes this comparison possible because it calculates the average while keeping every trip as a separate row.

A `GROUP BY` query only returns the average fare for each driver. It combines all that driver's trips into one result, removing the individual trip information. Therefore, the average alone cannot show which specific trips were above or below the driver's average.

## **2. Ranking and fairness**

A platform feature that could use producer rankings is a **driver leaderboard** that displays the drivers with the most completed trips. I would use `DENSE_RANK()` because drivers who complete the same number of trips should receive the same ranking. Unlike `RANK()`, it does not skip positions after a tie, making the leaderboard easier to understand. It also avoids arbitrarily placing one driver above another when their performance is equal.

`ROW_NUMBER()` would not be the best choice because it assigns every driver a different position, even when they have the same number of trips. `RANK()` handles ties fairly but skips positions afterward. `DENSE_RANK()` recognizes equal performance without creating gaps in the leaderboard.

# Task 6.2
