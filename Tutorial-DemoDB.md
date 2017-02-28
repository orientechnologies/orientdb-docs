
Starting with OrientDB v.3.0 a new demo database is included.

This page (which is still a work in progress) lists some of the queries that is possible to execute on the new demo db

### LOCATIONS 

### Find all Attractions connected with Customer with OrderedId 1
```
MATCH {class: Customers, as: customer, where: (OrderedId=1)}--{Class: Attractions} 
RETURN $pathelements
```

### Find all Services connected with Customer with OrderedId 1
```
MATCH {class: Customers, as: customer, where: (OrderedId=1)}--{Class: Services} 
RETURN $pathelements
```

### Find all Locations visited by Customer with OrderedId 1
```
MATCH {as: n}<-HasVisited-{class: Customers, as: customer, where: (OrderedId=1)} 
RETURN $pathelements
```

### Find all Locations visited by Profile2 friends
```
MATCH {Class: Profiles, as: profile, where: (Id=2)}-HasFriend->{Class: Profiles, as: friend}<-HasProfile-{Class: Customers, as: customer}-HasVisited->{Class: Attractions, as: attraction} 
RETURN attraction.Name
```


### REVIEWS 

#### Find all reviewed Services
```
MATCH {class: Services, as: s}-HasReview->{class: Reviews, as: r} 
RETURN $pathelements
```

#### Find all reviewed Services and the Customer who made the review 
```
MATCH {class: Services, as: s}-HasReview->{class: Reviews, as: r}<-MadeReview-{class: Customers, as: c} 
RETURN $pathelements 
```

#### Find the numbers of reviews per Service 
```
SELECT *, out("HasReview").size() AS ReviewNumbers FROM `Services` ORDER BY ReviewNumbers DESC 
```

#### Find the 3 Places that have most reviews
```
SELECT *, out("HasReview").size() AS ReviewNumbers FROM `Services` ORDER BY ReviewNumbers DESC LIMIT 3
```

#### Find the 3 Hotels that have most reviews 
```
SELECT *, out("HasReview").size() AS ReviewNumbers FROM `Hotels` ORDER BY ReviewNumbers DESC LIMIT 3
```

#### Find the 3 Restaurants that have most reviews 
```
SELECT *, out("HasReview").size() AS ReviewNumbers FROM `Restaurants` ORDER BY ReviewNumbers DESC LIMIT 3
```

### HOTELS 
#### Find the 3 Hotels that have been booked most times
```
SELECT *, in("HasStayed").size() AS NumberOfBookings FROM Hotels ORDER BY NumberOfBookings DESC LIMIT 3
```
### CUSTOMERS 
	
#### Find everything that is connected (1st degree) to Customer with Id 1 
```
MATCH {class: Customers, as: c, where: (OrderedId=1)}--{as: n} RETURN $pathelements
```
#### Find all Orders placed by Customer with Id 1  
```
MATCH {class: Customers, as: c, where: (OrderedId=1)}<-HasCustomer-{class: Orders, as: o} 
RETURN $pathelements
```
#### Find the 3 Customers who placed most Orders
```
SELECT *, in("HasCustomer").size() AS NumberOfOrders FROM Customers ORDER BY NumberOfOrders DESC LIMIT 3
```
#### Find all Locations connected to Customer with Id 1
```
MATCH {class: Customers, as: customer, where: (OrderedId=1)}--{Class: Locations} 
RETURN $pathelements
```	
#### Find all Locations connected to Customer with Id 2, and their Reviews (if any) 
```
MATCH {class: Customers, as: c, where: (OrderedId=2)}--{class: Locations, as: loc}-HasReview-{class: Reviews, as: r, optional: true} 
RETURN $pathelements
```
#### Find the other Customers that visited the Locations visited by Customer with Id 1
```
MATCH {class: Customers, as: c, where: (OrderedId=1)}--{class: Locations, as: loc}--{class: Customers, as: otherCustomers, where: (OrderedId<>1)} 
RETURN otherCustomers.OrderedId, loc.Name, loc.Type
```
#### Same as before, but now returns also their Profile names, surnames and emails 
```
MATCH {class: Customers, as: c, where: (OrderedId=1)}--{class: Locations, as: loc}--{class: Customers, as: otherCustomers, where: (OrderedId<>1)}-HasProfile->{class: Profiles, as: profile} 
RETURN otherCustomers.OrderedId, loc.Name, loc.Type, profile.Name, profile.Surname, profile.Email
```
#### Find all the places where Customer with Id 1 has stayed
```
MATCH {as: n}<-HasStayed-{class: Customers, as: c, where: (OrderedId=1)} 
RETURN $pathelements
```
#### Find all places where Customer with Id 1 has eaten
```
MATCH {as: n}-HasEaten-{class: Customers, as: c, where: (OrderedId=1)} 
RETURN $pathelements
```
#### Find the top 3 nationality of the tourists that eaten at Restaurant with Id 13
```
SELECT Name, count(*) as CountryCount FROM (SELECT expand(out('IsFromCountry')) AS countries FROM ( SELECT expand(in("HasEaten")) AS customers FROM Restaurants WHERE Id='13' UNWIND customers) unwind countries) GROUP BY Name ORDER BY CountryCount DESC LIMIT 3
```

### RECCOMENDATIONS

#### Reccomends some friends to Profile with Id 1 (friends of friends)
```
MATCH {class: Profiles, as: profile, where: (Id=1)}.both('HasFriend').both('HasFriend'){as: friendOfFriend, where: ($matched.profile != $currentMatch)} 
RETURN profile, friendOfFriend 
```

#### Reccomends some Hotels to Customer with OrderedId 1	
```
MATCH 
  {Class: Customers, as: customer, where: (OrderedId=1)}-HasProfile->{class: Profiles, as: profile},
  {as: profile}-HasFriend->{class: Profiles, as: friend},
  {as: friend}<-HasProfile-{Class: Customers, as: customerFriend},
  {as: customerFriend}-HasStayed->{Class: Hotels, as: hotel},
  {as: customerFriend}-MadeReview->{Class: Reviews, as: review},
  {as: hotel}-HasReview->{as: review}
RETURN $pathelements
```

To filter additionally, and suggestion only the 4 and 5 rated hotels, we can add a filter condition on the HasReview edge (property Stars):

```
MATCH
  {Class: Customers, as: customer, where: (OrderedId=1)}-HasProfile->{class: Profiles, as: profile},
  {as: profile}-HasFriend->{class: Profiles, as: friend},
  {as: friend}<-HasProfile-{Class: Customers, as: customerFriend},
  {as: customerFriend}-HasStayed->{Class: Hotels, as: hotel},
  {as: customerFriend}-MadeReview->{Class: Reviews, as: review},
  {as: hotel}.outE('HasReview'){as: ReviewStars, where: (Stars>3)}.inV(){as: review}
RETURN hotel, ReviewStars.Stars  
```
