
# Java API - ODatabaseDocument 

This class provides a unified Multi-Model interface for managing and administering OrientDB Document and Graph databases.

## Managing Databases

In previous versions of OrientDB, separate classes were used for Document and Graph databases.  This is because OrientDB began as a Document database and added support for Graph databases later, based on the Apache TinkerPop 2.x standard.  Beginning in version 3.0.x using this class, OrientDB provides a common interface for both database types.  It can be found at `com.orientechnologies.orient.core.db.document` .  For instance,

```java
import com.orientechnologies.orient.core.db.document.ODatabaseDocument;
```

Once you've imported the class to your application, you can use one of the constructors to build a particular instance in your code.

### Example

In order to operate on an instance of this class, you need to create it on the OrientDB Server, then open it through an [`OrientDB()`](OrientDB.md) or [`OServer`](OServer.md) instance.  For example, in your own application you might want to streamline the startup process, so that it creates a working database in the event that one isn't ready, then opens it.

```java
// INITIALIZE VARIABLES
private OrientDB orientdb;

// OPEN/CREATE DATABASE
public static ODatabaseDocument openDatabase(String name) {

   // Initialize Server Connection
   orientdb = new OrientDB("embedded:/tmp/", OrientDBConfig.defaultConfig());

   // Check if Database Exists
   if (!orientdb.exists(name)){
      orientdb.create(name, ODatabaseType.PLOCAL);
   }

   return orientdb.open(name, "admin", "admin");

}
```

Here, the method uses the [`exists`](OrientDB/exists.md) method to determine of the database exists, runs the [`create()`](OrientDB/create.md) if it doesn't, then uses [`open()`](OrientDB/open.md) with default credentials to open the `ODatabaseDocument` instance in your application.


## Methods

<!--
### Managing Databases
- checkSecurity
- freeze
- isPooled
- isValidationEnabled
- isRetainRecords
- release
- setRetainRecords
- setValidationEnabled
-->

| Method | Return Type | Description |
|---|---|---|
| [**`close()`**](ODatabaseDocument/close.md) | `void` | Closes the database |
| [**`command()`**](ODatabaseDocument/command.md) | [`OResultSet`](OResultSet.md) | Executes idempotent or non-idempotent query |
| [**`execute()`**](ODatabaseDocument/execute.md) |  [`OResultSet`](OResultSet.md) | Executes a query |
| [**`getMetadata()`**](ODatabaseDocument/getMetadata.md) | [`OMetadata`](OMetadata.md) | Retrieves the database metadata |
| [**`getName()`**](ODatabaseDocument/getName.md) | `String` | Retrieves the logical name of the database |
| [**`getURL()`**](ODatabaseDocument/getURL.md) | `String` | Retrieves the database URL |
| [**`getUser()`**](ODatabaseDocument/getUser.md) | [`OSecurityUser`](OSecurityUser.md) | Retrieves the current user |
| [**`incrementalBackup()`**](ODatabaseDocument/incrementalBackup.md) | `String` | Performs an incremental backup of the database to the given path |
| [**`isActiveOnCurrentThread()`**](ODatabaseDocument/isActiveOnCurrentThread.md) | `boolean` | Checks whether the current database is active on the current thread |
| [**`isClosed()`**](ODatabaseDocument/isClosed.md) | `boolean` | Checks whether the database is closed |
| [**`live()`**](ODatabaseDocument/live.md) | [`OLiveQueryMonitor`](OLiveQueryMonitor.md) | Subscribes query as a live query |
| [**`load()`**](ODatabaseDocument/load.md) | `<RET extends T> RET` | Loads a record by its Record ID |
| [**`query()`**](ODatabaseDocument/query.md) | [`OResultSet`](OResultSet.md) | Queries the database |
| [**`registerListener()`**](ODatabaseDocument/registerListener.md) | `void` | Subscribes the given listener to database events |
| [**`save()`**](ODatabaseDocument/save.md) | `T` | Saves the given entity to the database |
| [**`unregisterListener()`**](ODatabaseDocument/unregisterListener.md) | `void` | Unsubscribes the given listener from database events |


### Managing Classes and Clusters

