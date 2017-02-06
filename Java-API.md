---
search:
    keywords: ['Java', 'Document API', 'Graph API', 'Object API']
---

# Java API

OrientDB is written completely in the Java language.  This means that you can use its Java API's without needing to install any additional drivers or adapters.

>For more information, see the [OrientDB Java Documentation](http://www.orientechnologies.com/javadoc/develop/)


## Component Architecture 

![image](http://www.orientdb.org/images/orientdb-api-stack.png)

OrientDB provides three different Java API's that allow you to work with OrientDB.

- [**Graph API**](#graph-api) Use this Java API if you work with graphs and want portable code across TinkerPop Blueprints implementations.  It is easiest to switch to this when migrating from other Graph Databases, such as Neo4J or Titan.  If you used TinkerPop standard on these, you can use OrientDB as a drop-in replacement.
- [**Document API**](#document-api) Use this Java API if your domain fits Document Database use case with schema-less structures.  It is easiest to switch to this when migrating from other Document Databases, such as MongoDB and CouchDB.
- [**Object API**](#object-api) Use this Java API if you need a full Object Oriented abstraction that binds all database entities to POJO (that is, Plain Old Java Objects).  It is easiest to switch to this when migrating from JPA applications.

Each Java API has its own pros and cons.  For more information on determining which Java API to use with your application, see [Choosing between the Graph or Document API](Choosing-between-Graph-or-Document-API.md).

|    | Graph | Document | Object |
|----|----|----|----|
|API|[Graph API](Graph-Database-Tinkerpop.md)|[Document API](Document-Database.md)|[Object Database](Object-Database.md)|
|Java class|<a href="https://github.com/orientechnologies/orientdb/blob/master/graphdb/src/main/java/com/tinkerpop/blueprints/impls/orient/OrientGraph.java">OrientGraph</a>|<a href="http://www.orientechnologies.com/javadoc/latest/index.html?com/orientechnologies/orient/core/db/document/ODatabaseDocumentTx.html">ODatabaseDocumentTx</a>|<a href="http://www.orientechnologies.com/javadoc/latest/index.html?com/orientechnologies/orient/object/db/OObjectDatabaseTx.html">OObjectDatabaseTx</a>|
|Query|Yes|Yes|Yes|
|Schema Less|Yes|Yes|Yes
|Schema full|Yes|Yes|Yes
|Speed<sup>`1`</sup>|90%|100%|50%|

><sup>`1`</sup>: Speed comparisons show for generic CRUD operations, such as queries, insertions, updates and deletions.  Large values are better, where 100% indicates the fastest possible.
>
>In general, the cost of high-level abstraction is a speed penalty, but remember that OrientDB is orders of magnitude faster than the class Relational Database.  So, using the Object Database provides a high-level of abstraction with much less code to develop and maintain.


### Document Graph API (Multi-Model)
(since v 3.0)

With this Java API, you can use OrientDB as a Document-Graph Database, allowing you to work with Vertices, Edges or simple Documents.  

API: [Muilti-Model, Document-Graph API](Java-MultiModel-API.md)

Query API: [Query API](Java-Query-API.md)


### Graph API (legacy)

With this Java API, you can use OrientDB as a Graph Database, allowing you to work with Vertices and Edges.  The Graph API is compliant with the [TinkerPop](http://www.tinkerpop.com) standard.

API: [Graph API](Graph-Database-Tinkerpop.md)

### Document API (legacy)

With this Java API, you can handle records and documents.  Documents are comprised of fields and fields can be any of the supported types.  You can use it with a schema, without, or in a mixed mode.

Additionally, it does not require a Java domain POJO, as is the case with Object Databases. 

API: [Document API](Document-Database.md)


### Object API

With this Java API, you can use OrientDB with JPA-like interfaces where POJO, (that is, Plain Old Java Objects), are automatically bound to the database as documents.  You can use this in schema-less or schema-full modes.

>Bear in mind that this Java API has not received improvements since OrientDB version 1.5.  Consider using the Document API or Graph API instead, with an additional layer to map to your POJO's.

While you can use both the Graph API and Document API at the same time, the Object API is only compatible with the Document API.  It doesn't work well with the Graph API.  The main reason is that it requires you to create POJO's that mimic the Vertex and Edge classes, which provides sub-optimal performance in comparison with using the Graph API directly.  For this reason, it is recommended that you don't use the Object API with a Graph domain.  To evaluate Object Mapping on top of OrientDB Blueprints Graph API, see [TinkerPop Frames](https://github.com/tinkerpop/frames/wiki), [Ferma](https://github.com/Syncleus/Ferma) and [Totorom](https://github.com/BrynCooke/totorom).

API: [Object Database](Object-Database.md)


## Supported Libraries

OrientDB ships with a number of JAR files in the `$ORIENTDB_HOME/lib` directory.

- **`orientdb-core-*.jar`** Provides the core library.
  - *Required*: Always.
  - *Dependencies*: `snappy-*.jar`  
  - *Performance Pack (Optional)*: 
	- `orientdb-nativeos-*.jar`
	- `jna-*.jar`
	- `jna-platform-*.jar`.
- **`orientdb-client-*.jar`** Provides the remote client.
  - *Required*: When your application connects with a remote server.
- **`orientdb-enterprise-*.jar`** Provides the base package with the protocol and network classes shared by the client and server. Deprecated since version 2.2.
  - *Required*: When your application connects to a remote server.
- **`orientdb-server-*.jar`** Provides the server component.
  - *Required*: When building an embedded server.  Used by the OrientDB Server.
- **`orientdb-tools-*.jar`** Provides the console and console commands.
  - *Required*: When you need to execute console commands directly through your application.  Used by the OrientDB Console.
- **`orientdb-object-*.jar`** Provides the Object Database interface.
  - *Required*: When you want to use this interface.
  - *Dependencies*: `javassist.jar` and `persistence-api-1.0.jar`.
- **`orientdb-graphdb-*.jar`** Provides the Graph Database interface.
  - *Required*: When you want to use this interface.
  - *Dependencies*: `blueprints-core-*.jar`.
- **`orientdb-distributed-*.jar`** Provides the distributed database plugin.
  - *Required*: When you want to use a server cluster.
  - *Dependencies*: `hazelcast-*.jar`.
