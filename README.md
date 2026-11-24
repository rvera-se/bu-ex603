# Roberto Vera
My chosen theme is Ride Sharing.
I modeled a system that tracks trips, drivers, riders, and driver achievements in the form of badges.  

## Domain
The platform is a ride-sharing service that connects riders with drivers who provide transportation. Riders use the platform to take trips, while drivers provide those trips. The system records information about riders and drivers, including their contact and identification information, as well as the details of each trip. Each trip records its rider, driver, pickup and drop-off locations, trip date and time, and fare amount. The platform also maintains a catalog of badges that drivers can earn and records which badges have been awarded to which drivers.  
  
The database must support questions about trip activity, rider usage, driver performance, and fares. For example, the platform should be able to determine how many trips a rider has taken, how many trips a driver has provided, and the total or average fare associated with a driver's trips. It should also be possible to determine which badges a driver has earned and which drivers have received a particular badge.  
  
The system therefore needs to preserve relationships between riders, trips, drivers, and driver badges while maintaining accurate historical information. In particular, trip records must remain associated with the appropriate rider and driver, and badge awards must correctly represent the many-to-many relationship between drivers and badges. This allows the platform to answer both operational questions, such as identifying the participants in a trip, and analytical questions, such as comparing driver activity or fares based on driver badges.

## Schema

The database is designed around a ride-sharing system consisting of riders, drivers, trips, and driver achievement badges. The schema uses primary keys, foreign keys, unique constraints, check constraints, and a junction table to maintain data integrity and represent the relationships between entities.

### Tables

#### `Riders`

Stores information about customers who use the ride-sharing service.

| Column         | Description                                      |
| -------------- | ------------------------------------------------ |
| `rider_id`     | Primary key and unique identifier for each rider |
| `rider_name`   | Rider's full name                                |
| `phone_number` | Rider's phone number                             |
| `email`        | Rider's email address; must be unique            |

**Design decisions:**
`rider_id` is an identity column used as the primary key. A unique constraint is placed on `email` to prevent multiple rider accounts from using the same email address. Required fields use `NOT NULL` to prevent incomplete rider records.

---

#### `Drivers`

Stores information about drivers registered with the service.

| Column           | Description                                       |
| ---------------- | ------------------------------------------------- |
| `driver_id`      | Primary key and unique identifier for each driver |
| `driver_name`    | Driver's full name                                |
| `phone_number`   | Driver's phone number                             |
| `license_number` | Driver's driver's license number; must be unique  |

**Design decisions:**
`driver_id` serves as the primary key, while `license_number` has a unique constraint because a driver's license should identify only one driver. Driver information is kept separate from trip information to avoid repeatedly storing the same driver details for every trip.

---

#### `Trips`

Represents individual rides completed through the service.

| Column             | Description                                     |
| ------------------ | ----------------------------------------------- |
| `trip_id`          | Primary key and unique identifier for each trip |
| `rider_id`         | Foreign key referencing `Riders`                |
| `driver_id`        | Foreign key referencing `Drivers`               |
| `fare_amount`      | Monetary cost of the trip                       |
| `trip_date`        | Date and time the trip occurred                 |
| `pickup_location`  | Starting location                               |
| `dropoff_location` | Destination                                     |

**Design decisions:**
`Trips` acts as the central transactional table connecting riders and drivers. Each trip must reference an existing rider and driver through foreign keys.

The `fare_amount` column uses `NUMERIC(10,2)` to represent currency accurately rather than using floating-point data types. A `CHECK` constraint ensures that fares cannot be negative.

The foreign keys use `ON DELETE RESTRICT`, preventing a rider or driver from being deleted while historical trips still reference them. This protects the integrity of the trip history.

---

#### `Driver_Badges`

Stores the available achievement badges that can be awarded to drivers.

| Column              | Description                                      |
| ------------------- | ------------------------------------------------ |
| `badge_id`          | Primary key and unique identifier for each badge |
| `badge_name`        | Name of the badge; must be unique                |
| `badge_description` | Description of what the badge represents         |

