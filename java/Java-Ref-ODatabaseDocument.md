---
search:
   keywords: ['java', 'ODocumentDatabase', 'document database']
---

# Java API - ODatabaseDocument 

This class provides a unified Mulit-Model interface for managing and administering OrientDB Document and Graph databases.

## Managing Databases

In previous versions of OrientDB, separate classes were used for Document and Graph databases.  This is because OrientDB began as a Document database and added support for Graph databases later, based on the Apache TinkerPop 2.x standard.  Beginning in version 3.0.x using this class, OrientDB provides a common interface for both database types.  It can be found at `com.orientechnologies.orient.core.db.document` .  For instance,

```java
import com.orientechnologies.orient.core.db.document.ODatabaseDocument;
```

Once you've imported the class to your application, you can use one of the constructors to build a particular instance in your code.

### Example

In order to operate on an instance of this class, you need to create it on the OrientDB Server, then open it through an [`OrientDB()`](Java-Ref-OrientDB.md) or [`OServer`](Java-Ref-OServer.md) instance.  For example, in your own application you might want to streamline the startup process, so that it creates a working database in the event that one isn't ready, then opens it.

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

Here, the method uses the [`exists`](Java-Ref-OrientDB-exists.md) method to determine of the database exists, runs theh [`create()`](Java-Ref-OrientDB-create.md) if it doesn't, then uses [`open()`](Java-Ref-OrientDB-open.md) with default credentials to open the `ODatabaseDocument` instance in your application.


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
| [**`close()`**](Java-Ref-ODatabaseDocument-close.md) | `void` | Closes the database. |
| [**`save()`**](Java-Ref-ODatabaseDocument-save.md) | `T` | Saves the given entity to the database. |


### Managing Classes and Clusters

| Method | Return Type | Description |
|---|---|---|
| [**`addCluster()`**](Java-Ref-ODatabaseDocument-addCluster.md) | [`int`]({{ javase }}/java/lang/Integer.html) | Adds a cluster to the database. |
| [**`browseClass`**](Java-Ref-ODatabaseDocument-browseClass.md) | `ORecordIteratorClass<ODocument>` | Retrieves all records of the given database class |
| [**`browseCluster()`**](Java-Ref-ODatabaseDocument-browseCluster.md) | `<REC extends ORecord> ORecordIteratorCluster<REC>` | Retrieves all records of the given cluster |
| [**`countClass()`**](Java-Ref-ODatabaseDocument-countClass.md) | [`long`]({{ book.javase }}/api/java/lang/Long.html) | Retrieves the number of records in the given database class |
| [**`createClass()`**](Java-Ref-ODatabaseDocument-createClass.md) | [`OClass`](Java-Ref-OClass.md) | Creates a new database class |
| [**`createClassIfNotExists()`**](Java-Ref-ODatabaseDocument-createClassIfNotExists.md) | [`OClass`](Java-Ref-OClass.md) | Creates a new database class, if not exists |
| [**`createEdgeClass()`**](Java-Ref-ODatabaseDocument-createEdgeClass.md) | [`OClass`](Java-Ref-OClass.md) | Creates a database class as an extension of the `E` edge class |
| [**`createVertexClass()`**](Java-Ref-ODatabaseDocument-createVertexClass.md) | [`OClass`](Java-Ref-OClass.md) | Creates a database class as an extension of the `V` vertex class |

<!--
- addBlobCluster
-->


### Managaing Records

| Method | Return Type | Description |
|---|---|---|
| [**`getRecord()`**](Java-Ref-ODatabaseDocument-getRecord.md) | `<RET extends ORecord> RET` | Retrieves a record from the database |
| [**`getRecordType()`**](Java-Ref-ODatabaseDocument-getRecordType.md) | [`byte`]({{ book.javase }}/api/java/lang/Byte.html) | Returns the default record type |
| [**`newBlob()`**](Java-Ref-ODatabaseDocument-newBlob.md) | `OBlob` | Creates a new instance of a binary blob containing the given bytes |
| [**`newEdge()`**](Java-Ref-ODatabaseDocument-newEdge.md) | [`OEdge`](Java-Ref-OEdge.md) | Creates a new edge between the given vertices |
| [**`newElement()`**](Java-Ref-ODatabaseDocument-newElement.md) | [`OElement`](Java-Ref-OElement.md) | Creates a new element (that is, a document, vertex or edge) |
| [**`newInstance()`**](Java-Ref-ODatabaseDocument-newInstance.md) | `RET` | Creates a new document, vertex or edge |
| [**`newVertex()`**](Java-Ref-ODatabaseDocument-newVertex.md) | `OVertex` | Creates a new vertex |

### Transactions

| Method | Return Type | Description |
|---|---|---|
| [**`begin()`**](Java-Ref-ODatabaseDocument-begin.md) | `ODatabase<T>` | Initiates a transaction |
| [**`commit()`**](Java-Ref-ODatabaseDocument-commit.md) | `ODatabase<T>` | Commits a transaction |
| [**`rollback()`**](Java-Ref-ODatabaseDocument-rollback.md) | `ODatabase<T>` | Reverts changes |






