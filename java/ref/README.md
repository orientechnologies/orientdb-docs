---
search:
   keywords: ['Java', 'Java API', 'reference']
---

# Java API - Reference

OrientDB is written in Java and as such you can utilize the Java API without the need for any additional drivers or adapters.  Instead, with the addition of a dependency you can import OrientDB's code directly into your application to either query or manipulate data from a running instance of OrientDB or to embed the OrientDB Server itself within your application.

This chapter provides reference documentation for the OrientDB Java API.  The list of classes and methods documented here is not exhaustive, but rather pragmatic: focusing on those developers are more likely to use in building applications around OrientDB.

## Classes

| Class | Description |
|---|---|
| [**`OClass`**](OClass.md) | Manages database classes |
| [**`OCluster`**](OCluster.md) | Manages physical and memory clusters |
| [**`ODatabaseDocument`**](ODatabaseDocument.md) | Manages databases.  This is the unified multi-model API.  It works with all supported database models (i.e., graph, document, object and so on).
| [**`OEdge`**](OEdge.md) | Handles edge records.  It is a subclass of [`OElement`](OElement.md) |
| [**`OElement`**](OElement.md) | Handles document records, superclass to [`OVertex`](OVertex.md) and [`OEdge`](OEdge.md) records |
| [**`OIntent`**](OIntent.md) | Manages intents (server optimizations) for particular tasks |
| [**`OProperty`**](OProperty.md) | Manages properties on an [`OClass`](OClass.md) instance |
| [**`OResultSet`**](OResultSet.md) | Result-set returned by queries |
| [**`ORID`**](ORID.md) | Record ID for [`OElement`](OElement.md), [`OEdge`](OEdge.md) and [`OVertex`](OVertex.md) instances |
| [**`OrientDB`**](OrientDB.md) | Connects to and interacts with the OrientDB Server |
| [**`OServer`**](OServer.md) | Embeds the OrientDB Server |
| [**`OType`**](OType.md) | Defines the data-types of properties |
| [**`OVertex`**](OVertex.md) | Handles vertex records.  It is a subclass of [`OElement`](OElement.md) |

In the event that you don't find a page for the class or method you're looking for, see the [Javadocs]({{ book.javadoc }}).



