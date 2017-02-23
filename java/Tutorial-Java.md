---
search:
   keywords: ["tutorial", "Java API"]
---

# Java API Tutorial (LEGACY)

In the event that you have only used Relational database systems, you may find much of OrientDB very unfamiliar.  Given that OrientDB supports Document, Graph and Object Oriented modes, it requires that you use different Java API's, but there are some similarities between them.

Similar to the JDBC, the TinkerPop produces the [Blueprints API](https://github.com/tinkerpop/blueprints), which provides support for basic operations on Graph databases.  Using the OrientDB adapter, you can operate on a database without needing to manage OrientDB classes.  This makes the resulting code more portable, given that Blueprints offers adapters for other Graph database system.

Tweaking the database configuration itself requires that you use the OrientDB API's directly.  It is recommended in these situations that you use a mix, (that is, Blueprints when you can and the OrientDB API's where necessary).


## OrientDB Java API's

OrientDB provides three different Java API's that allow you to work with OrientDB.  Choose the Java API that supports the mode in which you want to work:

- [Graph API](Graph-Database-Tinkerpop.md)
- [Document API](Document-Database.md)
- [Object API](Object-Database.md)

>For more information on the API's in general, see [Java API](Java-API.md)

### Use Case: Graph API

Consider as an example setting up a Graph Database using the Java API with Blueprint.

#### Connecting to a Graph Database

In order to use the Graph API, you need to create an `OrientGraph` object first:

```java
import com.tinkerpop.blueprints.impls.orient.OrientGraph;

OrientGraph graph = new OrientGraph("local:test", 
        "username", "password");
```

When your application runs, these lines initialize the `graph` object to your OrientDB database using the Graph API.

#### Inserting Vertices

While you can work with the generic vertex class `V`, you gain much more power by defining custom types for vertices.  For instance,

```java
graph.createVertexType("Person");
graph.createVertexType("Address");
```

The Blueprint adapter for OrientDB is thread-safe and where necessary automatically creates transactions.  That is, it creates a transaction at the first operation, in the event that you have not yet explicitly started one.  You have to specify where these transactions end, for commits or rollbacks.

To add vertices into the database with the Blueprints API:

```java
Vertex vPerson = graph.addVertex("class:Person");
vPerson.setProperty("firstName", "John");
vPerson.setProperty("lastName", "Smith");

Vertex vAddress = graph.addVertex("class:Address");
vAddress.setProperty("street", "Van Ness Ave.");
vAddress.setProperty("city", "San Francisco");
vAddress.setProperty("state", "California");
```

When using the Blueprint API, keep in mind that the specific syntax to use is `class:<class-name>`.  You must use this syntax when creating an object in order to specify its class.  Note that this is not mandatory.  It is possible to specify a null value, (which means that the vertex uses the default `V` vertex class, as it is the super-class for all vertices in OrientDB).  For instance,

```java
Vertex vPerson = graph.addVertex(null);
```
However, when creating vertices in this way, you cannot distinguish them from other vertices in a query.


#### Inserting Edges

While you can work with the generic edge class `E`, you gain much more power by defining custom types for edges.  The method for adding edges is similar to that of vertices:

```java
OrientEdge eLives = graph.addEdge(null, vPerson, vAddress, "lives");
```

OrientDB binds the Blueprint label concept to the edge class.  That is, you can create an edge of the class `lives` by passing it as a label or as a class name.

```java
OrientEdge eLives = graph.addEdge("class:lives", vPerson, vAddress, null);
```

You have now created:

```
[John Smith:Person] --[lives]--> [Van Ness Ave:Address]
```

Bear in mind that, in this example, you have used a partially schema-full mode, given that you defined the vertex types, but not their properties.  By default, OrientDB dynamically accepts everything and works in a schema-less mode.


### Use Case: SQL Queries

While the Tinkerpop interfaces do allow you to execute fluent queries in SQL or Gremlin, you can also utilize the power of OrientDB SQL through the `.command()` method.  For instance,


```java
for (Vertex v : (Iterable<Vertex>) graph.command(
        new OCommandSQL(
		    "SELECT EXPAND(OUT('bough')) FROM Customer"
          + "WHERE name='Jay'")).execute()) {
    System.out.println("- Bought: " + v);
}
```

In addition to queries, you can also execute any SQL command, such as [`CREATE VERTEX`](../sql/SQL-Create-Vertex.md), [`UPDATE`](../sql/SQL-Update.md), or [`DELETE VERTEX`](../sql/SQL-Delete-Vertex.md).  For instance,

```java
int modified = graph.command(
        new OCommandSQL(
		    "UPDATE Customer SET local = TRUE" 
		  + "WHERE 'Rome' IN out('lives').name")).execute());
```

Running this command sets a new property called `local` to `TRUE` on all instances in the class `Customer` where these customers live in Rome.
