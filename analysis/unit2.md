##### The constraints table

| Foreign Key                                             | ON DELETE Choice | Reason                                                                                                                                                                     |
| ------------------------------------------------------- | ---------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Trips.rider_id → Riders.rider_id`                      | `RESTRICT`       | A rider cannot be deleted while they have trips associated with their account because deleting the rider would compromise the historical record of those trips.            |
| `Trips.driver_id → Drivers.driver_id`                   | `RESTRICT`       | A driver cannot be deleted while they have trips associated with their account because completed trip records should remain associated with the driver who performed them. |
| `Driver_Badge_Awards.driver_id → Drivers.driver_id`     | `CASCADE`        | When a driver is removed, their associated badge-award records are automatically removed because those records have no meaningful existence without the driver.            |
| `Driver_Badge_Awards.badge_id → Driver_Badges.badge_id` | `RESTRICT`       | A badge cannot be deleted while it has been awarded to drivers because removing the badge definition would leave existing award records without a valid badge.             |

### ON DELETE Choices in Detail

#### `Trips.rider_id → Riders.rider_id` — `RESTRICT`

This constraint governs what happens when a **rider is removed from the platform**. If the rider has existing trips, the deletion is rejected. Their historical trips remain intact and continue to identify the rider who participated in each trip.

Using `CASCADE` instead would delete all of the rider's associated trips when the rider is removed. This would cause the platform to lose historical trip information, including fare amounts, dates, pickup locations, and drop-off locations. Since trips represent completed transactions, automatically deleting them would make the database lose important historical records.

#### `Trips.driver_id → Drivers.driver_id` — `RESTRICT`

This constraint governs what happens when a **driver is removed from the platform**. If the driver has completed trips, the deletion is rejected so that those trips continue to reference the driver who performed them.

Using `CASCADE` instead would delete every trip associated with that driver. This would remove historical transaction records simply because the driver's account was removed. The platform would lose information about completed rides, including their fares, dates, and locations.

#### `Driver_Badge_Awards.driver_id → Drivers.driver_id` — `CASCADE`

This constraint governs what happens to a driver's **badge-award records when the driver is removed**. When a driver is deleted, all records in `Driver_Badge_Awards` belonging to that driver are automatically deleted.

These records describe a relationship between a specific driver and a badge. Once the driver no longer exists, those relationship records have no useful standalone meaning.

Using `RESTRICT` instead would prevent the driver from being deleted as long as they had any badge awards. This would unnecessarily block driver removal because the badge-award records are dependent records that can safely be removed along with the driver.

#### `Driver_Badge_Awards.badge_id → Driver_Badges.badge_id` — `RESTRICT`

This constraint governs what happens when a **badge definition is removed from the platform**. If the badge has already been awarded to any drivers, the deletion is rejected.

Using `CASCADE` instead would delete all award records associated with that badge. This could erase the historical record that drivers earned the badge. `RESTRICT` therefore ensures that a badge cannot be removed while existing driver-award records depend on it.

---

##### The CHECK constraints

The database contains one `CHECK` constraint:

| CHECK Constraint                             | Invalid State Prevented                             | How the Invalid State Could Otherwise Arise                                                                                                                                         |
| -------------------------------------------- | --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `chk_trips_fare_amount` — `fare_amount >= 0` | Prevents a trip from having a negative fare amount. | Without the constraint, an `INSERT` or `UPDATE` could assign a negative value to `fare_amount`, representing a transaction in which the platform charges a rider a negative amount. |

### `chk_trips_fare_amount`

The `chk_trips_fare_amount` constraint requires every trip's `fare_amount` to be greater than or equal to zero.

The invalid state it prevents is a **negative trip fare**. A negative fare does not represent a valid charge for a completed ride. Without the `CHECK` constraint, an application or database user could accidentally insert a value such as `-25.00` or update an existing trip to a negative amount.

For example, the following operation would be rejected:

```sql
INSERT INTO Trips (
    rider_id,
    driver_id,
    fare_amount,
    trip_date,
    pickup_location,
    dropoff_location
)
VALUES (
    1,
    1,
    -25.00,
    CURRENT_TIMESTAMP,
    'Miami Airport',
    'Downtown Miami'
);
```
The constraint prevents this invalid financial state from being stored in the database, regardless of whether the invalid value originates from an application error or a direct SQL operation.
