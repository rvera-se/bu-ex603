# Roberto Vera
My chosen theme is Ride Sharing.
I modeled a system that tracks trips, drivers, riders, and driver achievements in the form of badges.  

## Domain
The platform is a ride-sharing service that connects riders with drivers who provide transportation. Riders use the platform to take trips, while drivers provide those trips. The system records information about riders and drivers, including their contact and identification information, as well as the details of each trip. Each trip records its rider, driver, pickup and drop-off locations, trip date and time, and fare amount. The platform also maintains a catalog of badges that drivers can earn and records which badges have been awarded to which drivers.  
  
The database must support questions about trip activity, rider usage, driver performance, and fares. For example, the platform should be able to determine how many trips a rider has taken, how many trips a driver has provided, and the total or average fare associated with a driver's trips. It should also be possible to determine which badges a driver has earned and which drivers have received a particular badge.  
  
The system therefore needs to preserve relationships between riders, trips, drivers, and driver badges while maintaining accurate historical information. In particular, trip records must remain associated with the appropriate rider and driver, and badge awards must correctly represent the many-to-many relationship between drivers and badges. This allows the platform to answer both operational questions, such as identifying the participants in a trip, and analytical questions, such as comparing driver activity or fares based on driver badges.  

<img width="852" height="602" alt="erd" src="https://github.com/user-attachments/assets/07a82d9e-ff55-4d35-953d-fa40663557cb" />