| Method | Return Type | Description |
|---|---|---|
| [**`addCluster()`**](ODatabaseDocument/addCluster.md) | [`int`]({{ book.javase }}/api/java/lang/Integer.html) | Adds a cluster to the database. |
| [**`browseClass`**](ODatabaseDocument/browseClass.md) | `ORecordIteratorClass<ODocument>` | Retrieves all records of the given database class |
| [**`browseCluster()`**](ODatabaseDocument/browseCluster.md) | `<REC extends ORecord> ORecordIteratorCluster<REC>` | Retrieves all records of the given cluster |
| [**`countClass()`**](ODatabaseDocument/countClass.md) | [`long`]({{ book.javase }}/api/java/lang/Long.html) | Retrieves the number of records in the given database class |
| [**`countClusterElements()`**](ODatabaseDocument/countClusterElements.md) | [`long`]({{ book.javase }}/api/java/lang/Long.html) | Counts all entities in the specified cluster. |
| [**`createClass()`**](ODatabaseDocument/createClass.md) | [`OClass`](OClass.md) | Creates a new database class |
| [**`createClassIfNotExists()`**](ODatabaseDocument/createClassIfNotExists.md) | [`OClass`](OClass.md) | Creates a new database class, if not exists |
| [**`createEdgeClass()`**](ODatabaseDocument/createEdgeClass.md) | [`OClass`](OClass.md) | Creates a database class as an extension of the `E` edge class |
| [**`createVertexClass()`**](ODatabaseDocument/createVertexClass.md) | [`OClass`](OClass.md) | Creates a database class as an extension of the `V` vertex class |
| [**`dropCluster()`**](ODatabaseDocument/dropCluster.md) | `boolean` | Removes cluster from database |
| [**`existsCluster()`**](ODatabaseDocument/existsCluster.md) | `boolean` | Determines whether a cluster exists on the database |
| [**`getClass()`**](ODatabaseDocument/getClass.md) | [`OClass`](OClass.md) | Retrieves the given class from the database |
| [**`getClusterIdByName()`**](ODatabaseDocument/getClusterIdByName.md) | `int` | Retrieves the Cluster ID for the given cluster name |
| [**`getClusterNameById()`**](ODatabaseDocument/getClusterNameById.md) | `String` | Retrieves the cluster name for the given ID |
| [**`getClusters()`**](ODatabaseDocument/getClusters.md) | `int` | Returns the number of clusters on the database |
| [**`getDefaultClusterId()`**](ODatabaseDocument/getDefaultClusterId.md) | `int` | Returns the default Cluster ID |
| [**`truncateCluster()`**](ODatabaseDocument/truncateCluster.md) | `void` | Removes all data from the given cluster |

<!--
- addBlobCluster
-->


### Managing Records

| Method | Return Type | Description |
|---|---|---|
| [**`delete()`**](ODatabaseDocument/delete.md) | `ODatabase<T>` | Removes a record from the database |
| [**`getRecord()`**](ODatabaseDocument/getRecord.md) | `<RET extends ORecord> RET` | Retrieves a record from the database |
| [**`getRecordType()`**](ODatabaseDocument/getRecordType.md) | [`byte`]({{ book.javase }}/api/java/lang/Byte.html) | Returns the default record type |
| [**`newBlob()`**](ODatabaseDocument/newBlob.md) | `OBlob` | Creates a new instance of a binary blob containing the given bytes |
| [**`newEdge()`**](ODatabaseDocument/newEdge.md) | [`OEdge`](OEdge.md) | Creates a new edge between the given vertices |
| [**`newElement()`**](ODatabaseDocument/newElement.md) | [`OElement`](OElement.md) | Creates a new element (that is, a document, vertex or edge) |
| [**`newInstance()`**](ODatabaseDocument/newInstance.md) | `RET` | Creates a new document, vertex or edge |
| [**`newVertex()`**](ODatabaseDocument/newVertex.md) | [`OVertex`](OVertex.md) | Creates a new vertex |

### Managing Transactions

| Method | Return Type | Description |
|---|---|---|
| [**`begin()`**](ODatabaseDocument/begin.md) | `ODatabase<T>` | Initiates a transaction |
| [**`commit()`**](ODatabaseDocument/commit.md) | `ODatabase<T>` | Commits a transaction |
| [**`getTransaction()`**](ODatabaseDocument/getTransaction.md) | [`OTransaction`](OTransaction.md) | Retrieves the current transaction |
| [**`rollback()`**](ODatabaseDocument/rollback.md) | `ODatabase<T>` | Reverts changes |


### Managing Intents


| Method | Return Type | Description |
|---|---|---|
| [**`declareIntent()`**](ODatabaseDocument/declareIntent.md) | [`boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Declares an intent for the database. |
| [**`getActiveIntent()`**](ODatabaseDocument/getActiveIntent.md) | [`OIntent`](OIntent.md) | Returns the Intent active for the current session |
