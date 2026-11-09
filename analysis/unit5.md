# Write Ups
## Task 5.1
### 1. What feature or report on your platform could use the three-table join from Question 1? What information would it display?

A trip activity report could use this three-table join to display information about each trip on the platform.
It would show the rider who requested the trip, the driver assigned to it, and the date and time the trip was requested.
This report would help administrators track trip activity, identify which drivers are serving which riders, and review the platform's overall activity.

### 2. Why is the junction table important for answering Question 2? What would make this analysis more difficult without it?
The junction table, driver_badge_awards, is important because it connects the producers (drivers) to the catalog (driver badges).
Since a driver can earn multiple badges and each badge can be awarded to multiple drivers, the relationship is many-to-many.
The junction table stores these associations and the date each badge was awarded.
Without it, connecting drivers to their badges would be more difficult because there would be no direct way to identify which badges 
belong to each driver or which drivers earned a particular badge.

## Task 5.2
### 1. Which producers were excluded by the inner join? Report their identifiers.
The two producers excluded by the inner join were Driver_14 (driver_id = 14) and Driver_15 (driver_id = 15). Neither producer has any associated trips in the database.

### 2. What does it mean when a producer has no events? What are some possible explanations?
A producer with no events has no recorded trips associated with their driver ID. This could mean the driver has never completed a trip, has not yet received a trip assignment, is no longer active, or has not started working on the platform. However, the data only confirms that no trips are recorded; it does not explain why.

### 3. How could a report based only on an inner join give leadership an incomplete picture of the platform?
A report based only on an inner join would exclude producers who have no associated events. As a result, leadership might believe that all registered producers are participating in platform activities, overlooking drivers who have never had a recorded trip.

### 4. Why might leadership want to identify producers who have never been active?
Leadership may want to identify producers with no recorded activity to better understand platform participation, evaluate driver onboarding and engagement, and determine whether registered drivers are contributing to the platform. Identifying these producers could also help reveal potential issues with recruitment, retention, or driver availability that require further investigation.

### 5. What action could leadership take based on these findings?
Leadership could investigate why Driver_14 and Driver_15 have no recorded trips by reviewing their onboarding status, account activity, and availability. If they are still expected to participate, leadership could contact them to identify possible barriers and offer assistance. If they are no longer active, their records or account statuses could be reviewed and updated accordingly.

Overall, the data confirms that two out of the fifteen producers have no recorded trips. It does not establish whether these drivers are inactive, unavailable, or experiencing other issues, so further investigation would be necessary before leadership decides what action to take.

## Task 5.3
### 1. Give an example of when a Cartesian product could be useful on your platform, or explain why you would not need one.
A Cartesian product could be useful on the ride-sharing platform when generating every possible combination of drivers and available badges for planning or analysis. However, it would not normally be needed when retrieving actual driver-badge assignments because the `driver_badge_awards` junction table already identifies which badges belong to each driver. Using a Cartesian product for that purpose would generate combinations that do not necessarily represent real assignments.

### 2. Which join algorithms did PostgreSQL choose for your query?
PostgreSQL selected two main join algorithms: a Hash Join and a Nested Loop Join. The Hash Join connects `trips` and `riders`, while the Nested Loop Join connects those results to `drivers`. PostgreSQL also uses a Memoize operation to cache repeated driver lookups.

### 3. What information in the execution plan helps explain those choices?
The execution plan shows that PostgreSQL estimates 200 rows in `trips` and 100 rows in `riders`. It uses sequential scans on both tables to build and search the hash table for the Hash Join. For the drivers, it uses an Index Scan on `drivers_pkey`, which takes advantage of the primary key index to locate matching drivers efficiently. The Memoize operation caches results using `t.driver_id` as its cache key, reducing repeated lookups. These details suggest PostgreSQL selected algorithms based on the estimated table sizes and available indexes.

### 4. Why is it useful to understand the selected join algorithms?
Understanding join algorithms helps developers identify potential performance bottlenecks and understand how PostgreSQL retrieves related records. It can also help determine whether indexes, query restructuring, or database optimization could improve performance as the platform grows. This is especially important for a ride-sharing platform where trip records can accumulate quickly.

### 5. What changes to the data or database might make another join algorithm more appropriate?
If the `trips` and `riders` tables grow significantly, PostgreSQL might choose a different strategy depending on the data distribution and available indexes. For example, if both tables become very large and have suitable indexes or are ordered by their join keys, a Merge Join might become more appropriate. If one table remains small and the other has an efficient index for the join condition, a Nested Loop Join could remain effective. Changes in table sizes, indexes, data distribution, and statistics can all influence PostgreSQL's decision.

Overall, the execution plan shows that PostgreSQL used a Hash Join for matching riders, a Nested Loop Join with indexed driver lookups, and Memoize to avoid repeated work. These choices were reasonable for the estimated 200 trips and the available primary key index, but the most efficient strategy may change as the platform's data grows.

## Reflection
PostgreSQL may choose a different join algorithm if the amount of data, available indexes, or number of matching records changes. In my execution plan, PostgreSQL estimated 200 rows in trips and 100 rows in riders. It used a Hash Join to match those tables, then a Nested Loop to find each driver through the drivers_pkey index. The Memoize operation cached repeated driver lookups.

If the tables became much larger, building and probing a hash table could require more memory, and PostgreSQL might choose a Merge Join if both inputs could be read efficiently in join-key order. A Merge Join could become attractive when suitable indexes or sorted inputs are available. On the other hand, if one table stayed small and the other had a useful index on its join key, a Nested Loop could remain efficient. Indexes on trips.rider_id or trips.driver_id could also change the cost estimates and make indexed lookups more attractive, depending on how many rows match. If most rows match, sequential scans and a Hash Join may still be cheaper than many individual index lookups. PostgreSQL also relies on table statistics to estimate row counts and match frequency, so running ANALYZE after substantial data changes helps it make informed choices. The best algorithm depends on the actual data and query, not simply on which algorithm seems fastest in general.
