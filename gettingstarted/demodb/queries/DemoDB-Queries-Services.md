
# Services 

## Example 1

Find the 3 Hotels that have been booked most times:
```sql
SELECT *, in("HasStayed").size() AS NumberOfBookings FROM Hotels ORDER BY NumberOfBookings DESC LIMIT 3
```

in a similar way:

Find the 3 Restaurants that have been used most times
```sql
SELECT *, in("HasEaten").size() AS VisitsNumber FROM Restaurants ORDER BY VisitsNumber DESC LIMIT 3
```

for the visualization in Studio:
{{Name}} ({{NumberOfBookings}})


## Example 2

Find the 3 Hotels that have most reviews: 
```sql
SELECT *, out("HasReview").size() AS ReviewNumbers FROM `Hotels` ORDER BY ReviewNumbers DESC LIMIT 3
```

In a similar way:

Find the 3 Restaurants that have most reviews 
```sql
SELECT *, out("HasReview").size() AS ReviewNumbers FROM `Restaurants` ORDER BY ReviewNumbers DESC LIMIT 3
```

## Example 3

Find the top 3 nationality of the tourists that have eaten at Restaurant with Id 13:

```sql
SELECT 
  Name, 
  count(*) as CountryCount 
FROM (
  SELECT 
    expand(out('IsFromCountry')) AS countries 
  FROM (
    SELECT 
      expand(in("HasEaten")) AS customers 
    FROM Restaurants 
    WHERE Id='13' 
    UNWIND customers) 
  UNWIND countries) 
GROUP BY Name 
ORDER BY CountryCount DESC 
LIMIT 3
```

In a similar way:

Find the top 3 nationality of the tourists that stayed at Hotel with Id 13:

```sql
SELECT 
  Name, count(*) as CountryCount 
FROM (
  SELECT 
    expand(out('IsFromCountry')) AS countries 
  FROM (
    SELECT 
      expand(in("HasStayed")) AS customers 
    FROM Hotels 
    WHERE Id='13' 
    UNWIND customers) 
  UNWIND countries) 
GROUP BY Name 
ORDER BY CountryCount DESC 
LIMIT 3
```