**Design decisions:**
Badges are stored separately from drivers so that badge information does not have to be duplicated for every driver who earns the same badge. The unique constraint on `badge_name` prevents duplicate badge definitions.

---

#### `Driver_Badge_Awards`

Junction table that records which badges have been awarded to which drivers.

| Column         | Description                             |
| -------------- | --------------------------------------- |
| `driver_id`    | Foreign key referencing `Drivers`       |
| `badge_id`     | Foreign key referencing `Driver_Badges` |
| `date_awarded` | Date the badge was awarded              |

**Design decisions:**
This table resolves the **many-to-many relationship** between drivers and badges. A driver can earn multiple badges, and the same badge can be awarded to multiple drivers.

The combination of `driver_id` and `badge_id` forms a **composite primary key**, preventing the same badge from being awarded to the same driver more than once.

`ON DELETE CASCADE` is used for the driver relationship so that badge-award records are automatically removed if the associated driver is deleted. The badge relationship uses `ON DELETE RESTRICT`, preventing a badge definition from being deleted while it is still referenced by award records.

---

### Relationships

The schema contains the following relationships:

* **Riders → Trips:** One-to-many. A rider can have multiple trips, while each trip belongs to one rider.
* **Drivers → Trips:** One-to-many. A driver can complete multiple trips, while each trip is associated with one driver.
* **Drivers ↔ Driver_Badges:** Many-to-many. Drivers can earn multiple badges, and badges can be earned by multiple drivers. This relationship is implemented through `Driver_Badge_Awards`.

### Key Design Principles

Several database design principles are reflected throughout the schema:

1. **Normalization** – Rider, driver, trip, and badge information are separated into appropriate tables to reduce redundant data.
2. **Referential Integrity** – Foreign keys ensure that trips and badge awards reference valid records.
3. **Data Integrity Constraints** – `NOT NULL`, `UNIQUE`, `CHECK`, and primary-key constraints prevent invalid or inconsistent data.
4. **Surrogate Keys** – Identity-based integer IDs provide stable identifiers for the major entities.
5. **Composite Key for the Junction Table** – `(driver_id, badge_id)` uniquely identifies each driver-badge relationship.
6. **Appropriate Data Types** – `NUMERIC(10,2)` is used for monetary values, while `TIMESTAMP` is used for trip dates to preserve both date and time.
7. **Controlled Deletion Behavior** – `ON DELETE RESTRICT` protects historical and referenced data, while `ON DELETE CASCADE` automatically cleans up dependent badge-award records when a driver is removed.

## ERD

<img width="902" height="559" alt="Ride Sharing drawio" src="https://github.com/user-attachments/assets/3318a899-a76d-47af-8a96-743395dfa898" />

## Query Catalogue

The following catalogue organizes the SQL queries by unit and identifies the business question each query addresses. Each identifier corresponds to a task or query within its associated SQL file.

### Unit 3 — Interrogating the Data

| Query ID | Business Question | SQL File |
|---|---|---|
| 3.1.1 | Which active drivers have an average rating of at least 4.5? | [q3_1.sql](queries/unit3/q3_1.sql) |
| 3.1.2 | What different trip statuses exist in the platform? | [q3_1.sql](queries/unit3/q3_1.sql) |
| 3.1.3a–b | Which trips meet distance requirements or originate in selected cities? | [q3_1.sql](queries/unit3/q3_1.sql) |
| 3.1.4a–b | How can driver names be filtered, and how should missing cancellation reasons be displayed? | [q3_1.sql](queries/unit3/q3_1.sql) |
| 3.1.5 | How can trips be categorized according to their distance? | [q3_1.sql](queries/unit3/q3_1.sql) |
| 3.2A–B | How do NULL values affect filtering and counting cancellation reasons? | [q3_2.sql](queries/unit3/q3_2.sql) |
| 3.2C | How can NULL cancellation reasons be included while excluding payment failures? | [q3_2.sql](queries/unit3/q3_2.sql) |
| 3.2D | How can fare per kilometer be calculated and filtered using an expression or CTE? | [q3_2.sql](queries/unit3/q3_2.sql) |
| 3.3.1 | Which riders were involved in disputed trips using a subquery? | [q3_3.sql](queries/unit3/q3_3.sql) |
| 3.3.2 | Which riders were involved in disputed trips using a CTE? | [q3_3.sql](queries/unit3/q3_3.sql) |
| 3.3.3 | Which riders were involved in disputed trips using EXISTS? | [q3_3.sql](queries/unit3/q3_3.sql) |
| 3.3.5 | Under what conditions could the three approaches return different rider sets? | [q3_3.sql](queries/unit3/q3_3.sql) |

