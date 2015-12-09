# Graph Consistency

Before OrientDB v2.1.7 the graph consistency could be assured only by using transactions. The problems on using transactions for simple operations like creation of edges are:
- **speed**, the transaction has a cost in comparison with non transactional operations
- management of **optimistic retry** at application level. Firthermore with 'remote' connection this means high latency
- **low scalability on high concurrency** (this will be resolved in OrientDB v3.0 where commit will not lock the database anymore)

Starting from v2.1.7, OrientDB provides a new mode to manage graphs without using transactions by using the Java class `OrientGraphNoTx` or via SQL by changing the global setting `sql.graphConsistencyMode` to one of the following values:
- `tx`, the default, uses transactions to maintain consistency. This was the only available setting before v2.1.7
- `notx_sync_repair`, doesn't use transactions and the consistency, in case of JVM crash, is guaranteed by a database repair operation that run at startup in synchronous mode. The database cannot be used until the repair is finished
- `notx_async_repair`, doesn't use transactions and the consistency, in case of JVM crash, is guaranteed by a database repair operation that run at startup in asynchronous mode. The database can be used instantanely and the repair procedure is running in background

Both the new modes `notx_sync_repair` and `notx_async_repair` manage conflicts automatically with a configurable RETRY (default=50). In case changes to the graph occur concurrently, any conflicts are caught transparently by OrientDB and the operations are repeated. The operations that support the auto-retry are:
- `CREATE EDGE`
- `DELETE EDGE`
- `DELETE VERTEX`

## Usage

To use consistencies mode that don't use transactions, set the `sql.graphConsistencyMode` setting to `notx_sync_repair` or `notx_async_repair` in OrientDB `bin/server.sh` script or in the `config/orientdb-server-config.xml` file under properties section. Example: 

```xml
...
<properties>
  ...
  <entry name="sql.graphConsistencyMode" value="notx_sync_repair"/>
  ...
</properties>
```

The same could be set by code before to open any Graph. Example:

```java
OGlobalConfiguration.SQL_GRAPH_CONSISTENCY_MODE.setValue("notx_sync_repair");
```

### Usage via Java API
In order to use non transactional graphs, after having configured the consistency mode (look above), work with the `OrientGraphNoTx` class. Example:

```java
OrientGraphNoTx g = new OrientGraphNoTx("plocal:/temp/mydb");
...
v1.addEdge( "Friend", v2 );
```

Concurrent threads that change the graph will retry the graph change in case of concurrent modification (MVCC). The default value for maximum retry is 50. To change it call the `setMaxRetries()` API:

```java
OrientGraphNoTx g = new OrientGraphNoTx("plocal:/temp/mydb");
g.setMaxRetries(100);
```

This setting will be used on the active graph instance. You can have multiple threads that work on the same graph by using multipel graph instances, one per thread, where each of them can have different settings. It's also allowed to have threads that use transactions (`OrientGraph` class) working with concurrent threads that don't use it.
