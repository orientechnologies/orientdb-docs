Find the 3 Customers who placed most Orders:

```sql
SELECT 
  OrderedId as CustomerId,
  in("HasCustomer").size() AS NumberOfOrders 
FROM Customers 
ORDER BY NumberOfOrders 
DESC LIMIT 3
```

 