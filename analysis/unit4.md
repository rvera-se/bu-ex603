# Task 4.1 Write Up
Name the person who would act on the per-producer breakdown, and say what the aggregate hides
— an average conceals its distribution, a count conceals who is counted. What would you need to see next?

### Who would act on it?
A regional operations manager or fleet manager would use the per-producer breakdown to identify drivers whose performance or trip volume may need attention.

### What does the aggregate hide?
Average fare: Hides the distribution. Two drivers can have the same average fare but very different ranges of fares or unusual outliers.

Event count: Hides who is being counted and the context. A high trip count doesn't necessarily mean better performance, and a low count may reflect fewer assigned trips rather than poor performance.

Regional summaries: Can hide differences between individual drivers and variations in demand across pickup cities.

### What would I need to see next?
Individual trip-level data to understand the distribution of fares.

A breakdown of successful versus failed or canceled trips, if available.

Driver-level comparisons within each pickup city, including trip volume and performance rates.

The time period covered, so we can distinguish persistent patterns from temporary fluctuations.

The goal is to move from summary statistics to the underlying records and context before deciding whether a driver or region needs intervention.

# Task 4.2 Write Up
## Part A
| Question 1 | Question 2 |
| --- | --- |
| What is the total number of trips for each driver? | How many trips were cancelled for each driver? |
## Part B
**Reader:** A regional operations manager or executive who needs summarized trip performance rather than individual trip records.

**Grand total decision:** The grand total shows the platform-wide number of trips and cancellations, helping stakeholders assess overall performance and whether cancellation-reduction targets are being met across all regions.
## Part C
The question the pipeline answers:

What is the average number of total trips, cancelled trips, and failure rate among high-volume drivers who completed at least 15 trips, and how many drivers meet that threshold?

#  Reflection
**Question:** Conditional aggregation computes several answers in one pass over the data. Contrast that with running two separate filtered queries. At a million rows, why does the difference matter?

Conditional aggregation is useful because it allows us to calculate multiple metrics in one query instead of running separate queries for each result. For example, when analyzing trip data, we can use COUNT(*) to calculate total trips and SUM(CASE WHEN trip_status = 'cancelled' THEN 1 ELSE 0 END) to count cancelled trips for each driver. Both results are produced together while grouping the data by driver.

In contrast, running two separate filtered queries means the database may need to scan the same table twice, once for total trips and again for cancelled trips. With a million rows, repeated scans can increase execution time and consume more system resources, especially when the table is large or the queries are run frequently. Conditional aggregation can reduce redundant work by calculating multiple metrics during the same query execution.

Another advantage is consistency. Since both metrics are calculated from the same dataset in one query, it is easier to compare total trips with cancelled trips without worrying that separate queries might use different filters or observe different data states.

However, conditional aggregation does not guarantee that every query will be faster. Performance depends on the database engine, indexes, filters, and execution plan. Overall, conditional aggregation makes reporting more efficient and keeps SQL easier to maintain when multiple related metrics are needed from the same data.
