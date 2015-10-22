# Java Tutorial

In the event that you are used only to Relation database systems, you may find OrientDB a very unfamiliar system to work with.  Given that it also supports Document, Graph and Object-Oriented modes, it requires different Java API's.  But, there are some similarities between them too.

Similar to JDBC, a [Blueprints](https://github.com/tinkerpop/blueprints) API exists, made by Tinkerpop, which supports the basic operations on a graph database.  There is an OrientDB driver, (or, to be more accurate, an adapter), which makes it possible to operate without having to deal with OrientDB classes.  This means that the resulting code is more portable, given that Blueprints offers adapters to other graphing database systems.

If you need to tweak the database configuraiton, you need to use OrientDB API's directly.  It is recommend that in these situations you use a mix: Bluepringts when you can, the OrientDB API's where necessary.


## OrientDB Java APIs

There are three different API's that OrientDB ships with.  Choose one based on your mode.

- [Graph API](Graph-Database-Tinkerpop.md) (suggested)
- [Document API](Document-Database.md)
- [Object API](Object-Database.md)

OrientDB comes with 3 different APIs. Pick your based on your model (for more information look at [Java API](Java-API.md)):

For more information on the API's in general, see [Java API](Java-API.md)


### Graph API

#### Connecting to a Graph Database

The first object you need is a `OrientGraph`:

```java
import com.tinkerpop.blueprints.impls.orient.OrientGraph;

OrientGraph graph = new OrientGraph("local:test", "username", "password");
```


#### Inserting Vertices and Edges

While OrientDB can work with the generic `V` class for verticies and `E` class for edges, you gain much more power by defining custom types for both vertices and edges.

```java
odb.createVertexType("Person");
odb.createVertexType("Address");
```

The Blueprint adapter for OrientDB is thread-safe and automatically creates a transaction where necessary.  That is, it creates a transaction at the first operation, in the event that a transaction has not yet explicitly been started.  You have to specify where transactions end, for commits or rollbacks.

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

Bear in mind, the specific syntax with Blueprint is `class:<class name>`.  You must use this syntax in creating an object to specify its class.  This is not mandatory.  It is also possible to specify a `null` value, (which means a vertex is created with the class `V`, as its the superclass for all vertices in OrientDB).

```java
Vertex vPerson = graph.addVertex(null);
```

In consequence of this is that you cannot distinguish `null` vertices from other vertices in a query.

Use a similar API in adding an edge:

```java
OrientEdge eLives = graph.addEdge(null, vPerson, vAddress, "lives");
```

In OrientDB, the Blueprints label concept is bound to an edge's class.  You can create an edge of the class `lives` by passing it as a label or as a class name.

```java
OrientEdge eLives = graph.addEdge("class:lives", vPerson, vAddress, null);
```

You have now created:

```
[John Smith:Person] --[lives]--> [Van Ness Ave:Address]
```

Bear in mind that, in this example, you have used a partially schema-full mode, as you defined the vertex types, but not their properties.  By default, OrientDB dynamically accepts everything working in a schema-less mode.


### SQL queries

The Tinkerpop interfaces allow you to execute fluent queries or Germlin queries, but you can still use the power of OrientDB SQL through the `.command()` method.

```java
for (Vertex v : (Iterable<Vertex>) graph.command(
            new OCommandSQL("SELECT EXPAND( OUT('bough') ) FROM Customer WHERE name='Jay'")).execute()) {
                  System.out.println("- Bought: " + v);
            }
```

In addition to queries, you can also execute any SQL command, such as [CREATE VERTEX](SQL-Create-Vertex.md), [Update](SQL-Update.md), or [DELETE VERTEX](SQL-Delete-Vertex.md).  


Along with queries, you can execute any SQL command like CREATE VERTEX, UPDATE, or DELETE VERTEX. For example,
```java
int modified = graph.command(
          new OCommandSQL("UPDATE Customer SET local = true WHERE 'Rome' IN out('lives').name")).execute());
```

This sets a new property called `local` to `true` on all instances in the `Customer` class that live in Rome.
