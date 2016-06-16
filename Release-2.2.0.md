# Release 2.2.x

## What's new?


### Spatial Module

OrientDB v2.2 offers a brand new module to handle geospatial information provided as external plugin. Look at [Spatial Module](Spatial-Module.md).

### Pattern Matching

Starting from v2.2, OrientDB provides an alternative way to query the database by using the Pattern Matching approach. For more information look at [SQL Match](SQL-Match.md).

### Non-Stop Incremental Backup and Restore

OrientDB Enterprise Edition allows [Non-Stop Incremental Backup and Restore](Incremental-Backup-And-Restore.md).

### Distributed

Release v2.2 contains many improvement on distributed part. First of all there is a huge improvement on performance. With 2 nodes we measured 5x better and with 3 nodes is about 10x faster than 2.1!

#### Management of the Quorum 

Before 2.2, the `writeQuorum` was scaled down to `1` because the setting `failureAvailableNodesLessQuorum` (that now is no longer supported). 

This wasn't correct, because if a node is unreachable, it could be because network temporary error, split brain, etc. So downgrading the `writeQuorum` means no guarantee for consistency when 2 nodes see each other again, because both nodes thought to be the only one and they continue working with quorum=1 with evident merge conflict risks.

In v2.2.0-rc1 the nodes is never removed automatically from the configuration for this reason, unless you manually remove a node from the configuration claiming that node is not part of the cluster anymore. The new SQL command to remove a server from the configuration is:

[`HA REMOVE SERVER <server-name>`](SQL-HA-Remove-Server.md)


#### Other changes

