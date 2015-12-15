<!-- proofread 2015-12-10 SAM -->
# Graph Consistency

Before OrientDB v2.1.7, the graph consistency could be assured only by using transactions. The problems with using transactions for simple operations like creation of edges are:

- **speed**, the transaction has a cost in comparison with non-transactional operations
- management of **optimistic retry** at application level. Furthermore, with 'remote' connections this means high latency
- **low scalability on high concurrency** (this will be resolved in OrientDB v3.0, where commits will not lock the database anymore)

As of v2.1.7, OrientDB provides a new mode to manage graphs without using transactions. It uses the Java class `OrientGraphNoTx` or via SQL by changing the global setting `sql.graphConsistencyMode` to one of the following values:
- `tx`, the default, uses transactions to maintain consistency. This was the only available setting before v2.1.7
- `notx_sync_repair`, avoids the use of transactions. Consistency, in case of a JVM crash, is guaranteed through a database repair operation, which runs at startup in synchronous mode. The database cannot be used until the repair is finished. 
- `notx_async_repair`, also avoids the use of transactions. Consistency, in case of JVM crash, is guaranteed through a database repair operation, which runs at startup in asynchronous mode. The database can be used immediately, as the repair procedure will run in the background.

Both the new modes `notx_sync_repair` and `notx_async_repair` will manage conflicts automatically,  with a configurable RETRY (default=50). In case changes to the graph occur concurrently, any conflicts are caught transparently by OrientDB and the operations are repeated. The operations that support the auto-retry are:

- `CREATE EDGE`
- `DELETE EDGE`
- `DELETE VERTEX`

## Usage

To use consistency modes that don't use transactions, set the `sql.graphConsistencyMode` global setting to `notx_sync_repair` or `notx_async_repair` in OrientDB `bin/server.sh` script or in the `config/orientdb-server-config.xml` file under properties section. Example: 

```xml
...
<properties>
  ...
  <entry name="sql.graphConsistencyMode" value="notx_sync_repair"/>
  ...
</properties>
```

The same could be set by code, before you open any Graph. Example:

```java
OGlobalConfiguration.SQL_GRAPH_CONSISTENCY_MODE.setValue("notx_sync_repair");
```

To make this setting persistent, set the `txRequiredForSQLGraphOperations` property in the storage configuration, so during the following opening of the Graph, you don't need to set the global setting again:

```java
g.getRawGraph().getStorage().getConfiguration().setProperty("txRequiredForSQLGraphOperations", "false");
```


### Usage via Java API
In order to use non-transactional graphs, after having configured the consistency mode (as above), you can now work with the `OrientGraphNoTx` class. Example:

```java
OrientGraphNoTx g = new OrientGraphNoTx("plocal:/temp/mydb");
...
v1.addEdge( "Friend", v2 );
```

Concurrent threads that change the graph will retry the graph change in case of concurrent modification (MVCC). The default value for maximum retries is 50. To change this value, call the `setMaxRetries()` API:

```java
OrientGraphNoTx g = new OrientGraphNoTx("plocal:/temp/mydb");
g.setMaxRetries(100);
```

This setting will be used on the active graph instance. You can have multiple threads, which work on the same graph by using multiple graph instances, one per thread. Each thread can then have different settings. It's also allowed to wirk with threads, which use transactions (`OrientGraph` class) and to work with concurrent threads, which don't use transactions.
