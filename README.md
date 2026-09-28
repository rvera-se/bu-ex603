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

<img width="902" height="559" alt="Ride Sharing drawio" src="https://github.com/user-attachments/assets/3318a899-a76d-47af-8a96-743395dfa898" />
