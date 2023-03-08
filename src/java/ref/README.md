
# Java API - Reference

OrientDB is written in Java and as such you can utilize the Java API without the need for any additional drivers or adapters.  Instead, with the addition of a dependency you can import OrientDB's code directly into your application to either query or manipulate data from a running instance of OrientDB or to embed the OrientDB Server itself within your application.

This chapter provides reference documentation for the OrientDB Java API.  The list of classes and methods documented here is not exhaustive, but rather pragmatic: focusing on those developers are more likely to use in building applications around OrientDB.

## Classes

| Class | Description |
|---|---|
| [**`OClass`**](OClass.md) | Manages database classes |
| [**`OCluster`**](OCluster.md) | Manages physical and memory clusters |
| [**`ODatabaseDocument`**](ODatabaseDocument.md) | Manages databases.  This is the unified multi-model API.  It works with all supported database models (i.e., graph, document, object and so on). |
| [**`ODatabaseSession`**](ODatabaseSession.md) | Subclass of [`ODatabaseDocument`](ODatabaseDocument.md), used to manage database sessions. |
| [**`OEdge`**](OEdge.md) | Handles edge records.  It is a subclass of [`OElement`](OElement.md) |
| [**`OElement`**](OElement.md) | Handles document records, superclass to [`OVertex`](OVertex.md) and [`OEdge`](OEdge.md) records |
| [**`OFunctionLibrary`**](OFunctionLibrary.md) | Manages the functions available in OrientDB SQL on the database |
| [**`OIntent`**](OIntent.md) | Manages intents (server optimizations) for particular tasks |
| [**`OLiveQueryResultListener`**](OLiveQueryResultListener.md) | Super class used to manage [Live Queries](../Live-Query.md) |
| [**`OMetadata`**](OMetadata.md) | Interface used to store database metadata, such as the function library, schema and security |
| [**`OProperty`**](OProperty.md) | Manages properties on an [`OClass`](OClass.md) instance |
| [**`OResult`**](OResult.md) | Interface for operating on records in a result-set |
| [**`OResultSet`**](OResultSet.md) | Result-set returned by queries |
| [**`ORID`**](ORID.md) | Record ID for [`OElement`](OElement.md), [`OEdge`](OEdge.md) and [`OVertex`](OVertex.md) instances |
| [**`OrientDB`**](OrientDB.md) | Connects to and interacts with the OrientDB Server |
| [**`ORule`**](ORule.md) | Defines rule for resources that a user or role can access |
| [**`OSchema`**](OSchema.md) | Defines a schema for the database to enforce |
| [**`OSecurityRole`**](OSecurityRole.md) | Controls a role and the access it has to database resources |
| [**`OSecurityUser`**](OSecurityUser.md) | Controls a user and the access it has to database resources |
| [**`OServer`**](OServer.md) | Embeds the OrientDB Server |
| [**`OTransaction`**](OTransaction.md) | Controls a transaction on the database |
| [**`OType`**](OType.md) | Defines the data-types of properties |
| [**`OVertex`**](OVertex.md) | Handles vertex records.  It is a subclass of [`OElement`](OElement.md) |

In the event that you don't find a page for the class or method you're looking for, see the [Javadocs]({{ book.javadoc }}).



