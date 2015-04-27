# Java Tutorial

If you're only used to working with traditional RDBMS databases, you'll find that OrientDB is a very different beast. Since OrientDB is able to support document mode, graph mode, and object-oriented mode, different Java APIs are required. But there are some similarities too: in a roughly similar way to JDBC, a [Blueprints](https://github.com/tinkerpop/blueprints/) API exists, made by Tinkerpop, which supports the basic operations on a graph database. There is an OrientDB "driver" (or, better, "adapter") which makes it possible to operate without having to deal with OrientDB classes, and the resulting code should be mainly portable (Blueprints offers more adapters for other graph database products).

In any case, if you need to tweak the database configuration, you need to use the OrientDB APIs directly. It's a good idea to use a mix: Blueprints when you can and the OrientDB APIs when you need them.

### OrientDB Java APIs

OrientDB comes with 3 different APIs. Pick your based on your model (for more information look at [Java API](Java-API.md)):

- [Graph API](Graph-Database-Tinkerpop.md)
- [Document API](Document-Database.md)
- [Object API](Object-Database.md)

### Graph API

#### Connecting to a database

The first object you need is a `Graph` or a `TransactionalGraph` (which supports transaction demarcation):

```java
import com.tinkerpop.blueprints.TransactionalGraph;
import com.tinkerpop.blueprints.impls.orient.OrientGraph;

TransactionalGraph graph = new OrientGraph("local:test", "username", "password");
// or TransactionalGraph graph = new OrientGraph("remote:localhost/test", "username", "password");
```

In the following examples, until we introduce transactions, `TransactionalGraph` and `Graph` are used  interchangeably.

Another possibility is to create the database connection with the OrientDB APIs (this would make it possible to call tuning APIs, for instance), and then "wrap" it into an `OrientGraph`:

```java
import com.orientechnologies.orient.core.db.graph.OGraphDatabase;
import com.tinkerpop.blueprints.TransactionalGraph;
import com.tinkerpop.blueprints.impls.orient.OrientGraph;

OGraphDatabase odb = new OGraphDatabase("local:test").create();
TransactionalGraph graph = new OrientGraph(odb);
```

In any case, from a `TransactionalGraph` (or a `Graph`) it's always possible to get a reference to the OrientDB API:

```java
import com.tinkerpop.blueprints.impls.orient.OrientGraph;
import com.orientechnologies.orient.core.db.graph.OGraphDatabase;

OGraphDatabase odb = ((OrientGraph)graph).getRawGraph();
```

Even though OrientDB can work with the generic class "V" for Vertices and "E" for Edges, it's much more powerful to define custom types for both Vertices and Edges:

```java
odb.setUseCustomTypes(true);
odb.createVertexType("Person");
odb.createVertexType("Address");
```

The Blueprint adapter is **thread-safe** and will **automatically create a transaction when needed** (e.g. at the first operation if a transaction hasn't been explicitly started). You have to specify where the transaction ends (commit or rollback) - see below for more details.


#### Inserting vertices and edges

To add vertices into the database with the Blueprints API:

```java
import com.tinkerpop.blueprints.Graph;
import com.tinkerpop.blueprints.Vertex;

Vertex vPerson = graph.addVertex("class:Person");
vPerson.setProperty("firstName", "John");
vPerson.setProperty("lastName", "Smith");

Vertex vAddress = graph.addVertex("class:Address");
vAddress.setProperty("street", "Van Ness Ave.");
vAddress.setProperty("city", "San Francisco");
vAddress.setProperty("state", "California");
```

Note the specific Blueprints syntax `"class:<class name>"` that you must use in the creation of an object to specify its class. It is not mandatory: it is also possible to specify a `null` value, which means that a vertex will be created with the class `OGraphVertex`, as it's the superclass of all vertices in OrientDB):

```java
Vertex vPerson = graph.addVertex(null);
```

A consequence is that we won't be able to distinguish it from other vertices in a query.

To add an edge a similar API is used:

```java
import com.tinkerpop.blueprints.Graph;
import com.tinkerpop.blueprints.Edge;

Edge eLives = graph.addEdge(null, vPerson, vAddress, "lives");

```
We passed `null` to `addEdge()`, so we created an edge with the `OGraphEdge` class, which is the superclass of all edges in OrientDB. A consequence is that in a query we won't be able to distinguish it from other edges (except for its label).

The Blueprints adapter **automatically saves changes to the database** (in contrast to the native OrientDB API, which requires an explicit call to `save()`). Please remember that saving is a different operation than committing.


Now we have created

```
[John Smith:Person] --[lives]--> [Van Ness Ave. …:Address]
```

Please note that, in this example, we have used a partially schema-full mode, as we defined the vertex types, but not their properties. OrientDB will dynamically accept everything.
