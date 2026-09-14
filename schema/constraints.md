# Data Integrity Constraints
## 1. Riders
rider_id is the primary key, so every rider must have a unique identifier.  
rider_name, phone_number, and email should be NOT NULL.  
email should be UNIQUE to prevent duplicate rider accounts.  
## 2. Drivers
driver_id is the primary key, so every driver must have a unique identifier.  
driver_name, phone_number, and license_number should be NOT NULL.  
license_number should be UNIQUE, since a driver's license should identify only one driver.  
## 3. Trips
trip_id is the primary key.  
rider_id is a foreign key referencing Riders(rider_id).  
driver_id is a foreign key referencing Drivers(driver_id).  
fare_amount should be NOT NULL and must satisfy fare_amount >= 0.  
trip_date should be NOT NULL.  
pickup_location and dropoff_location should be NOT NULL.  
## 4. Driver_Badges
badge_id is the primary key.  
badge_name should be NOT NULL and UNIQUE.  
badge_description can be NOT NULL if every badge must have a description.  
## 5. Driver_Badge_Awards
(driver_id, badge_id) is the composite primary key.  
driver_id is a foreign key referencing Drivers(driver_id).  
badge_id is a foreign key referencing Driver_Badges(badge_id).  
award_date should be NOT NULL.  

## Foreign-Key ON DELETE Behavior:
### Trips.rider_id → Riders.rider_id	RESTRICT  
Justification: A rider should not be deleted if they have existing trips. Deleting the rider could destroy important trip history.  
### Trips.driver_id → Drivers.driver_id	RESTRICT  
Justification: A driver should not be deleted while their trips exist because those trips need to retain their driver information for historical and financial records.  
### Driver_Badge_Awards.driver_id → Drivers.driver_id	CASCADE  
Justification: If a driver is permanently removed, their badge-award records have no meaning without that driver, so the associated junction records can safely be removed.  
### Driver_Badge_Awards.badge_id → Driver_Badges.badge_id	RESTRICT  
Justification: A badge should not be deleted while it has been awarded to drivers. This prevents historical award records from becoming invalid.
