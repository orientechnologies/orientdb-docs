Find the 3 Customers who made more reviews:

```sql
SELECT 
  OrderedId as CustomerId,
  out("MadeReview").size() AS ReviewNumbers 
FROM `Customers` 
ORDER BY ReviewNumbers DESC 
LIMIT 3
```
 