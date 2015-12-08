# Graph API

To use the Graph API include the following jars in your classpath:
```
orientdb-core-*.jar
blueprints-core-*.jar
orientdb-graphdb-*.jar 
```

Also include the following 3rd party jars:
```
jna-*.jar
jna-platform-*.jar
concurrentlinkedhashmap-lru-*.jar
```

If you're connected to a remote server (not local/plocal/memory modes) include also:
```
orientdb-client-*.jar
orientdb-enterprise-*.jar
```

To also use the [TinkerPop Pipes](http://wiki.github.com/tinkerpop/pipes) tool include also:
```
pipes-*.jar
```

To also use the [TinkerPop Gremlin](http://wiki.github.com/tinkerpop/gremlin) language include also:
```java
gremlin-java-*.jar
gremlin-groovy-*.jar
groovy-*.jar
```

_NOTE_: Starting from v2.0, [Lightweight Edges](Lightweight-Edges.md) are disabled by default when new database are created.

# Introduction

[Tinkerpop](http://www.tinkerpop.com) is a complete stack of projects to handle Graphs:
- **[Blueprints](http://wiki.github.com/tinkerpop/blueprints)** provides a collection of interfaces and implementations to common, complex data structures. In short, Blueprints provides a one stop shop for implemented interfaces to help developers create software without being tied to particular underlying data management systems.
- **[Pipes](http://pipes.tinkerpop.com)** is a graph-based data flow framework for Java 1.6+. A process graph is composed of a set of process vertices connected to one another by a set of communication edges. Pipes supports the splitting, merging, and transformation of data from input to output.
- **[Gremlin](http://wiki.github.com/tinkerpop/gremlin)** is a Turing-complete, graph-based programming language designed for key/value-pair multi-relational graphs. Gremlin makes use of an XPath-like syntax to support complex graph traversals. This language has application in the areas of graph query, analysis, and manipulation.
- **[Rexster](http://rexster.tinkerpop.com)** is a RESTful graph shell that exposes any Blueprints graph as a standalone server. Extensions support standard traversal goals such as search, score, rank, and, in concert, recommendation. Rexster makes extensive use of Blueprints, Pipes, and Gremlin. In this way its possible to run Rexster over various graph systems. To configure Rexster to work with OrientDB follow this guide: [configuration](Rexster.md).
- **[Sail Ouplementation](https://github.com/tinkerpop/blueprints/wiki/Sail-Ouplementation)** to use OrientDB as a RDF Triple Store.

# Get started with Blueprints
OrientDB supports different kind of storages and depends by the [Database URL](Concepts.md#database_url) used:
- **Persistent embedded** GraphDB. OrientDB is linked to the application as JAR (No network transfer). Use **[plocal](Paginated-Local-Storage.md)** as prefix. Example "plocal:/tmp/graph/test"
- **In-Memory embedded** GraphDB. Keeps all the data only in memory. Use **memory** as prefix. Example "memory:test"
- **Persistent remote** GraphDB. Uses a binary protocol to send and receive data from a remote OrientDB server. Use **remote** as prefix. Example "remote:localhost/test". It requires a OrientDB Server instance is up and running at the specified address (localhost in this case). Remote database can be persistent or in-memory as well.

# Working with the GraphDB

Before working with a graph you need an instance of [OrientGraph](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientGraph.html) class. The constructor gets a [URL](Concepts.md#database_url) that is the location of the database. If the database already exists, it will be opened, otherwise it will be created. However a new database can only be created in **plocal** or **memory** mode, not in **remote** mode. In multi-threaded applications use one [OrientGraph](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientGraph.html) instance per thread. Also all the graph components (Vertices and Edges) are not thread-safe, so sharing them between threads could cause unpredictable errors.

Remember to always close the graph once done using the <code>.shutdown()</code> method.

Example:
```java
OrientGraph graph = new OrientGraph("plocal:C:/temp/graph/db");
try {
  ...
} finally {
  graph.shutdown();
}
```
## Use the factory
Starting from v1.7 the best way to get a Graph instance is through the [OrientGraphFactory](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientGraphFactory.html). To know more: [Use the Graph Factory](Graph-Factory.md). Example:
```java
// AT THE BEGINNING
OrientGraphFactory factory = new OrientGraphFactory("plocal:C:/temp/graph/db").setupPool(1,10);

// EVERY TIME YOU NEED A GRAPH INSTANCE
OrientGraph graph = factory.getTx();
try {
  ...

} finally {
   graph.shutdown();
}
```

# Transactions

Before v2.1.7, every time the graph is modified an implicit transaction is started automatically if no previous transaction was running. Transactions are committed automatically when the graph is closed by calling the `shutdown()` method or by explicit `commit()`. To rollback changes call the `rollback()` method.

After v2.1.7, you can setup the [consistency level](Graph-Consistency.md).

Changes inside a transaction will be temporary until the commit or the close of the graph instance. Concurrent threads or external clients can see the changes only when the transaction has been fully committed.

Full example:

```java
try{
  Vertex luca = graph.addVertex(null); // 1st OPERATION: IMPLICITLY BEGIN A TRANSACTION
  luca.setProperty( "name", "Luca" );
  Vertex marko = graph.addVertex(null);
  marko.setProperty( "name", "Marko" );
  Edge lucaKnowsMarko = graph.addEdge(null, luca, marko, "knows");
  graph.commit();
} catch( Exception e ) {
  graph.rollback();
}
```

Surrounding the transaction between a try/catch assures that any errors will rollback the transaction to the previous status for all the involved elements. For more information, look at [Concurrency](Concurrency.md).

_NOTE_: Before v2.1.7, to work against a graph always use transactional [OrientGraph](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientGraph.html) instances and never non-transactional ones to avoid graph corruption from multi-threaded changes. A non-transactional graph instance created with <code>OrientGraphNoTx graph = factory.getNoTx();</code> is only useful if you don't work with data but want to define the [database schema](Graph-Schema.md) or for [bulk inserts](#using-non-transactional-graphs).

## Optimistic approach
OrientDB supports optimistic transactions, so no lock is kept when a transaction is running, but at commit time each graph element version is checked to see if there has been an update by another client. This is the reason why you should write your code to be concurrency-proof by handling the concurrent updating case:

```java
for (int retry = 0; retry < maxRetries; ++retry) {
    try {
        // LOOKUP FOR THE INVOICE VERTEX
        Iterable<Vertex> invoices = graph.getVertices("invoiceId", 2323);
        Vertex invoice = invoices.iterator().next();
        
        // CREATE A NEW ITEM
        Vertex invoiceItem = graph.addVertex("class:InvoiceItem");
        invoiceItem.field("price", 1000);
        // ADD IT TO THE INVOICE
        invoice.addEdge(invoiceItem);
        graph.commit();

        // OK, EXIT FROM RETRY LOOP
        break;
    } catch( ONeedRetryException e ) {
        // SOMEONE HAVE UPDATE THE INVOICE VERTEX AT THE SAME TIME, RETRY IT
    }
}
```

# Working with Vertices and Edges

## Create a vertex

To create a new Vertex in the current Graph call the [Vertex OrientGraph.addVertex(Object id)](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientBaseGraph.html#addVertex(java.lang.Object)) method. Note that the id parameter is ignored since OrientDB implementation assigns a unique-id once the vertex is created. To return it use [Vertex.getId()](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientElement.html#getId()).
Example:
```java
Vertex v = graph.addVertex(null);
System.out.println("Created vertex: " + v.getId());
```

## Create an edge

An Edge links two vertices previously created. To create a new Edge in the current Graph call the [Edge OrientGraph.addEdge(Object id, Vertex outVertex, Vertex inVertex, String label )](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientBaseGraph.html#addEdge(java.lang.Object,-Vertex,-Vertex,-java.lang.String)) method. Note that the id parameter is ignored since OrientDB implementation assigns a unique-id once the Edge is created. To return it use [Edge.getId()](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientElement.html#getId()). <code>outVertex</code> is the Vertex instance where the Edge starts and <code>inVertex</code> is the Vertex instance where the Edge ends. <code>label</code> is the Edge's label. Specify null to not assign it.
Example:
```java
Vertex luca = graph.addVertex(null);
luca.setProperty("name", "Luca");

Vertex marko = graph.addVertex(null);
marko.setProperty("name", "Marko");

Edge lucaKnowsMarko = graph.addEdge(null, luca, marko, "knows");
System.out.println("Created edge: " + lucaKnowsMarko.getId());
```

If you're interested on optimizing creation of edges by concurrent threads/clients, look at [Concurrency on adding edges](Concurrency.md#concurrency-on-adding-edges).

## Retrieve all the Vertices

To retrieve all the vertices use the `getVertices()` method:
```java
for (Vertex v : graph.getVertices()) {
    System.out.println(v.getProperty("name"));
}
```

## Retrieve all the Edges

To retrieve all the vertices use the [getEdges()](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientBaseGraph.html#getEdges()) method:
```java
for (Edge e : graph.getEdges()) {
    System.out.println(e.getProperty("age"));
}
```

NOTE: When [Lightweight Edges](Lightweight-Edges.md) are enabled (starting from v2.0 are disabled by default), edges are stored as links not as records. This is to improve performance. As a consequence, `getEdges()` will only retrieve records of class E.  With useLightweightEdges=true, records of class E are only created under certain circumstances (e.g. if the Edge has properties) otherwise they will be links on the in and out vertices.  If you really want `getEdges()` to return all edges, disable the [Lightweight Edges](Lightweight-Edges.md) feature by executing this command once: `alter database custom useLightweightEdges=false`. This will only take effect for new edges so you'll have to convert the links to actual edges before getEdges will return all edges. For more information look at: [Troubleshooting: Why can't I see all the edges](Troubleshooting.md#why-cant-i-see-all-the-edges).

## Removing a Vertex

To remove a vertex from the current Graph call the [OrientGraph.removeVertex(Vertex vertex)](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientBaseGraph.html#removeVertex(Vertex)) method. The vertex will be disconnected from the graph and then removed. Disconnection means that all the vertex's edges will be deleted as well.
Example:
```java
graph.removeVertex(luca);
```

## Removing an Edge

To remove an edge from the current Graph call the [OrientGraph.removeEdge(Edge edge)](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientBaseGraph.html#removeEdge(Edge)) method. The edge will be removed and the two vertices will not be connected anymore.
Example:
```java
graph.removeEdge(lucaKnowsMarko);
```

## Set and get properties

Vertices and Edges can have multiple properties where the key is a String and the value can be any [supported OrientDB types](Types.md).

- To set a property use the method [setProperty(String key, Object value)](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientElement.html#setProperty(java.lang.String,-java.lang.Object)).
- To get a property use the method [Object getProperty(String key)](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientElement.html#getProperty(java.lang.String)).
- To get all the properties use the method [Set&lt;String&gt; getPropertyKeys()](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientVertex.html#getPropertyKeys()).
- To remove a property use the method [void removeProperty(String key)](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientElement.html#removeProperty(java.lang.String)).

Example:
```java
vertex2.setProperty("x", 30.0f);
vertex2.setProperty("y", ((float) vertex1.getProperty( "y" )) / 2);

for (String property : vertex2.getPropertyKeys()) {
      System.out.println("Property: " + property + "=" + vertex2.getProperty(property));
}

vertex1.removeProperty("y");
```

### Setting Multiple Properties

*Blueprints Extension*
OrientDB Blueprints implementation supports setting of multiple properties in one shot against Vertices and Edges. This improves performance avoiding to save the graph element at every property set:
[setProperties(Object ...)](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientElement.html#setProperties(java.lang.Object...)). Example:

```java
vertex.setProperties( "name", "Jill", "age", 33, "city", "Rome", "born", "Victoria, TX" );
```
You can also pass a Map of values as first argument. In this case all the map entries will be set as element properties:

```java
Map<String,Object> props = new HashMap<String,Object>();
props.put("name", "Jill");
props.put("age", 33);
props.put("city", "Rome");
props.put("born", "Victoria, TX");
vertex.setProperties(props);
```

### Creating Element and Properties all together

If you want to create a vertex or an edge while setting the initial properties, the OrientDB Blueprints implementation offers new methods to do it:

```java
graph.addVertex("class:Customer", "name", "Jill", "age", 33, "city", "Rome", "born", "Victoria, TX");
```

This creates a new Vertex of class `Customer` with the properties: `name`, `age`, `city`, and `born`. The same is for Edges:

```java
person1.addEdge("class:Friend", person2, null, null, "since", "2013-07-30");
```

This creates a new Edge of class `Friend` between vertices `person1` and `person2` with the property `since`.

Both methods accept a `Map<String, Object>` as a parameter to set one property per map entry (see above for the example).

These methods are especially useful if you've declared constraints in the schema.  For example, a property cannot be null, and only using these methods will the validation checks succeed.

## Using Indices

OrientDB allows execution of queries against any field of vertices and edges, indexed and not-indexed. The first rule to speed up queries is to setup indices on the key properties you use in the query. For example, if you have a query that is looking for all the vertices with the name 'OrientDB' you do this:
```java
graph.getVertices("name", "OrientDB");
```
Without an index against the property "name" this execution could take a lot of time. So let's create a new index against the "name" property:
```java
graph.createKeyIndex("name", Vertex.class);
```
If the name MUST be unique you can enforce this constraint by setting the index as "UNIQUE" (this is an OrientDB only feature):
```java
graph.createKeyIndex("name", Vertex.class, new Parameter("type", "UNIQUE"));
```
This constraint will be applied to all the Vertex and sub-type instances. To specify an index against a custom type like the "Customer" vertices use the additional parameter "class":
```java
graph.createKeyIndex("name", Vertex.class, new Parameter("class", "Customer"));
```
You can also have both UNIQUE index against custom types:
```java
graph.createKeyIndex("name", Vertex.class, new Parameter("type", "UNIQUE"), new Parameter("class", "Customer"));
```
To create a case insensitive index use the additional parameter "collate":
```java
graph.createKeyIndex("name", Vertex.class, new Parameter("type", "UNIQUE"), new Parameter("class", "Customer"),new Parameter("collate", "ci"));
```
To get a vertex or an edge by key prefix use the class name before the property. For the example above use `Customer.name` in place of only `name` to use the index created against the field `name` of class `Customer`:
```java
for (Vertex v : graph.getVertices("Customer.name", "Jay")) {
    System.out.println("Found vertex: " + v);
}
```
If the class name is not passed, then "V" is taken for vertices and "E" for edges:
```java
graph.getVertices("name", "Jay");
graph.getEdges("age", 20);
```
For more information about indices look at [Index guide](Indexes.md).

# Using Non-Transactional Graphs

To speed up operations like on massive insertions you can avoid transactions by using a different class than OrientGraph: **OrientGraphNoTx**. In this case each operation is *atomic* and data is updated at each operation. When the method returns, the underlying storage is updated. Use this for bulk inserts and massive operations or for schema definition.

_NOTE_: Using non-transactional graphs could create corruption in the graph if changes are made in multiple threads at the same time. So use non-transactional graph instances only for non multi-threaded operations.

# Configure the Graph
Starting from v1.6 OrientDB supports configuration of the graph by setting all the properties during construction:

|Name|Description|Default value|
|----|-----------|-------------|
|blueprints.orientdb.url	|Database URL	|-|
|blueprints.orientdb.username	|User name	|admin|
|blueprints.orientdb.password	|User password	|admin|
|blueprints.orientdb.saveOriginalIds	|Saves the original element IDs by using the property _id_. This could be useful on import of a graph to preserve original ids.	|false|
|blueprints.orientdb.keepInMemoryReferences	|Avoids keeping records in memory by using only RIDs |false|
|blueprints.orientdb.useCustomClassesForEdges	|Uses the Edge's label as OrientDB class. If it doesn't exist create it under the hood.	|true|
|blueprints.orientdb.useCustomClassesForVertex	|Uses Vertex's label as OrientDB class. If it doesn't exist create it under the hood. |true|
|blueprints.orientdb.useVertexFieldsForEdgeLabels	|Stores the Edge's relationships in the Vertex by using the Edge's class. This allows using multiple fields and makes faster traversal by edge's label (class). |true|
|blueprints.orientdb.lightweightEdges	|Uses [Lightweight Edges](Lightweight-Edges.md). This avoids creating a physical document per edge. Documents are created only when the Edges have properties.	|false|
|blueprints.orientdb.autoStartTx	|Auto starts a transaction as soon as the graph is changed by adding/remote vertices and edges and properties. |true|

# Gremlin usage

If you use GREMLIN language with OrientDB remember to initialize it with:
```java
OGremlinHelper.global().create()
```

Look at these pages about GREMLIN usage:
- [How to use the Gremlin language with OrientDB](Gremlin.md)
- [Getting started with Gremlin](http://github.com/tinkerpop/gremlin/wiki/Getting-Started)
- [Usage of Gremlin through HTTP/RESTful API using the Rexter project](https://github.com/tinkerpop/rexster/wiki/Using-Gremlin).

# Multi-Threaded Applications

Multi-threaded applications must use one OrientGraph instance per thread. For more information about multi-threading look at [Java Multi Threading](Java-Multi-Threading.md). Also all the graph components (Vertices and Edges) are not thread-safe, so sharing them between threads could cause unpredictable errors.

# Blueprints Extensions

OrientDB is a Graph Database on steroids because it merges the graph, document, and object-oriented worlds together. Below are some of the features exclusive to OrientDB.

## Custom types

OrientDB supports custom types for vertices and edges in an Object Oriented manner. Even if this isn't supported directly by Blueprints there are some tricks to use them. Look at the [Graph Schema](Graph-Schema.md) page to know how to create a schema and work against types.

OrientDB added a few variants to the Blueprints methods to work with types.

### Creating vertices and edges in specific clusters

By default each class has one cluster with the same name. You can add multiple clusters to the class to allow OrientDB to write vertices and edges on multiple files. Furthermore working in [Distributed Mode](Distributed-Architecture.md) each cluster can be configured to be managed by a different server.

Example:
```java
// SAVE THE VERTEX INTO THE CLUSTER 'PERSON_USA' ASSIGNED TO THE NODE 'USA'
graph.addVertex("class:Person,cluster:Person_usa");
```

### Retrieve vertices and edges by type

To retrieve all the vertices of `Person` class use the special `getVerticesOfClass(String className)` method:
```java
for (Vertex v : graph.getVerticesOfClass("Person")) {
    System.out.println(v.getProperty("name"));
}
```

All the vertices of class Person and all subclasses will be retrieved. This is because by default polymorphism is used. If you're interested ONLY into `Person` vertices (excluding any sub-types) use the `getVerticesOfClass(String className, boolean polymorphic)` method specifying `false` in the second argument `polymorphic`:
```java
for (Vertex v : graph.getVerticesOfClass("Person", false)) {
    System.out.println(v.getProperty("name"));
}
```

The same variants also apply to the `getEdges()` method as:
- `getEdgesOfClass(String className)` and
- `getEdgesOfClass(String className, boolean polymorphic)`

## Ordered Edges

OrientDB, by default, uses a set to handle the edge collection. Sometimes it's better having an ordered list to access the edge by an offset. Example:

```java
person.createEdgeProperty(Direction.OUT, "Photos").setOrdered(true);
```

Every time you access the edge collection the edges are ordered. Below is an example to print all the photos in an ordered way.

```java
for (Edge e : loadedPerson.getEdges(Direction.OUT, "Photos")) {
  System.out.println( "Photo name: " + e.getVertex(Direction.IN).getProperty("name") );
}
```

To access the underlying edge list you have to use the Document Database API. Here's an example to swap the 10th photo with the last.

```java
// REPLACE EDGE Photos
List<ODocument> photos = loadedPerson.getRecord().field("out_Photos");
photos.add(photos.remove(9));
```

To have the same result by using SQL, execute the following commands:

```sql
create property out_Photos LINKLIST
alter property User.out_Photos custom ordered=true
```

## Working on detached elements

When you work with web applications, it’s very common to query elements and render them to the user to let him apply some changes. Once the user updates some fields and presses the “save” button, what happens?

Before now the developer had to track the changes in a separate structure, load the vertex/edge from the database, and apply the changes to the element.

Starting with OrientDB v1.7 we added two new methods to the Graph API on the OrientElement and OrientBaseGraph classes:
- `OrientElement.detach()`
- `OrientElement.attach()`
- `OrientBaseGraph.detach(OrientElement)`
- `OrientBaseGraph.attach(OrientElement)`

### Detach

Detach methods fetch all the record content in RAM and reset the connection to the Graph instance. This allows you to modify the element off-line and to re-attach it once finished.

### Attach

Once the detached element has been modified, to save it back to the database you need to call the `attach()` method. It restores the connection between the Graph Element and the Graph Instance.

### Example

The first step is load a vertex and detach it.
```java
OrientGraph g = OrientGraph("plocal:/temp/db");
try {
    Iterable<OrientVertex> results = g.query().has("name", EQUALS, "fast");
    for (OrientVertex v : results)
        v.detach();
} finally {
    g.shutdown();
}
```
After a while the element is updated (from GUI or by application)
```java
v.setProperty("name", "super fast!");
```

On “save” re-attach the element and save it to the database.
```java
OrientGraph g = OrientGraph("plocal:/temp/db");
try {
    v.attach(g);
    v.save();
} finally {
    g.shutdown();
}
```

### FAQ
**Does detach go recursively to detach all connected elements?**
No, it works only at the current element level.

**Can I add an edge against detached elements?**
No, you can only get/set/remove a property while is detached. Any other operation that requires the database will throw an IllegalStateException.

## Execute commands
The OrientDB Blueprints implementation allows you to execute commands using SQL, Javascript, and all the other supported languages.

### SQL queries
```java
for (Vertex v : (Iterable<Vertex>) graph.command(
            new OCommandSQL("SELECT EXPAND( out('bought') ) FROM Customer WHERE name = 'Jay'")).execute()) {
    System.out.println("- Bought: " + v);
}
```

It is possible to have parameters in a query using [prepared queries](Document-Database.md#prepared-query).

To execute an asynchronous query:
```java
graph.command(
          new OSQLAsynchQuery<Vertex>("SELECT FROM Member",
            new OCommandResultListener() {
              int resultCount =0;
              @Override
              public boolean result(Object iRecord) {
                resultCount++;
                Vertex doc = graph.getVertex( iRecord );
               return resultCount < 100;
              }
            } ).execute();
```


### SQL commands

Along with queries, you can execute any SQL command like `CREATE VERTEX`, `UPDATE`, or `DELETE VERTEX`. In the example below it sets a new property called "local" to true on all the Customers that live in Rome:
```java
int modified = graph.command(
          new OCommandSQL("UPDATE Customer SET local = true WHERE 'Rome' IN out('lives').name")).execute());
```

If the command modifies the schema (like `create/alter/drop class` and `create/alter/drop property` commands), remember to force updating of the schema of the database instance you're using by calling `reload()`:

```java
graph.getRawGraph().getMetadata().getSchema().reload();
```

For more information look at the [available SQL commands](SQL.md).

### SQL batch

To execute multiple SQL commands in a batch, use the OCommandScript and SQL as the language. This is recommended when creating edges on the server side, to minimize the network roundtrip:

```java
String cmd = "BEGIN\n";
cmd += "LET a = CREATE VERTEX SET script = true\n";
cmd += "LET b = SELECT FROM V LIMIT 1\n";
cmd += "LET e = CREATE EDGE FROM $a TO $b RETRY 100\n";
cmd += "COMMIT\n";
cmd += "return $e";

OIdentifiable edge = graph.command(new OCommandScript("sql", cmd)).execute();
```

For more information look at [SQL Batch](SQL-batch.md).


### Database functions

To execute a database function it must be written in Javascript or any other supported languages. In the example below we imagine having written the function `updateAllTheCustomersInCity(cityName)` that executes the same update like above. Note the 'Rome' attribute passed in the `execute()` method:
```java
graph.command(
          new OCommandFunction("updateAllTheCustomersInCity")).execute("Rome"));
```

### Code
To execute code on the server side you can select between the supported language (by default Javascript):
```java
graph.command(
          new OCommandScript("javascript", "for(var i=0;i<10;++i){ print('\nHello World!'); }")).execute());
```

This prints the line "Hello World!" ten times in the server console or in the local console if the database has been opened in "plocal" mode.

# Access to the underlying Graph

Since the TinkerPop Blueprints API is quite raw and doesn't provide ad-hoc methods for very common use cases, you might need to access the underlying ODatabaseGraphTx object to better use the graph-engine under the hood. Commons operations are:
- Count incoming and outgoing edges without browsing them all
- Get incoming and outgoing vertices without browsing the edges
- Execute a query using SQL-like language integrated in the engine

The [OrientGraph](https://github.com/orientechnologies/orientdb/blob/master/graphdb/src/main/java/com/tinkerpop/blueprints/impls/orient/OrientGraph.java) class provides the method <code>.getRawGraph()</code> to return the underlying database: [Document Database].

Example:
```java
final OrientGraph graph = new OrientGraph("plocal:C:/temp/graph/db");
try {
  List<ODocument> result = graph.getRawGraph().query(
                                   new OSQLSynchQuery("SELECT FROM V WHERE color = 'red'"));
} finally {
  graph.shutdown();
}
```

## Security

If you want to use OrientDB security, use the constructor that retrieves the [URL](Concepts.md#database_url), user and password. To know more about OrientDB security visit [Security](Security.md). By default the "admin" user is used.

# Tuning
Look at the [Performance Tuning Blueprints](Performance-Tuning-Graph.md) page.
