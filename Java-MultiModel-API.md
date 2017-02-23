# Java Multi-Model API 

**(since v 3.0)** 

OrientDB was born as a Document database. The fact that it has physical links 
(index-free adjacency) makes it a graph database, but still, the core API was 
designed as a Document API; the Graph API was added later, as a separate component,
based on Apache TinkerPop 2.x standard.

This led to a big discrepancy between the two APIs. See these two examples:

```java
// The Document API version

ODatabaseDocument db;
...
db.begin();
ODocument doc = db.newInstance("Person");
doc.field("name", "John");
doc.save();
db.commit()
db.close();

```

```java
// The Graph API (Apache TinkerPop 2.6) version
Graph graph;
...
OrientVertex v = graph.addVertex("class:Person");
v.setProperty("name", "John");
graph.commit();
graph.shutdown();
```


You can easily see the differences:

- different class hierarchies: ODocument and OrientVertex have only a common parent interface - OIdentifiable - 
 that doesn't even have methods to retrieve and manipulate properties
- different way to instantiate records: `db.newInstance("Person")` vs `graph.addVertex("class:Person")`
- different manipulation API: `doc.field("name", "John")` vs `v.setProperty("name", "John")`
- different object lifecycle: did you notice the `doc.save()`?


In OrientDB is a MultiModel db, so in v 3.0 we decided it was time to privide a single, **unified Multi-Model API**.

This means that with ODatabaseDocument instances you can query documents, but also graphs, without the need for an additional API.

*Don't worry, Apache TinkerPop 2.6 - together with the new 3.x - is still there, just as a separate dependency, so if you 
 rely on that you will have no problems migrating*
 
Before we give you a complete overview of the new Multi-Model API, here is a basic example that demonstrates how it works:

```java
ODatabaseDocument db;
...
OElement d = db.newInstance("DocClass");
d.setProperty("foo", "Bar");
d.save();

OVertex v1 = db.newVertex("VertexClass");
v1.setProperty("foo", "One");
v1.save();

OVertex v2 = db.newVertex("VertexClass");
v2.setProperty("foo", "Two");
v2.save();

v1.addEdge(v2, "EdgeClass").save();

db.commit();
```

###Multi-Model Data Hierarchy

The picture below shows the interface hierarchy of the Multi-Model API

![AddVertex1](images/ORecordHierarchy.png)

- **ORecord**: this is a pre-existing interface, common to all the persistent records
  
  Its main goal is to provide an abstraction to obtain low level information (eg. identity) and behavior 
  (eg. save and delete) for persistent entries  
- **OBlob**: represents BLOB (binary) records
- **OElement**: represents plain documents (so also vertices and edges). It includes methods
  to manipulate properties and to check if current element is a vertex or an edge.
  
  *Attention: until v 2.2 the Document API relied on ODocument class only. ODocument is still there
  as the main implementation of OElement, but please don't use it directly, always use OElement instead*
- **OVertex**: is the basic interface for vertices, it includes methods to manipulate and traverse connected edges and vertices
- **OEdge**: is the basic interface for edges, it includes methods to retrieve info regarding connected vertices

### Query Mechanisms and Interfaces

In v.2.2 you needed the *orientdb-graphdb* module to perform graph queries (eg. queries that use `out()`/`in()` operators); 
in V 3.0 we moved all the basic graph operators to the core module, basically you don't need *orientdb-graphdb* anymore, unless
you need explicit support for Apache TinkerPop API.

V 3.0 also includes a new [query interface](Java-Query-API.md) that explicitly return elements that can be converted to the Multi-Model 
interface hierarchy. 

### Summary

- [Database creation and connection](Java-MultiModel-Database-API.md)
- [Manipulating data in Java](Java-MultiModel-Data-API.md)
- [Running SQL statements in Java](Java-Query-API.md)
- [Defining Database Schema](Java-MultiModel-Schema-API.md)
