
## What's new in OrientDB 3.1?

### Materialized Views

OrientDB v 3.1 includes Materialized Views as a new feature.

A materialized view is just the result of a query, stored in a persistent structure and available for querying.


Example usage

```SQL
CREATE VIEW Managers From (SELECT FROM Employees WHERE isManager = true);

SELECT FROM Managers WHERE name = 'John'
```

### Pessimistic locking

Since OrientDB v 3.1 we are reviving the perssimistic locking, introducing a new API.

now you can do:

```
// NoTx locking
ORID id = //...
ODatabaseSession session = //....
OElement record = session.lock(id);
record.save(record);
session.unlock(record);

// In Transaction Locking
ORID id = //...
ODatabaseSession session = //....
session.begin();
OElement record = session.lock(id);
record.save(record);
session.commit(); // The commit unlock all the lock acquired during the transaction. 
```


### Enterprise Profiler

TODO
