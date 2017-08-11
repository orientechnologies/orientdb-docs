Find the 3 Hotels that have most reviews:

```sql
SELECT 
  out("HasReview").size() AS ReviewNumbers 
FROM `Hotels` 
ORDER BY ReviewNumbers DESC 
LIMIT 3
```

In a similar way:

Find the 3 Restaurants that have most reviews:
 
```sql
SELECT 
  out("HasReview").size() AS ReviewNumbers 
FROM `Restaurants` 
ORDER BY ReviewNumbers DESC 
LIMIT 3
```

In a polymorphic way:

Find the 3 Services (Hotels + Restaurants) that have most reviews:

```sql
SELECT 
  out("HasReview").size() AS ReviewNumbers 
FROM `Services` 
ORDER BY ReviewNumbers DESC 
LIMIT 3
```