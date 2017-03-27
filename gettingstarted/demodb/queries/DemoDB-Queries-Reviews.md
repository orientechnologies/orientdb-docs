

### Reviews 

#### Example 1

Find number of reviews per star
```sql
SELECT Stars, count(*) as count FROM HasReview GROUP BY Stars ORDER BY count DESC
```

#### Example 2

Find all reviewed Services
```sql
MATCH {class: Services, as: s}-HasReview->{class: Reviews, as: r} 
RETURN $pathelements
```

#### Example 3

Find all reviewed Services and the Customer who made the review 
```sql
MATCH {class: Services, as: s}-HasReview->{class: Reviews, as: r}<-MadeReview-{class: Customers, as: c} 
RETURN $pathelements 
```

#### Example 4

Find the numbers of reviews per Service 
```sql
SELECT *, out("HasReview").size() AS ReviewNumbers FROM `Services` ORDER BY ReviewNumbers DESC 
```

#### Example 5

**Example 5.1**

Find the 3 Places that have most reviews
```sql
SELECT *, out("HasReview").size() AS ReviewNumbers FROM `Services` ORDER BY ReviewNumbers DESC LIMIT 3
```

**Example 5.2**

Find the 3 Hotels that have most reviews 
```sql
SELECT *, out("HasReview").size() AS ReviewNumbers FROM `Hotels` ORDER BY ReviewNumbers DESC LIMIT 3
```

**Example 5.3**

Find the 3 Restaurants that have most reviews 
```sql
SELECT *, out("HasReview").size() AS ReviewNumbers FROM `Restaurants` ORDER BY ReviewNumbers DESC LIMIT 3
```

#### Example 6

Find the 3 Customers who made more reviews

```sql
SELECT *, out("MadeReview").size() AS ReviewNumbers FROM `Customers` ORDER BY ReviewNumbers DESC LIMIT 3
```

### SERVICES 

#### Example 1

**Example 1.1**

Find the 3 Hotels that have been booked most times
```sql
SELECT *, in("HasStayed").size() AS NumberOfBookings FROM Hotels ORDER BY NumberOfBookings DESC LIMIT 3
```

**Example 1.2**

Find the 3 Restaurants that have been used most times
```sql
SELECT *, in("HasEaten").size() AS VisitsNumber FROM Restaurants ORDER BY VisitsNumber DESC LIMIT 3
```

for the visualization in Studio:
{{Name}} ({{NumberOfBookings}})

#### Example 2

**Example 1.1**

Find the 3 Hotels that have most reviews 
```sql
SELECT *, out("HasReview").size() AS ReviewNumbers FROM `Hotels` ORDER BY ReviewNumbers DESC LIMIT 3
```

**Example 1.2**

Find the 3 Restaurants that have most reviews 
```sql
SELECT *, out("HasReview").size() AS ReviewNumbers FROM `Restaurants` ORDER BY ReviewNumbers DESC LIMIT 3
```

#### Example 3

**Example 1.1**

Find the top 3 nationality of the tourists that eaten at Restaurant with Id 13
```sql
SELECT Name, count(*) as CountryCount FROM (SELECT expand(out('IsFromCountry')) AS countries FROM ( SELECT expand(in("HasEaten")) AS customers FROM Restaurants WHERE Id='13' UNWIND customers) unwind countries) GROUP BY Name ORDER BY CountryCount DESC LIMIT 3
```

**Example 1.2**

Find the top 3 nationality of the tourists that staied at Hotel with Id 13
```sql
SELECT Name, count(*) as CountryCount FROM (SELECT expand(out('IsFromCountry')) AS countries FROM ( SELECT expand(in("HasStayed")) AS customers FROM Hotels WHERE Id='13' UNWIND customers) unwind countries) GROUP BY Name ORDER BY CountryCount DESC LIMIT 3
```