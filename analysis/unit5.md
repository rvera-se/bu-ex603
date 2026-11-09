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
