
### Customers 
	
#### Example 1

Find everything that is connected (1st degree) to Customer with Id 1:

```sql
MATCH {class: Customers, as: c, where: (OrderedId=1)}--{as: n} RETURN $pathelements
```


#### Example 2

{{book.demodb_query_25_text}}:

```sql
MATCH {class: Customers, as: customer, where: (OrderedId=1)}--{Class: Locations} 
RETURN $pathelements
```	


#### Example 3

{{book.demodb_query_26_text}}:

```sql
MATCH {class: Customers, as: c, where: (OrderedId=1)}--{class: Locations, as: loc}-HasReview-{class: Reviews, as: r, optional: true} 
RETURN $pathelements
```


#### Example 4

Find the other Customers that visited the Locations visited by Customer with Id 1:

```sql
MATCH {class: Customers, as: c, where: (OrderedId=1)}--{class: Locations, as: loc}--{class: Customers, as: otherCustomers, where: (OrderedId<>1)} 
RETURN otherCustomers.OrderedId, loc.Name, loc.Type
```

if we want to return also also their Profile names, surnames and emails:

```sql
MATCH {class: Customers, as: c, where: (OrderedId=1)}--{class: Locations, as: loc}--{class: Customers, as: otherCustomers, where: (OrderedId<>1)}-HasProfile->{class: Profiles, as: profile} 
RETURN otherCustomers.OrderedId, loc.Name, loc.Type, profile.Name, profile.Surname, profile.Email
```


#### Example 5

Find all the places where Customer with Id 1 has stayed:

```sql
MATCH {as: n}<-HasStayed-{class: Customers, as: c, where: (OrderedId=1)} 
RETURN $pathelements
```


#### Example 6

Find all places where Customer with Id 1 has eaten:

```sql
MATCH {as: n}-HasEaten-{class: Customers, as: c, where: (OrderedId=1)} 
RETURN $pathelements
```

#### Example 7

{{book.demodb_query_30_text}}:

```sql
SELECT *, out("MadeReview").size() AS ReviewNumbers FROM `Customers` ORDER BY ReviewNumbers DESC LIMIT 3
```


#### Example 8

Find all Orders placed by Customer with Id 1:

```sql
MATCH {class: Customers, as: c, where: (OrderedId=1)}<-HasCustomer-{class: Orders, as: o} 
RETURN $pathelements
```

### Example 9

Calculate the total revenues from Orders associated with Customer with Id 1:



#### Example 10

Find the 3 Customers who placed most Orders:

```sql
SELECT *, in("HasCustomer").size() AS NumberOfOrders FROM Customers ORDER BY NumberOfOrders DESC LIMIT 3
```

