# Release 2.2.x

## What's new?

### Direct Memory
Starting from v2.2, OrientDB uses direct memory. The new server.sh (and .bat) already set the maximum size value to 512GB of memory by setting the JVM configuration
```
-XX:MaxDirectMemorySize=512g
```

If you run OrientDB embedded or with a different script, please set `MaxDirectMemorySize` to a high value, like `512g`.

### Distributed

Release v2.2 contains many improvement on distributed part. First of all there is a huge improvement on performance. With 2 nodes we measured 4x better and with 3 nodes is 8x faster than 2.1! Below the main new features on distributed part:

- Multi-Threads message management
- [Static Ownership of clusters](Distributed-Architecture.md#static-owner)
- ['majority' and 'all' quorum](Distributed-Configuration.md#default-distributed-db-configjson) to assure you have the majority (N/2+1) or the total of the consensus
- Removed `failureAvailableNodesLessQuorum` setting: with majority you don't need this setting anymore
- Removed `hotAlignment` setting: servers, once they join the cluster, remain always in the configuration until they are manually removed
- [Server Roles](Distributed-Architecture.md#server-roles), where you can specify a node is a read only "REPLICA"
- [Load balancing on the client side](Distributed-Configuration.md#load-balancing)
- OrientDB doesn't use Hazelcast Queues to exchange messages between nodes, but rather the OrientDB binary protocol.

### Command Cache
OrientDB 2.2 has a new component called [Command Cache](Command-Cache.md), disabled by default, but that can make a huge difference in performance on some use cases. Look at [Command Cache](Command-Cache.md) to know more.

### Sequences
In v2.2 we introduced [Sequences](Sequences-and-auto-increment.md). Thanks to the sequences it's easy to maintain counters and incremental ids in your application. You can use [Sequences](Sequences-and-auto-increment.md) from both Java API and SQL.

### Parallel queries
OrientDB v2.2 can run query in parallel, using multiple threads. To use parallel queries, append the `PARALLEL` keyword at the end of SQL SELECT.

Starting from v2.2, the OrientDB SQL executor can decide if execute or not a query in parallel, only if `query.parallelAuto` setting is enabled. To tune parallel query execution these are the new settings:
- `query.parallelAuto` enable automatic parallel query, if requirements are met. By default is false.
- `query.parallelMinimumRecords` is the minimum number of records to activate parallel query automatically. Default is 300,000.
- `query.parallelResultQueueSize` is the size of the queue that holds results on parallel execution. The queue is blocking, so in case the queue is full, the query threads will be in a wait state. Default is 20,000 results.

### Automatic usage of Multiple clusters
Starting from v2.2, when a class is created, the number of underlying clusters will be the number of cores. [Issue 4518](https://github.com/orientechnologies/orientdb/issues/4518).

### Encryption at rest
OrientDB v2.2 can encrypt database at file system level [89](https://github.com/orientechnologies/orientdb/issues/89).

### New ODocument.eval()
To execute quick expression starting from a ODocument and Vertex/Edge objects, use the new `.eval()` method. The old syntax `ODocument.field("city[0].country.name")` is not supported anymore. [Issue 4505](https://github.com/orientechnologies/orientdb/issues/4505).

## Migration from 2.1.x to 2.2.x

Databases created with release 2.1.x are compatible with 2.2.x, so you don't have to export/import the database.

### Security and speed

OrientDB v2.2 increase security by using [SALT](https://github.com/orientechnologies/orientdb/issues/1229). This means that hashing of password is much slower than OrientDB v2.1. You can configure the number of cycle for SALT: more is harder to decode but is slower. Change setting `security.userPasswordSaltIterations` to the number of cycles. Default is 65k cycles.
The default password hashing algorithm is now `PBKDF2WithHmacSHA256` this is not present in any environment so you can change it setting `security.userPasswordDefaultAlgorithm` possible alternatives values are `PBKDF2WithHmacSHA1` or `SHA-256`

To improve performance consider also avoiding opening and closing connection, but rather using a connection pool.

### API changes

#### ODocument.field()

To execute quick expression starting from a ODocument and Vertex/Edge objects, use the new `.eval()` method. The old syntax `ODocument.field("city[0].country.name")` is still supported. [Issue 4505](https://github.com/orientechnologies/orientdb/issues/4505).


#### Schema.dropClass()
On drop class are dropped all the cluster owned by the class, and not just the default cluster.


### Configuration Changes
Since 2.2 you can force to not ask for a root password setting `<isAfterFirstTime>true</isAfterFirstTime>` inside the `<orient-server>` element in the orientdb-server-config.xml file.


### SQL and Console commands Changes
Strict SQL parsing is now applied also to statements for **Schema Manipulation** (CREATE CLASS, ALTER CLASS, CREATE PROPERTY, ALTER PROPERTY etc.)

**ALTER DATABASE**: A statement like
```
ALTER DATABASE dateformat yyyy-MM-dd
```
is correctly executed, but is interpreted in the WRONG way: the `yyyy-MM-dd` is interpreted as an expression (two subtractions) and not as a single date format. Please re-write it as (see quotes)
```
ALTER DATABASE dateformat 'yyyy-MM-dd'
```

**CREATE FUNCTION**

In some cases a variant the syntax with curly braces was accepted (not documented), eg.

```
CREATE FUNCTION testCreateFunction {return 'hello '+name;} PARAMETERS [name] IDEMPOTENT true LANGUAGE Javascript
```

Now it's not supported anymore, the right syntax is
```
CREATE FUNCTION testCreateFunction "return 'hello '+name;" PARAMETERS [name] IDEMPOTENT true LANGUAGE Javascript
```

**ALTER PROPERTY**

The ALTER PROPERTY command, in previous versions, accepted any unformatted value as last argument, eg.

```
ALTER PROPERTY Foo.name min 2015-01-01 00:00:00
```

In v.2.2 the value must be a valid expression (eg. a string):
```
ALTER PROPERTY Foo.name min "2015-01-01 00:00:00"
```

**CREATE USER** and **DROP USER**

In v2.2 we introduced new [specific commands to work with users](https://github.com/orientechnologies/orientdb/pull/4000).
