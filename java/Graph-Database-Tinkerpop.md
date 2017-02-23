---
search:
   keywords: ['Java', 'Graph API', 'TinkerPop']
---

# Graph API

OrientDB follows the [TinkerPop Blueprints](https://github.com/tinkerpop/blueprints) standard and uses it as the default for the Java Graph API.

When you install OrientDB, it loads a number of Java libraries in the `$ORIENTDB_HOME/lib` directory.  In order to use the Graph API, you need to load some of these JAR files into your class-path.  The specific files that you need to load varies depending on what you want to do.

To use the Graph API, load the following JAR's:
- `orientdb-core-*.jar`
- `blueprints-core-*.jar`
- `orientdb-graphdb-*.jar`

You may also benefit from these third-party JAR's:
- `jna-*.jar`
- `jna-platform-*.jar`
- `concurrentlinkedhashmap-lru-*.jar`

If you need to connect to a remote server, (as opposed to connecting in Local PLocal or Memory modes), you need to include these JAR's:
- `orientdb-client-*.jar`
- `orientdb-enterprise-*.jar`

To use the [TinkerPop Pipes](http://wiki.github.com/tinkerpop/pipes) tool, include this JAR:
- `pipes-*.jar`

To use the [TinkerPop Gremlin](http://wiki.github.com/tinkerpop/gremlin) language, include these JAR's:
- `gremlin-java-*.jar`
- `gremlin-groovy-*.jar`
- `groovy-*.jar`

>Bear in mind, beginning with version 2.0, OrientDB disables  [Lightweight Edges](../Lightweight-Edges.md) by default when it creates new databases.

## Introduction

[Tinkerpop](http://www.tinkerpop.com) provides a complete stack to handle Graph Databases:
- [**Blueprints**](http://wiki.github.com/tinkerpop/blueprints) Provides a collection of interfaces and implementations to common, complex data structures.

  In short, Blueprints provides a one-stop shop for implemented interfaces to help developers create software without getting tied down to the particular, underlying data management systems.
- [**Pipes**](http://pipes.tinkerpop.com) Provides a graph-based data flow framework for Java 1.6+.

  Process graphs are composed of a set of process vertices connected to one another by a set of communication edges.  Pipes supports the splitting, merging, and transformation of data from input to output/
- [**Gremlin**](http://wiki.github.com/tinkerpop/gremlin) Provides a Turing-complete graph-based programming language designed for key/value pairs in multi-relational graphs.  Gremlin makes use of an XPath-like syntax to support complex graph traversals.  This language has applications in the areas of graph query, analysis, and manipulation.
- [**Rexster**](http://rexster.tinkerpop.com) Provides a RESTful graph shell that exposes any Blueprints graph as a standalone server.

  Extensions support standard traversal goals such as search, score, rank, and (in concert) recommendation.  Rexster makes extensive use of Blueprints, Pipes, and Gremlin.  In this way it's possible to run Rexster over various graph systems.  to configure Rexster to work with OrientDB, see the guide [Rexster Configuration](../Rexster.md).
- [**Sail Ouplementation**](https://github.com/tinkerpop/blueprints/wiki/Sail-Ouplementation) Provides support for using OrientDB as an RDF Triple Store.

## Getting Started with Blueprints

OrientDB supports three different kinds of storages, depending on the [Database URL](../Concepts.md#database-url) used:

- **Persistent Embedded Graph Database**: Links to the application as a JAR, (that is, with no network transfer).  Use [PLocal](../Paginated-Local-Storage.md) with the `plocal` prefix.  For instance, `plocal:/tmp/graph/test`.
- **In-Memory Embedded Graph Database**: Keeps all data in memory.  Use the `memory` prefix, for instance `memory:test`.
- **Persistent Remote Graph Database** Uses a binary protocol to send and receive data from a remote OrientDB server.  Use the `remote` prefix, for instance `remote:localhost/test` Note that this requires an OrientDB server instance up and running at the specific address, (in this case, localhost).  Remote databases can be persistent or in-memory as well.

In order to use the Graph API, you need to create an instance of the [`OrientGraph`](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientGraph.html) class.  The constructor receives a [Database URL](../Concepts.md#database-url) that is the location of the database.  If the database already exists, the Graph API opens it.  If it doesn't exist, the Graph API creates it.  

>**NOTE**: When creating a database through the Graph API, you can only create PLocal and Memory databases.  Remote databases must already exist.

>**NOTE**: In v. 2.2 and following releases, when using PLocal or Memory,please set MaxDirectMemorySize (JVM setting) to a high value, like 512g ``` -XX:MaxDirectMemorySize=512g ```

When building multi-threaded application, use one instance of [`OrientGraph`](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientGraph.html) per thread.  Bear in mind that all graph components, such as vertices and edges, are not thread safe.  So, sharing them between threads may result in unpredictable results.

Remember to always close the graph instance when you are done with it, using the `.shutdown()` method.  For instance:

```java
OrientGraph graph = new OrientGraph("plocal:C:/temp/graph/db");
try {
  ...
} finally {
  graph.shutdown();
}
```

### Using the Factory

Beginning with version 1.7, OrientDB introduces the [`OrientGraphFactory`](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientGraphFactory.html) class as new method for creating graph database instances through the API.

```java
// AT THE BEGINNING
OrientGraphFactory factory = new OrientGraphFactory("plocal:/tmp/graph/db").setupPool(1,10);

// EVERY TIME YOU NEED A GRAPH INSTANCE
OrientGraph graph = factory.getTx();
try {
  ...

} finally {
   graph.shutdown();
}
```

>For more information, see [Graph Factory](Graph-Factory.md).


## Transactions

Prior to version 2.1.7, whenever you modify the graph database instance, OrientDB automatically starts an implicit transaction, in the event that no previous transactions are running.  When you close the graph instance, it commits the transaction automatically by calling the `.shutdown()` method or through `.commit()`.  This allows you to roll changes back where necessary, using the `.rollback()` method.

Beginning in version 2.1.8, you can set the [Consistency Level](../Graph-Consistency.md).  Changes within the transaction remain temporary until the commit or the closing of the graph database instance.  Concurrent threads or external clients can only see the changes after you fully commit the transaction.

For instance,

```java
try{
  Vertex luca = graph.addVertex(null); // 1st OPERATION: IMPLICITLY BEGINS TRANSACTION
  luca.setProperty( "name", "Luca" );
  Vertex marko = graph.addVertex(null);
  marko.setProperty( "name", "Marko" );
  Edge lucaKnowsMarko = graph.addEdge(null, luca, marko, "knows");
  graph.commit();
} catch( Exception e ) {
  graph.rollback();
}
```

By surrounding the transaction in `try` and `catch`, you ensure that any errors that occur roll the transaction back to its previous state for all relevant elements.  For more information, see [Concurrency](../Concurrency.md).

>**NOTE**: Prior to version 2.1.7, to work with a graph always use transactional [`OrientGraph`](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientGraph.html) instances and never the non-transactional instances to avoid graph corruption from multi-threaded updates.
>
> Non-transactional graph instances are created with
>
>```java
>OrientGraphNoTx graph = factor.getNoTx();
>```
>
>This instance is only useful when you don't work with data, but want to define the [database schema](Graph-Schema.md) or for [bulk inserts](#using-non-transactional-graphs).

### Optimistic Transactions

OrientDB supports optimistic transactions.  This means that no lock is kept when a transaction runs, but at commit time each graph element version is checked to see if there has been an update by another client.

For this reason, write your code to handle the concurrent updating case:


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

### Using Non-Transactional Graphs

In cases such as massive insertions, you may find the standard transactional graph `OrientGraph` is too slow for your needs.  You can speed the operations up by using the non-transactional `OrientGraphNoTx` graph.

With the non-transactional graph, each operation is *atomic* and it updates data on each operation.  When the method returns, the underlying storage updates.  This works best for bulk inserts and massive operations, or for schema definitions.

>**NOTE**: Using non-transactional graphs may cause corruption in the graph in cases where changes are made through multiple threads at the same time.  It is recommended that you only use non-transactional graph instances for single-threaded operations.

## Graph Configuration

Beginning in version 1.6 of OrientDB, you can configure the graph by setting all of its properties during construction:

- **`blueprints.orientdb.url`**	Defines the database URL.
- **`blueprints.orientdb.username`** Defines the username

  Default: `admin`
- **`blueprints.orientdb.password`** Defines the user password.

  Default: `admin`
- **`blueprints.orientdb.saveOriginalIds`** Defines whether it saves the original element ID's by using the property `id`.  You may find this useful when importing a graph to preserve original ID's.

  Default: `false`
- **`blueprints.orientdb.keepInMemoryReferences`** Defines whether it avoids keeping records in memory, by using only Record ID's.

  Default: `false`
- **`blueprints.orientdb.useCustomClassesForEdges`** Defines whether it uses the edge label as the OrientDB class.  If the class doesn't exist, it creates it for you.

  Default: `true`
- **`blueprints.orientdb.useCustomClassesForVertex`** Defines whether it uses the vertex label as the OrientDB class.  If the class doesn't exist, it creates it for you.

  Default: `true`
- **`blueprints.orientdb.useVertexFieldsForEdgeLabels`** Defines whether it stores the edge relationship in the vertex by using the edge class.  This allows you to use multiple fields and makes traversals by the edge label (class) faster.

  Default: `true`
- **`blueprints.orientdb.lightweightEdges`** Defines whether it uses [Lightweight Edges](../Lightweight-Edges.md).  This allows you to avoid creating a physical document per edge.  Documents are only created when edges have properties.

  Default: `false`
- **`blueprints.orientdb.autoStartTx`** Defines whether it auto-starts transactions when the graph is changed by adding or removing vertices, edges and properties.

  Default: `true`

## Using Gremlin

You can also use the Gremlin language with OrientDB.  To do so, initialize it, using `OGremlinHelper`:

```java
OGremlinHelper.global().create()
```

>For more information on Gremlin usage, see:
>
>- [How to use the Gremlin language with OrientDB](../Gremlin.md)
>- [Getting started with Gremlin](http://github.com/tinkerpop/gremlin/wiki/Getting-Started)
>- [Usage of Gremlin through HTTP/RESTful API using the Rexter project](https://github.com/tinkerpop/rexster/wiki/Using-Gremlin).


## Multi-Threaded Applications

In order to use the OrientDB Graph API with multi-threaded applications, you must use one `OrientGraph` instance per thread.

For more information about multi-threading look at [Java Multi Threading](Java-Multi-Threading.md). Bear in mind, graph components (such as, Vertices and Edges) are not thread-safe.  Sharing them between threads could cause unpredictable errors.

