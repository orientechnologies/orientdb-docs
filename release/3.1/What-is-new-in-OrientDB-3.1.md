
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

With OrientDB v 3.1  we enhanced sequences with following features:

 * Sequences' upper and lower limit
 * Cyclic sequences (when limit is reached, sequence will restart from original start value)
 * Ascending and descending sequences

```java
OSequence.CreateParams params = new OSequence.CreateParams().setStart(0L).
        setIncrement(10).
        setRecyclable(true).
        setLimitValue(30l).
        setOrderType(SequenceOrderType.ORDER_POSITIVE);
OSequenceLibrary sequences = db.getMetadata().getSequenceLibrary();
sequences.createSequence("mySeq", OSequence.SEQUENCE_TYPE.ORDERED, params);
```

### Improved serializer

With OrientDB v 3.1 new record serializer is introduced. New serializer reduces size of record stored on physical device, and hence it increases query processing speed.


### Enterprise Profiler

OrientDB v 3.1 Enterprise Edition ships a brand new monitoring module that replaces the old profiler, which however it's still working in 3.1 for backward compatibility. The new profiler allows a detailed view about statistics and status about OrientDB Server/Cluster, while adding minimum overhead.

It can be configured via REST APIs or via Studio  provide insights like:

- CRUD Operations
- Network Traffic 
- Query Statistics (realtime and aggregated)
- Server status (CPU, Memory, Disk Cache)
- JVM status (GC, Threads)

..and more.


It also provide out of the box different reporting output like REST APIS, JMX, CSV files and a prometheus compatible HTTP endpoint.

### Storage Improvements

- Indexes - Speed of queries with limit key works provided was improved.
- WAL - all segments of WAL have an equal size which fixes the issue with disk overflow in case of long-running transactions. - New option storage.wal.keepSingleSegment (false by default) is introduced to drastically decrease restore time after the crash.
- Shadow copy strategy was implemented on-disk cache level to improve storage durability.
- Write disk cache uses asynchronous IO during file writes to improve write throughput by leveraging parallelization potential of SSDs  and decrease latency during write throughputs.


### Transparent Data Encryption

AES encryption was introduced on file system level both for data files, WAL and incremental backups.
