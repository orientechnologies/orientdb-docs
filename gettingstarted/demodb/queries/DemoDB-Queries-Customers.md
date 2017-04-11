
# Customers 
	
## Example 1

Find everything that is connected (1st degree) to Customer with Id 1:

```sql
MATCH {class: Customers, as: c, where: (OrderedId=1)}--{as: n} 
RETURN $pathelements
```


## Example 2

Find all Locations connected to Customer with Id 1:

```sql
MATCH {class: Customers, as: customer, where: (OrderedId=1)}--{Class: Locations} 
RETURN $pathelements
```


## Example 3

Find all Locations connected to Customer with Id 1, and their Reviews (if any)
 
```sql
MATCH {class: Customers, as: c, where: (OrderedId=1)}--{class: Locations, as: loc}-HasReview-{class: Reviews, as: r, optional: true} 
RETURN $pathelements
```


## Example 4

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


## Example 5

Find all the places where Customer with Id 1 has stayed:

```sql
MATCH {as: n}<-HasStayed-{class: Customers, as: c, where: (OrderedId=1)} 
RETURN $pathelements
```


## Example 6

Find all places where Customer with Id 1 has eaten:

```sql
MATCH {as: n}-HasEaten-{class: Customers, as: c, where: (OrderedId=1)} 
RETURN $pathelements
```

## Example 7

{% include "./include-file-3.md" %}


## Example 8

Find all Orders placed by Customer with Id 1:

```sql
MATCH {class: Customers, as: c, where: (OrderedId=1)}<-HasCustomer-{class: Orders, as: o} 
RETURN $pathelements
```

## Example 9

Calculate the total revenues from Orders associated with Customer with Id 1:


## Example 10

{% include "./include-file-4.md" %}


## Example 11

{% include "./include-file-6.md" %}