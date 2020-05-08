
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

Since OrientDB v 3.1 we are reviving the pessimistic locking, introducing a new API.

Now you can do:

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
session.commit(); // The commit unlocks the lock acquired during the transaction. 
```

### Distributed Architecture

With OrientDB v 3.1 we are shipping some structural changes to the distributed module. 
In particular, the new distributed coordination algorithms remove the limitations related to cluster ownership.

The complete redesign of the distributed transaction model removes some legacy components and makes the behavior more predictable. This results in easier maintainability and improved stability.

The replication model is now based on record delta changes, this optimizes the intra-node networking and improves the overall distributed transaction performance. 

Also tree ridbags are now supported in a distributed configuration, removing the previous limitations that forced using embedded ridbags (not efficient, in particular in case of supernodes).

For database synchronization (cold start and HA scenarios), a new and more reliable Delta Sync protocol is now available.


### Enhancements to SEQUENCE component

With OrientDB v 3.1  we enhanced sequences with the following features:

 * Sequence Upper and Lower Limits
 * Cyclic Sequences (when a limit is reached, the sequence will restart from the original start value)
 * Ascending and Descending Sequences

```java
OSequence.CreateParams params = new OSequence.CreateParams().setStart(0L).
        setIncrement(10).
        setRecyclable(true).
        setLimitValue(30l).
        setOrderType(SequenceOrderType.ORDER_POSITIVE);
OSequenceLibrary sequences = db.getMetadata().getSequenceLibrary();
sequences.createSequence("mySeq", OSequence.SEQUENCE_TYPE.ORDERED, params);
```


### Enterprise Profiler

SAP Enterprise OrientDB 3.1 ships with a brand new monitoring module that replaces the old profiler.  (The old profiler is still available in 3.1 for backwards compatibility.)  The new profiler provides a detailed view about statistics and the status of the OrientDB Server/Cluster while adding minimal overhead.

It can be configured via REST APIs or via Studio and provides insights like:

- CRUD Operations
- Network Traffic 
- Query Statistics (realtime and aggregated)
- Server status (CPU, Memory, Disk Cache)
- JVM status (GC, Threads)

..and more.


It also provides out of the box reporting outputs like REST APIS, JMX, CSV files, and a prometheus compatible HTTP endpoint.

### Storage Improvements

- Indexes - The speed of queries was improved with the limit keyword.
- WAL - all segments of WAL have an equal size which fixes the issue with disk overflow in case of long-running transactions. - New option storage.wal.keepSingleSegment (false by default) is introduced to drastically decrease restoration time after the crash.
- The shadow copy strategy was implemented in the on-disk cache level to improve storage durability.
- The write disk cache uses asynchronous I/O during file writes to improve write throughput by leveraging parallelization potential of SSDs and decreases latency during write throughput.
- A new record serializer is introduced that reduces the size of records stored on the physical device and consequently increases the query processing speed.


### Transparent Data Encryption

AES encryption was introduced on the filesystem level for data files, WAL, and incremental backups.

### Predicate-based Security

A new security model based on Security Policies and SQL predicates was introduced in this version.

SQL predicates are used as per-record conditions to define if a single user/role can create/read/update/delete some specific information.

Security policies can be applied at the record level or at the property level. I.e., it's possible to create horizontal partitions (a single user can or cannot see a subset of the records in a class) or vertical partitions (a single user can or cannot see a subset of the properties of certain records).

Complete Predicate Security documentation can be found [here](../../security/Database-Security.md)

See also [Create Security Policy](../../sql/SQL-Create-Security-Policy.md), [Alter Security Policy](../../sql/SQL-Alter-Security-Policy.md)
