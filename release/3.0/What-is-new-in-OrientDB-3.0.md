
{% include "./include-warning-3.0.md" %}

## What's new in OrientDB 3.0?

### New database administration API

### New database access and pooling API

### Graph-document concepts unification in core API

**Core Graph API**

In v 3.0 TinkerPop is just an alternative graph API. The main graph API provided by OrientDB is in the Core module:

![AddVertex1](../../images/ORecordHierarchy.png)

**Create documets and graphs with the same API**

With the ODatabaseDocument API you can now create simple documents:

```java
  OElement doc = db.newInstance("ADocumentClass");
```

or graphs

```java
  OVertex vertex1 = db.newVertex("AVertexClass");
  OVertex vertex2 = db.newVertex("AVertexClass");  
  vertex1.addEdge("AnEdgeClass", vertex2);
```

**Unified and more powerful API for properties**

Now documents, vertices and edges have a single, unified API to get and set property names:

```java
  document.setProperty("name", "foo");
  vertex.setProperty("name", "foo");
  edge.setProperty("name", "foo");
  
  document.getProperty("name");
  vertex.getProperty("name");
  edge.getProperty("name");
```
  
> No more `doc.field("name")`  and `vertex.getProperty("name")`!!! 

Property names can now contain **any character**, including blank spaces, dots, brackets and special characters.


### New execution plan based query engine

OrientDB team completely re-wrote the SQL query engine. The new query engine is more strict, more accurate and explicit in the execution plannin and of course faster!

An example of the new execution planning:

```sql
SELECT sum(Amount), OrderDate 
FROM Orders 
WHERE OrderDate > date("2012-12-09", "yyyy-MM-dd")
GROUP BY OrderDate
```

```
+ FETCH FROM INDEX Orders.OrderDate
  OrderDate > date("2012-12-09", "yyyy-MM-dd")
+ EXTRACT VALUE FROM INDEX ENTRY
+ FILTER ITEMS BY CLASS 
  Orders
+ CALCULATE PROJECTIONS
  Amount AS _$$$OALIAS$$_1, OrderDate
+ CALCULATE AGGREGATE PROJECTIONS
      sum(_$$$OALIAS$$_1) AS _$$$OALIAS$$_0, OrderDate
  GROUP BY OrderDate
+ CALCULATE PROJECTIONS
  _$$$OALIAS$$_0 AS `sum(Amount)`, OrderDate
```

You can also obtain statistics about the cost of each step in the query execution:

```
+ FETCH FROM INDEX Orders.OrderDate (1.445μs)
  OrderDate > date("2012-12-09", "yyyy-MM-dd")
+ EXTRACT VALUE FROM INDEX ENTRY
+ FILTER ITEMS BY CLASS 
  Orders
+ CALCULATE PROJECTIONS (5.065μs)
  Amount AS _$$$OALIAS$$_1, OrderDate
+ CALCULATE AGGREGATE PROJECTIONS (3.182μs)
      sum(_$$$OALIAS$$_1) AS _$$$OALIAS$$_0, OrderDate
  GROUP BY OrderDate
+ CALCULATE PROJECTIONS (1.116μs)
  _$$$OALIAS$$_0 AS `sum(Amount)`, OrderDate
```

### Support for query on remote transactions

Until V 2.2 remote connection did not allow to mix API operations and SQL statemens in the same transaction.
Version 3.0 finally solves this limitation, now you can mix SQL and API operations in a single, remote transaction and the tx isolation will be guaranteed by OrientDB, transparently.

### Support streaming of query result set

In V 3.0 we re-designed the binary protocol and the ResultSet API to support streaming on query result sets. This means:

- lower latency in query execution
- much smaller memory footprint for query result sets, both on the server and on the client
- (if you are a Java developer) a new, modern Java 8 API based on Streams to manipulate query result sets

### Integration with Tinker Pop 3.x

OrientDB v3.0 is compliant with TinkerPop 3.x through an external plugin.

### Integration with Tinker Pop 2.x

OrientDB v3.0 is backward compatible with TinkerPop 2.6.x API through an external plugin. If you built your application with OrientDB 2.2 or minor and you don't want to migrate to the new API (the new Multi-Model or the new TinkerPop 3.x APIs), then download the version with TP2 plugin included.

### Externalization of object API

The Object Database API are now part of a separate module. If your existent application is using it, please include this module. For new application we don't suggest to use the Object Database API, but rather the new Multi-Model API.

### Improvements of storage caching for reduce latency


### New Demo DB 'Social Travel Agency'

Starting with OrientDB v.3.0 a new demo database is included. More information on the new demo database can be found [here](../../gettingstarted/demodb/README.md).
