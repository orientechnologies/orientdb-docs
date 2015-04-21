# Java Tutorial

If you're only used to working with traditional RDBMS databases, you'll find that OrientDB is a very different beast. Since OrientDB is able to support document mode, graph mode, and object-oriented mode, different Java APIs are required. But there are some similarities too: in a roughly similar way to JDBC, a [Blueprints](https://github.com/tinkerpop/blueprints/) API exists, made by Tinkerpop, which supports the basic operations on a graph database. There is an OrientDB "driver" (or, better, "adapter") which makes it possible to operate without having to deal with OrientDB classes, and the resulting code should be mainly portable (Blueprints offers more adapters for other graph database products).

In any case, if you need to tweak the database configuration, you need to use the OrientDB APIs directly. It's a good idea to use a mix: Blueprints when you can and the OrientDB APIs when you need them.

### OrientDB Java APIs
OrientDB comes with 3 different APIs. Pick your based on your model (for more information look at [Java API](Java-API.md)):
- [Graph API](Graph-Database-Tinkerpop.md) (suggested)
- [Document API](Document-Database.md)
- [Object API](Object-Database.md)

### Graph API

#### Connecting to a database

The first object you need is a `OrientGraph`:

```java
import com.tinkerpop.blueprints.impls.orient.OrientGraph;

OrientGraph graph = new OrientGraph("local:test", "username", "password");
```

Even though OrientDB can work with the generic class "V" for Vertices and "E" for Edges, it's much more powerful to define custom types for both Vertices and Edges:

```java
odb.createVertexType("Person");
odb.createVertexType("Address");
```

The Blueprint adapter is **thread-safe** and will **automatically create a transaction when needed** (e.g. at the first operation if a transaction hasn't been explicitly started). You have to specify where the transaction ends (commit or rollback) - see below for more details.


#### Inserting vertices and edges

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

Note the specific Blueprints syntax `"class:<class name>"` that you must use in the creation of an object to specify its class. It is not mandatory: it is also possible to specify a `null` value, which means that a vertex will be created with the class `V`, as it's the superclass of all vertices in OrientDB):

```java
Vertex vPerson = graph.addVertex(null);
```

A consequence is that we won't be able to distinguish it from other vertices in a query. To add an edge a similar API is used:

```java
OrientEdge eLives = graph.addEdge(null, vPerson, vAddress, "lives");
```
In OrientDB the Blueprints "label" concept is bound to Edge's class. You can create an edge of class "lives" by passing it as label (see the example above) or as class name:

```java
OrientEdge eLives = graph.addEdge("class:lives", vPerson, vAddress, null);
```

Now we have created

```
[John Smith:Person] --[lives]--> [Van Ness Ave:Address]
```

Please note that, in this example, we have used a partially schema-full mode, as we defined the vertex types, but not their properties. OrientDB will dynamically accept everything working in schema-less mode by default.

## SQL queries

TinkerPop interfaces allow to execute fluent queries or Gremlin queries, but you can still use the power of OrientBD SQL by using the `.command()` method. Example:
```java
for (Vertex v : (Iterable<Vertex>) graph.command(
            new OCommandSQL("select expand( out('bough') ) from Customer where name = 'Jay'")).execute()) {
    System.out.println("- Bought: " + v);
}
```
Along with queries, you can execute any SQL command like CREATE VERTEX, UPDATE, or DELETE VERTEX. In the example below it sets a new property called "local" to true on all the Customers that live in Rome:

```java
int modified = graph.command(
          new OCommandSQL("UPDATE Customer SET local = true WHERE 'Rome' IN out('lives').name")).execute());
```