
# Customers 
	
## Example 1

Find everything that is connected (1st degree) to Customer with OrderedId 1:

```sql
MATCH {class: Customers, as: c, where: (OrderedId=1)}--{as: n} 
RETURN $pathelements
```

In the _Graph Editor_ included in [Studio](../../../studio/README.md), using _'RETURN $pathelements'_ as `RETURN` clause, this is the obtained graph:

![](../../../images/demo-dbs/social-travel-agency/query_37_graph.png)


## Example 2

{% include "./include-file-7.md" %}


## Example 3

{% include "./include-file-8.md" %}


## Example 4

Find the other Customers that visited the Locations visited by Customer with OrderedId 1:

```sql
MATCH {class: Customers, as: customer, where: (OrderedId=1)}--{class: Locations, as: loc}--{class: Customers, as: otherCustomers, where: (OrderedId<>1)} 
RETURN $pathelements
```

In the _Graph Editor_ included in [Studio](../../../studio/README.md), using _'RETURN $pathelements'_ as `RETURN` clause, this is the obtained graph:

![](../../../images/demo-dbs/social-travel-agency/query_40_graph.png)

If we want to return also also their Profile names, surnames and emails:

```sql
MATCH {class: Customers, as: customer, where: (OrderedId=1)}--{class: Locations, as: loc}--{class: Customers, as: otherCustomers, where: (OrderedId<>1)}-HasProfile->{class: Profiles, as: profile} 
RETURN otherCustomers.OrderedId, profile.Name, profile.Surname, profile.Email
ORDER BY `otherCustomers.OrderedId` ASC
```

In the _Browse Tab_ of [Studio](../../../studio/README.md), using _'RETURN otherCustomers.OrderedId, profile.Name, profile.Surname, profile.Email'_ as `RETURN` clause, this is the obtained list of records (only few records are shown in the image below):

![](../../../images/demo-dbs/social-travel-agency/query_40_browse.png)


## Example 5

Find all the places where Customer with OrderedId 2 has stayed:

```sql
MATCH {as: n}<-HasStayed-{class: Customers, as: c, where: (OrderedId=2)} 
RETURN $pathelements
```

In the _Graph Editor_ included in [Studio](../../../studio/README.md), using _'RETURN $pathelements'_ as `RETURN` clause, this is the obtained graph:

![](../../../images/demo-dbs/social-travel-agency/query_41_graph.png)


## Example 6

Find all places where Customer with OrderedId 1 has eaten:

```sql
MATCH {as: n}<-HasEaten-{class: Customers, as: c, where: (OrderedId=1)} 
RETURN $pathelements
```

In the _Graph Editor_ included in [Studio](../../../studio/README.md), using _'RETURN $pathelements'_ as `RETURN` clause, this is the obtained graph:

![](../../../images/demo-dbs/social-travel-agency/query_42_graph.png)


## Example 7

{% include "./include-file-3.md" %}


## Example 8

{% include "./include-file-9.md" %}


## Example 9

{% include "./include-file-10.md" %}


## Example 10

{% include "./include-file-4.md" %}


## Example 11

{% include "./include-file-6.md" %}