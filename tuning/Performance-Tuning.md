---
search:
   keywords: ['performance', 'performance tuning']
---

# Performance Tuning

This guide contains the general tips to optimize your application that use the OrientDB. Below you can find links for the specific guides different per database type used. Look at the specific guides based on the database type you're using:

- [Document Database performance tuning](Performance-Tuning-Document.md)
- [Object Database performance tuning](Performance-Tuning-Object.md)
- [Distributed Configuration tuning](../distributed/Distributed-Configuration-Tuning.md)

## I/O benchmark
The main requirement for a fast DBMS is having good I/O. In order to understand the performance of your hw/sw configuration. If you have a Unix derived OS (like Linux, MacOSX, etc.), the simplest way to have your raw I/O performance is running this two commands:

```
dd if=/dev/zero of=/tmp/output.img bs=8k count=256k
rm /tmp/output.img
```

This is the output on a fast SSD (1.4 GB/sec):
```
262144+0 records in
262144+0 records out
2147483648 bytes transferred in 1.467536 secs (1463326070 bytes/sec)
```

And this is what you usually get with a HD connected with a USB 3.0 (90 MB/sec):

```
262144+0 records in
262144+0 records out
2147483648 bytes transferred in 23.699740 secs (90612119 bytes/sec)
```

As you can notice the first configuration (SSD) is 16x faster than the second configuration (HD). Sensible differences can be found between bare metal hw and Virtual Machines.

## Java
OrientDB is written in Java, so it runs on top of Java Virtual Machine (JVM). OrientDB is compatible with Java 8 and we suggest to use this version to run OrientDB. Java 8 is faster than Java 7 and previous ones.

## JMX
Starting from v2.1, OrientDB exposes internal metrics through [JMX Beans](../admin/JMX.md). Use this information to track and profile OrientDB.

## Memory settings
### Server and Embedded settings
These settings are valid for both Server component and the JVM where is running the Java application that use OrientDB in Embedded Mode, by using directly [plocal](../internals/plocal-storage-engine.md).

The most important thing on tuning is assuring the memory settings are correct. What can make the real difference is the right balancing between the heap and the virtual memory used by Memory Mapping, specially on large datasets (GBs, TBs and more) where the in memory cache structures count less than raw IO.

For example if you can assign maximum 8GB to the Java process, it's usually better assigning small heap and large disk cache buffer (off-heap memory). So rather than:

```
java -Xmx8g ...
```

You could instead try this:
```
java -Xmx800m -Dstorage.diskCache.bufferSize=7200 ...
```

The **storage.diskCache.bufferSize** setting (with old "local" storage it was **file.mmap.maxMemory**) is in MB and tells how much memory to use for [Disk Cache](../internals/plocal-storage-disk-cache.md) component. By default is 4GB.

_NOTE: If the sum of maximum heap and disk cache buffer is too high, could cause the OS to swap with huge slow down._

## JVM settings
JVM settings are encoded in server.sh (and server.bat) batch files. You can change them to tune the JVM according to your usage and hw/sw settings. We found these setting work well on most configurations:
```java
-server -XX:+PerfDisableSharedMem
```

This setting will disable writing debug information about the JVM. In case you need to profile the JVM, just remove this setting. For more information look at this post: http://www.evanjones.ca/jvm-mmap-pause.html.

### High concurrent updates

OrientDB has an optimistic concurrency control system, but on very high concurrent updates on the few records it could be more efficient locking records to avoid retries. You could synchronize the access by yourself or by using the storage API. Note that this works only with non-remote databases.

```
((OStorageEmbedded)db.getStorage()).acquireWriteLock(final ORID iRid)
((OStorageEmbedded)db.getStorage()).acquireSharedLock(final ORID iRid)
((OStorageEmbedded)db.getStorage()).releaseWriteLock(final ORID iRid)
((OStorageEmbedded)db.getStorage()).releaseSharedLock(final ORID iRid)
```

Example of usage. Writer threads:
```
try{
  ((OStorageEmbedded)db.getStorage()).acquireWriteLock(record.getIdentity());

  // DO SOMETHING
} finally {
  ((OStorageEmbedded)db.getStorage()).releaseWriteLock(record.getIdentity());
}
```