### Unit 4 — Aggregation and Grouping

| Query ID | Business Question | SQL File |
|---|---|---|
| 4.1.1 | What are the overall fare statistics and number of distinct riders? | [q4_1.sql](queries/unit4/q4_1.sql) |
| 4.1.2 | How many trips does each driver complete, and what is their average fare? | [q4_1.sql](queries/unit4/q4_1.sql) |
| 4.1.3 | Which drivers have completed at least 15 trips, and what are their average fares? | [q4_1.sql](queries/unit4/q4_1.sql) |
| 4.1.4 | How do trip counts and fare statistics vary by driver and region? | [q4_1.sql](queries/unit4/q4_1.sql) |
| 4.2A | How many total and cancelled trips are associated with each driver? | [q4_2.sql](queries/unit4/q4_2.sql) |
| 4.2B | What are the regional cancellation totals and platform-wide grand total? | [q4_2.sql](queries/unit4/q4_2.sql) |
| 4.2C | What is the average trip volume and cancellation rate among high-volume drivers? | [q4_2.sql](queries/unit4/q4_2.sql) |

### Unit 5 — Joins and Relationships

| Query ID | Business Question | SQL File |
|---|---|---|
| 5.1.1 | Which riders and drivers are associated with each trip? | [q5_1.sql](queries/unit5/q5_1.sql) |
| 5.1.2 | Which drivers have earned badges, and which badges were awarded? | [q5_1.sql](queries/unit5/q5_1.sql) |
| 5.1.3 | Which pairs of drivers live in the same city? | [q5_1.sql](queries/unit5/q5_1.sql) |
| 5.2A1–A2 | How do LEFT JOIN and INNER JOIN differ when identifying drivers with trips? | [q5_2.sql](queries/unit5/q5_2.sql) |
| 5.2A3 | How many drivers have never participated in a trip? | [q5_2.sql](queries/unit5/q5_2.sql) |
| 5.2B1 | How can a RIGHT JOIN preserve all registered drivers? | [q5_2.sql](queries/unit5/q5_2.sql) |
| 5.2B2 | Are there unmatched drivers or trips when both tables are combined? | [q5_2.sql](queries/unit5/q5_2.sql) |
| 5.2C1–C2 | Which drivers have never completed a trip, using NOT EXISTS and EXCEPT? | [q5_2.sql](queries/unit5/q5_2.sql) |
| 5.3A1–A2 | How many driver-badge combinations can a CROSS JOIN generate? | [q5_3.sql](queries/unit5/q5_3.sql) |
| 5.3A3 | How can a CTE calculate the number of possible driver-badge combinations? | [q5_3.sql](queries/unit5/q5_3.sql) |
| 5.3B | How does PostgreSQL execute a multi-table join, and which join algorithms does it select? | [q5_3.sql](queries/unit5/q5_3.sql) |

### Unit 6 — Window Functions and Advanced Analysis

