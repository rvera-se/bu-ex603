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
