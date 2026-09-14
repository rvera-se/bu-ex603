# Schema Definitions
## 1. Actor — Riders
Relation: Riders
Schema: Riders(rider_id, rider_name, phone_number, email)

Attribute	Domain
rider_id	Integer
rider_name	Variable-length string
phone_number	Variable-length string
email	Variable-length string

Primary key: rider_id

## 2. Producer — Drivers
Relation: Drivers
Schema: Drivers(driver_id, driver_name, phone_number, license_number)

Attribute	Domain
driver_id	Integer
driver_name	Variable-length string
phone_number	Variable-length string
license_number	Variable-length string

Primary key: driver_id

## 3. Event — Trips
Relation: Trips
Schema: Trips(trip_id, rider_id, driver_id, pickup_location, dropoff_location, trip_date, fare_amount)

Attribute	Domain
trip_id	Integer
rider_id	Integer
driver_id	Integer
pickup_location	Variable-length string
dropoff_location	Variable-length string
trip_date	Date/time
fare_amount	Decimal

Primary key: trip_id
Foreign keys: rider_id, driver_id

## 4. Catalog — Driver Badges
Relation: Driver_Badges
Schema: Driver_Badges(badge_id, badge_name, badge_description)

Attribute	Domain
badge_id	Integer
badge_name	Variable-length string
badge_description	Variable-length string

Primary key: badge_id

## 5. Junction — Driver Badge Awards
Relation: Driver_Badge_Awards
Schema: Driver_Badge_Awards(driver_id, badge_id, award_date)

Attribute	Domain
driver_id	Integer
badge_id	Integer
award_date	Date

Primary key: (driver_id, badge_id)