| Query ID | Business Question | SQL File |
|---|---|---|
| 6.1.1A–B | How does each trip's fare compare with its driver's average fare? | [q6_1.sql](queries/unit6/q6_1.sql) |
| 6.1.2 | How do ROW_NUMBER(), RANK(), and DENSE_RANK() rank drivers by trip volume? | [q6_1.sql](queries/unit6/q6_1.sql) |
| 6.1.3 | How can drivers be divided into four groups based on trip volume? | [q6_1.sql](queries/unit6/q6_1.sql) |
| 6.2A | How do consecutive trip fares change for an individual driver? | [q6_2.sql](queries/unit6/q6_2.sql) |
| 6.2B | How does cumulative fare revenue develop, and how close is the platform to its revenue target? | [q6_2.sql](queries/unit6/q6_2.sql) |
| 6.2C | When has a driver gone more than 30 days without a recorded trip? | [q6_2.sql](queries/unit6/q6_2.sql) |
| 6.3A | What are the three highest-fare trips for each driver? | [q6_3.sql](queries/unit6/q6_3.sql) |
| 6.3B | How do monthly fare totals change, and are there months without recorded trips? | [q6_3.sql](queries/unit6/q6_3.sql) |

## Technical Highlights

The project applies several SQL techniques to answer operational and analytical questions about the ride-sharing platform.

### 1. Joins and Many-to-Many Relationships

Multiple JOIN operations were used to combine riders, drivers, trips, and driver badges into meaningful reports. For example, the three-table join in Unit 5 connects riders and drivers through their associated trips, allowing the platform to identify both participants in each transaction.

The junction table, `Driver_Badge_Awards`, was also used to resolve the many-to-many relationship between drivers and badges. This allows the platform to retrieve actual badge assignments without generating unrelated combinations.

LEFT JOIN, RIGHT JOIN, and FULL OUTER JOIN were additionally compared to identify missing relationships and records that would otherwise be excluded.

**Why it was useful:** Joins allowed information stored across normalized tables to be combined into reports while preserving or identifying records that did not have matching relationships.

### 2. Aggregations, Conditional Logic, and CTEs

COUNT(), SUM(), AVG(), MIN(), and MAX() were used to analyze trip volume, fare statistics, and driver performance.

Conditional aggregation with CASE WHEN was applied to count cancelled trips separately from total trips. ROLLUP was also used to calculate regional subtotals and a platform-wide grand total within a single query.

In Unit 4, a Common Table Expression (CTE) named `driver_performance` first calculated each driver's trip count and cancelled trips. A second aggregation then established a performance baseline for drivers with at least 15 trips.

**Why it was useful:** These techniques transformed individual trip records into meaningful performance indicators, allowing leadership to compare drivers, evaluate cancellation patterns, and summarize platform activity.

### 3. Subqueries, EXISTS, and NULL Handling

Unit 3 explored SQL's three-valued logic and how NULL values affect filtering conditions. In particular, a comparison such as `cancellation_reason != 'Payment failed'` does not include NULL records because the comparison evaluates to UNKNOWN.

The project addressed this by using COALESCE to provide a replacement value and preserve records with missing cancellation reasons.

Subqueries, CTEs, and EXISTS were also compared when identifying riders involved in disputed trips.

**Why it was useful:** These techniques helped prevent missing records from being unintentionally excluded and demonstrated how different query structures can answer the same business question.

### 4. Window Functions and Analytical Rankings

Window functions were applied throughout Unit 6 to analyze individual trips without collapsing the underlying records.

Examples include:

- `AVG() OVER (PARTITION BY driver_id)` to compare each trip's fare with its driver's average.
- `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()` to evaluate different ranking methods for driver performance.
- `LAG()` and `LEAD()` to compare consecutive trip fares and identify periods of driver inactivity.
- `SUM() OVER()` and `AVG() OVER()` to calculate cumulative revenue and a seven-trip moving average.
- `NTILE(4)` to divide drivers into four groups based on their trip counts.

**Why it was useful:** Window functions allowed detailed trip-level information to remain visible while adding useful analytical context, making it possible to identify trends, compare performance, and develop leaderboard-style reports.

### 5. Query Optimization and Execution Plans

PostgreSQL's `EXPLAIN` command was used to inspect how the database executes a three-table join involving riders, drivers, and trips.