Reader threads:

```
try{
  ((OStorageEmbedded)db.getStorage()).acquireSharedLock(record.getIdentity());
  // DO SOMETHING

} finally {
  ((OStorageEmbedded)db.getStorage()).releaseSharedLock(record.getIdentity());
}
```

## Remote connections

There are many ways to improve performance when you access to the database using the remote connection.

### Fetching strategy

When you work with a remote database you've to pay attention to the [fetching strategy](../java/Fetching-Strategies.md) used. By default OrientDB Client loads only the record contained in the result set. For example if a query returns 100 elements, but then you cross these elements from the client, then OrientDB client lazily loads the elements with one more network call to the server foreach missed record.

By specifying a fetch plan when you execute a command you're telling to OrientDB to prefetch the elements you know the client application will access. By specifying a complete fetch plan you could receive the entire result in _just one network call_.

For more information look at: [Fetching-Strategies](../java/Fetching-Strategies.md).

### Network Connection Pool

Each client, by default, uses only one network connection to talk with the server. Multiple threads on the same client share the same network connection pool.

When you've multiple threads could be a bottleneck since a lot of time is spent on waiting for a free network connection. This is the reason why is much important to configure the network connection pool.

The configurations is very simple, just 2 parameters:

- **minPool**, is the initial size of the connection pool. The default value is configured as global parameters "client.channel.minPool" (see [parameters](../admin/Configuration.md#parameters))
- **maxPool**, is the maximum size the connection pool can reach. The default value is configured as global parameters "client.channel.maxPool" (see [parameters](../admin/Configuration.md#parameters))

At first connection the **minPool** is used to pre-create network connections against the server. When a client thread is asking for a connection and all the pool is busy, then it tries to create a new connection until **maxPool** is reached.

If all the pool connections are busy, then the client thread will wait for the first free connection.

Example of configuration by using database properties:
```java
database = new ODatabaseDocumentTx("remote:localhost/demo");
database.setProperty("minPool", 2);
database.setProperty("maxPool", 5);

database.open("admin", "admin");
```

### Enlarge timeouts

If you see a lot of messages like:
```
WARNING: Connection re-acquired transparently after XXXms and Y retries: no errors will be thrown at application level
```
means that probably default timeouts are too low and server side operation need more time to complete. It's strongly suggested you enlarge your timeout only after tried to enlarge the [Network Connection Pool](#network-connection-pool). The timeout parameters to tune are:
- <code>network.lockTimeout</code>, the timeout in ms to acquire a lock against a channel. The default is 15 seconds.
- <code>network.socketTimeout</code>, the TCP/IP Socket timeout in ms. The default is 10 seconds.

## Query

### Use of indexes

The first improvement to speed up queries is to create [Indexes](../indexing/Indexes.md) against the fields used in WHERE conditions. For example this query:
```sql
SELECT FROM Profile WHERE name = 'Jay'
```
Browses the entire "profile" cluster looking for records that satisfy the conditions. The solution is to create an index against the 'name' property with:
```sql
CREATE INDEX profile.name UNIQUE
```

Use NOTUNIQUE instead of UNIQUE if the value is not unique.

For more complex queries like
```sql
SELECT * FROM testClass WHERE prop1 = ? AND prop2 = ?
```
Composite index should be used
```sql
CREATE INDEX compositeIndex ON testClass (prop1, prop2) UNIQUE
```
or via Java API:
```java
oClass.createIndex("compositeIndex", OClass.INDEX_TYPE.UNIQUE, "prop1", "prop2");
```
Moreover, because of partial match searching, this index will be used for optimizing query like
```sql
SELECT * FROM testClass WHERE prop1 = ?
```

For deep understanding of query optimization look at [the unit test](https://github.com/orientechnologies/orientdb/blob/master/tests/src/test/java/com/orientechnologies/orient/test/database/auto/SQLSelectIndexReuseTest.java).


### Use parameters instead of hard-wired values

Query parsing is not an extremely expensive operation, but zero cost is better than low cost, right?

When you execute an SQL query, OrientDB parses the query text and produces an [AST](https://en.wikipedia.org/wiki/Abstract_syntax_tree). This structure is cached at storage level, so if you execute the query again, OrientDB will avoid to parse it again and will just pick the AST from the cache.

In most cases, your application will execute a very limited number of queries, but with different condition values, eg.

```sql
SELECT FROM Person WHERE name = 'Joe';
SELECT FROM Person WHERE name = 'Jenny';
SELECT FROM Person WHERE name = 'Frank';
SELECT FROM Person WHERE name = 'Anne';
```

With these queries, OrientDB has to perform parsing operations each time.

Re-writing the query as follows:

```sql
SELECT FROM Person WHERE name = ?;
```

or 

```sql
SELECT FROM Person WHERE name = :theName;
```

and passing the name as a parameter (see the docs for your language driver, eg [the Java Multi-Model API](../java/Java-Query-API.md)) allows OrientDB to parse the query only once and then cache it. The second time you execute the same query, even with different parameters, there will be no parsing at all.


### Parallel queries

Starting from v2.2, the OrientDB SQL executor will decide if execute or not a query in parallel. To tune parallel query execution these are the new settings:
- `query.parallelAuto` enable automatic parallel query, if requirements are met. By default is true if your system has more than 2 CPUs/Cores.
- `query.parallelMinimumRecords` is the minimum number of records to activate parallel query automatically. Default is 300,000.
- `query.parallelResultQueueSize` is the size of the queue that holds results on parallel execution. The queue is blocking, so in case the queue is full, the query threads will be in a wait state. Default is 20,000 results.

## Massive Insertion

### Use the Massive Insert intent

Intents suggest to OrientDB what you're going to do. In this case you're telling to OrientDB that you're executing a massive insertion. OrientDB auto-reconfigure itself to obtain the best performance. When done you can remove the intent just setting it to null.

Example:
```java
db.declareIntent( new OIntentMassiveInsert() );

// YOUR MASSIVE INSERTION

db.declareIntent( null );
```

### Disable Journal
In case of massive insertion, specially when this operation is made just once, you could disable the journal (WAL) to improve insertion speed:

    -Dstorage.useWAL=false

By default [WAL (Write Ahead Log)](../internals/Write-Ahead-Log.md) is enabled.

### Disable sync on flush of pages
This setting avoids to execute a sync at OS level when a page is flushed. Disabling this setting will improve throughput on writes:

    -Dstorage.wal.syncOnPageFlush=false

## Massive Updates

Updates generates "holes" at Storage level because rarely the new record fits perfectly the size of the previous one. Holes are free spaces between data. Holes are recycled but an excessive number of small holes it's the same as having a highly defragmented File System: space is wasted (because small holes can't be easily recycled) and performance degrades when the database growth.

### Oversize

If you know you will update certain type of records, create a class for them and set the Oversize (default is 0) to 2 or more.

By default the OGraphVertex class has an oversize value setted at 2. If you define your own classes set this value at least at 2.

OClass myClass = getMetadata().getSchema().createClass("Car");
myClass.setOverSize(2);

## Wise use of transactions

To obtain real linear performance with OrientDB you should avoid to use [Transactions](../internals/Transactions.md) as far as you can. In facts OrientDB keeps in memory all the changes until you flush it with a commit. So the bottleneck is your Heap space and the management of local transaction cache (implemented as a Map).

[Transactions](../internals/Transactions.md) slow down massive inserts unless you're using a "remote" connection. In that case it speeds up all the insertion because the client/server communication happens only at commit time.

### Disable Transaction Log

If you need to group operations to speed up remote execution in a logical transaction but renouncing to the Transaction Log, just disable it by setting the property **tx.useLog** to false.

Via JVM configuration:
```
java ... -Dtx.useLog=false ...
```
or via API:
```java
OGlobalConfiguration.TX_USE_LOG.setValue(false);
```

*NOTE: Please note that in case of crash of the JVM the pending transaction OrientDB could not be able to rollback it.*

### Use the schema
Starting from OrientDB 2.0, if fields are declared in the schema, field names are not stored in document/vertex/edge themselves. This improves performance and saves a lot of space on disk.

## Configuration
To tune OrientDB look at the [Configuration](../admin/Configuration.md) settings.

## Platforms
- [Performance analysis on ZFS](http://carloprad.blogspot.it/2014/03/orientdb-on-zfs-performance-analysis.html)