- Multi-Threads message management
- [Static Ownership of clusters](Distributed-Architecture.md#static-owner)
- ['majority' and 'all' quorum](Distributed-Configuration.md#default-distributed-db-configjson) to assure you have the majority (N/2+1) or the total of the consensus
- Removed `failureAvailableNodesLessQuorum` setting: with majority you don't need this setting anymore
- Removed `hotAlignment` setting: servers, once they join the cluster, remain always in the configuration until they are manually removed
- [Server Roles](Distributed-Architecture.md#server-roles), where you can specify a node is a read only "REPLICA"
- [Load balancing on the client side](Distributed-Configuration.md#load-balancing)
- OrientDB doesn't use Hazelcast Queues to exchange messages between nodes, but rather the OrientDB binary protocol
- New SQL commands to manage the distributed configuration:
 - `HA REMOVE SERVER <server-name>`, to remove a server from the configuration
 - `HA SYNC DATABASE`, to ask for a resync of the database
 - `HA SYNC CLUSTER <cluster-name>`, to ask for a resync of a single cluster

### Command Cache
OrientDB 2.2 has a new component called [Command Cache](Command-Cache.md), disabled by default, but that can make a huge difference in performance on some use cases. Look at [Command Cache](Command-Cache.md) to know more.

### Sequences
In v2.2 we introduced [Sequences](Sequences-and-auto-increment.md). Thanks to the sequences it's easy to maintain counters and incremental ids in your application. You can use [Sequences](Sequences-and-auto-increment.md) from both Java API and SQL.

### Parallel queries
OrientDB v2.2 can run query in parallel, using multiple threads. To use parallel queries, append the `PARALLEL` keyword at the end of SQL SELECT. Example: `SELECT FROM V WHERE amount < 100 PARALLEL`.

Starting from v2.2, the OrientDB SQL executor can decide if execute or not a query in parallel, only if `query.parallelAuto` setting is enabled. To tune parallel query execution these are the new settings:
- `query.parallelAuto` enable automatic parallel query, if requirements are met. By default is false.
- `query.parallelMinimumRecords` is the minimum number of records to activate parallel query automatically. Default is 300,000.
- `query.parallelResultQueueSize` is the size of the queue that holds results on parallel execution. The queue is blocking, so in case the queue is full, the query threads will be in a wait state. Default is 20,000 results.

### Automatic usage of Multiple clusters
Starting from v2.2, when a class is created, the number of underlying clusters will be the number of cores. [Issue 4518](https://github.com/orientechnologies/orientdb/issues/4518).

### Encryption at rest
OrientDB v2.2 can encrypt database at [file system level](Database-Encryption.md) by using DES and AES encryption.

### New ODocument.eval()
To execute quick expression starting from a ODocument and Vertex/Edge objects, use the new `.eval()` method. The old syntax `ODocument.field("city[0].country.name")` has been deprecated, but still supported. [Issue 4505](https://github.com/orientechnologies/orientdb/issues/4505).

### Security
OrientDB v2.2 comes with a plethora of [new security features](Security-OrientDB-New-Security-Features.md), including a new centralized security module, external authenticators (including Kerberos), LDAP import of users, password validation, enhanced auditing features, support for syslog events, using a salt with password hashes, and a new *system user*.

#### security.json
The new security module uses a [JSON configuration file](Security-Config.md), located at `config\security.json`.

#### External Authenticators
OrientDB v2.2 supports external authentication, meaning that authentication of database and server users can occur outside the database and server configuration.  Kerberos/SPNEGO authentication is now fully supported.

#### LDAP Import
As part of the new security module, LDAP users can be imported automatically into OrientDB databases (including the new system database) using LDAP filters.

#### Password Validator
Password validation is now fully supported, including the ability to specify minimum length and the number of uppercase, special, and numeric characters.

#### Auditing
Auditing is no longer an Enterprise-only feature and supports many new auditing events, including the creation and dropping of classes, reloading of configuration files, and distributed node events.  Additionally, if the new [syslog plugin](SysLog-Plugin.md) is installed, auditing events will also be recorded to syslog.

#### Salt
OrientDB v2.2 increases security by using [SALT](https://github.com/orientechnologies/orientdb/issues/1229). This means that hashing of password is much slower than OrientDB v2.1. You can configure the number of cycles for the SALT: more is harder to decode but is slower. Change the setting `security.userPasswordSaltIterations` to the number of cycles. Default is 65k cycles.
The default password hashing algorithm is now `PBKDF2WithHmacSHA256` this is not present in any environment so you can change it setting `security.userPasswordDefaultAlgorithm` possible alternatives values are `PBKDF2WithHmacSHA1` or `SHA-256`

If you are using Java < 8,  since `PBKDF2WithHmacSHA256` is not supported you should change it  into `PBKDF2WithHmacSHA1` 

#### System User
As part of the new ["system database"](System-Database.md) implementation, OrientDB v2.2 offers a new kind of user, called the [System User](System-Users.md).  A *system user* is like a hybrid between a server user and a database user, meaning that a system user can have permissions and roles assigned like a database user but it can be applied to the entire system not just a single database.

### System Database
OrientDB now uses a ["system database"](System-Database.md) to provide additional capabilities.

The system database, currently named *OSystem*, is created when the OrientDB server starts, if the database does not exist.

Here's a list of some of the features that the system database may support:
- A new class of user called the *system user*
- A centralized location for configuration files
- Logging of global auditing events
- Recording performance metrics about the server and its databases

### Direct Memory
Starting from v2.2, OrientDB uses direct memory. The new server.sh (and .bat) already set the maximum size value to 512GB of memory by setting the JVM configuration
```
-XX:MaxDirectMemorySize=512g
```

If you run OrientDB embedded or with a different script, please set `MaxDirectMemorySize` to a high value, like `512g`.

### NULL Values in Indexes
Starting from v2.2, by default any new index created will not ignore NULL values; null values will be indexed as any other values. This means that if you have a UNIQUE index, you cannot have multiple NULL keys. This applies only to the new indexes, opening an old database with indexes previously created, will all ignore NULL by default.

To create an index that explicitly ignore nulls (like the default with v2.1 and earlier), look at the following examples by usinng SQL or Java API.

SQL:
```sql
CREATE INDEX addresses ON Employee (address) NOTUNIQUE METADATA {ignoreNullValues: true}
```

And Java API:
```java
schema.getClass(Employee.class).getProperty("address").createIndex(OClass.INDEX_TYPE.NOTUNIQUE, new ODocument().field("ignoreNullValues",true));
```

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


## Migration from 2.1.x to 2.2.x
Databases created with release 2.1.x are compatible with 2.2.x, so you don't have to export/import the database.