The execution plan identified a Hash Join between trips and riders, followed by a Nested Loop Join to retrieve matching drivers through the primary key index. PostgreSQL also used Memoize to cache repeated driver lookups and reduce unnecessary database work.

**Why it was useful:** Examining execution plans provided insight into how PostgreSQL selects join algorithms and uses indexes. It also helped identify operations, such as sorting and repeated lookups, that may become more expensive as the platform's dataset grows.

## Findings and Recommendations

The SQL analysis revealed several important patterns that could influence the platform's operational decisions.

### Finding 1: Some Drivers Have Never Participated in a Recorded Trip

The analysis identified 15 registered drivers, but only 13 had associated trip records. Drivers 14 and 15 had no recorded trips and were excluded from INNER JOIN results.

This distinction is important because a report based exclusively on INNER JOIN could create an incomplete picture of platform participation by excluding registered drivers who have never completed a trip.

**Recommendation:** Management should investigate the onboarding status, account activation, and availability of these two drivers. If they are expected to be active, the platform should contact them to identify potential barriers and help them complete their first trip.

### Finding 2: Trip Cancellations Remain an Operational Concern

The Unit 6 analysis identified an improvement in the cancellation rate during 2023, although progress largely stalled toward the end of the year.

| Quarter | Cancelled Trips | Cancellation Rate |
|---|---:|---:|
| Q1 2023 | 12 | 22.64% |
| Q2 2023 | 7 | 14.58% |
| Q3 2023 | 8 | 15.69% |
| Q4 2023 | 7 | 14.58% |

Across the year, 34 cancellations were recorded. Rider no-shows accounted for 12, rider cancellations for 8, payment failures for 7, and driver unavailability for 7.

Driver 11 had the highest cancellation count with 5, while Drivers 2, 6, and 9 each had 4.

**Recommendation:** Management should prioritize improving rider confirmation and reminder processes, investigating payment failures, and monitoring driver availability. Drivers with repeated cancellations should receive individual reviews, but cancellation responsibility should be established before attributing the problem to a particular driver.

### Finding 3: Reporting Accuracy Is Important for Driver Performance Decisions

The Unit 3 investigation identified a reporting issue involving disputed trips. The dashboard was associating disputed-trip activity with riders rather than correctly identifying the drivers involved.

Because riders request trips and drivers provide them, confusing these roles can result in the wrong accounts being flagged when determining whose bonuses should be frozen.

**Recommendation:** The dashboard should use the driver associated with each disputed trip when evaluating driver-related bonus decisions. Previously affected bonuses should be reviewed against the actual trip records and applicable bonus rules before any payment is withheld.

## Limitations and Future Improvements

One important limitation of this analysis is that the available dataset provides a relatively narrow view of platform activity. Although the trip records contain useful information about fares, cancellation reasons, distances, and driver participation, they do not provide enough historical operational context to establish why certain patterns occur.

For example, the analysis identified a period of approximately 93 days between Driver 5's recorded trips. However, the database does not contain sufficient historical availability or account-activity information to determine whether the driver temporarily stopped working, was unavailable, or had trips that were not recorded.

Similarly, an increase in fare amounts cannot automatically be attributed to higher demand, longer distances, or surge pricing without additional supporting information.

Future improvements could include:

- **Driver activity history:** Store account activation, availability, deactivation, and last-active timestamps to distinguish inactivity from missing trip records.
- **Trip distance and pricing details:** Include pricing breakdowns, surge multipliers, and actual trip durations to explain unusual fare changes.
- **Cancellation tracking:** Record the responsible party and detailed cancellation circumstances to distinguish rider-related issues from driver-related problems.
- **Larger historical datasets:** Analyze multiple years of trip records to identify seasonal patterns, long-term trends, and changes in driver retention.
- **Consistent performance metrics:** Establish standardized definitions for completed, cancelled, and disputed trips so that reports use consistent denominators and comparisons.

These improvements would provide management with a more complete understanding of platform performance and support more reliable operational decisions.
