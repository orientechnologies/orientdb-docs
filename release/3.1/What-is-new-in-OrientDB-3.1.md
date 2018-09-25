
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

```java
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

### Distributed Architecture

With OrientDB v 3.1 we are shipping some structural changes to the distributed module. 
In particular, the new distributed coordination algorithms remove the limitations related to cluster ownership.

The complete redesign of the distributed transaction model removes some legacy components and makes the behavior more predictable. This results in easier maintainability and improved stability.

The new distributed components are still under development and they are disabled by default in v 3.1.0-M1. You can enable them setting `OGlobalConfiguration.DISTRIBUTED_REPLICATION_PROTOCOL_VERSION` (`distributed.replicationProtocol.version`) value to `2`


### Enhancements to SEQUENCE component

TODO

### Enterprise Profiler

TODO
