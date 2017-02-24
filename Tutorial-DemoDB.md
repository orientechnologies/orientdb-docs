### REVIEWS 

#### Find all reviewed Places
MATCH {class: Places, as: p}-HasReview->{class: Reviews, as: r} RETURN $pathelements

#### Find all reviewed Places and who made the review 
MATCH {class: Places, as: p}-HasReview->{class: Reviews, as: r}<-MadeReview-{class: Customers, as: c} RETURN $pathelements
	
#### Find the numbers of reviews per Place 
select *, out("HasReview").size() as ReviewNumbers from `Places`  
	
#### Find the 3 Places that have most reviews
select *, out("HasReview").size() as ReviewNumbers from `Places` ORDER BY ReviewNumbers DESC LIMIT 3
	
#### Find the 3 Hotels that have most reviews 
select *, out("HasReview").size() as ReviewNumbers from `Hotels` ORDER BY ReviewNumbers DESC LIMIT 3
	
#### Find the 3 Restaurants that have most reviews 
select *, out("HasReview").size() as ReviewNumbers from `Restaurants` ORDER BY ReviewNumbers DESC LIMIT 3

### HOTELS 
	
#### Find the 3 Hotels that have most reviews 
SELECT *, out("HasReview").size() AS ReviewNumbers FROM `Hotels` ORDER BY ReviewNumbers DESC LIMIT 3

#### Find the 3 Hotels that have been booked most times
SELECT *, in("HasStayed").size() AS NumberOfBookings FROM `Hotels` ORDER BY NumberOfBookings DESC 

### CUSTOMERS 
	
#### Find everything that is connected (1st degree) to Customer with Id 1 
MATCH {class: Customers, as: c, where: (OrderedId=1)}--{as: n} RETURN $pathelements

#### Find all Orders placed by Customer with Id 1  
MATCH {class: Customers, as: c, where: (OrderedId=1)}<-HasCustomer-{class: Orders, as: o} RETURN $pathelements

#### Find all Places connected to Customer with Id 1 
MATCH {class: Places, as: p}--{class: Customers, as: c, where: (OrderedId=1)} RETURN $pathelements
	
#### Find all Places connected to Customer with Id 3, and their Reviews (if any) 
MATCH {class: Customers, as: c, where: (OrderedId=1)}--{class: Places, as: p}-HasReview-{class: Reviews, as: r, optional: true} RETURN $pathelements
	
#### Find the other Customers that visited the Places visited by Customer with Id 3
MATCH {class: Customers, as: c, where: (OrderedId=1)}--{class: Places, as: p}--{class: Customers, as: otherCustomers, where: (OrderedId<>1)} RETURN p.Name, p.Type, otherCustomers.OrderedId 
	
#### Same as before, but now returns also their Profile names, surnames and emails 
MATCH {class: Customers, as: c, where: (OrderedId=1)}--{class: Places, as: place}--{class: Customers, as: otherCustomers, where: (OrderedId<>1)}-HasProfile->{class: Profiles, as: profile} RETURN place.Name, place.Type, otherCustomers.OrderedId, profile.Name, profile.Surname, profile.Email
