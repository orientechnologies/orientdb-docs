Find the 3 Customers who placed most Orders:

```sql
SELECT *, in("HasCustomer").size() AS NumberOfOrders 
FROM Customers 
ORDER BY NumberOfOrders 
DESC LIMIT 3
```

 