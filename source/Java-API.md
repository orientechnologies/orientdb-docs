# Java API

OrientDB is written 100% in Java. You can use the native Java APIs without any driver or adapter. [Here the Javadocs](http://www.orientechnologies.com/javadoc/latest/).

## Architecture of components

![image](http://www.orientdb.org/images/orientdb-api-stack.png)

OrientDB provides 3 different Java APIs to work with OrientDB. Each one has pros and cons.

Which API to choose between Graph and Document? Look also at [Graph-or-Document-API?](Choosing-between-Graph-or-Document-API.md).

### Graph API

Use OrientDB as a Graph Database working with Vertices and Edges. Graph API is 100% compliant with <a href="http://www.tinkerpop.com">TinkerPop</a> standard.

API: [Graph API](Graph-Database-Tinkerpop.md)

### Document API

Handles records as documents. Documents are comprised of fields. Fields can be any of the types supported. Does not need a Java domain POJO, as required for the Object Database. Can be used as schema-less or schema-base modes.

API: [Document API](Document-Database.md)

### Object API

It's the JPA like interface where POJO are automatically bound to the database as documents. Can be used in schema-less or schema-based modes. This API hasn't been improved since OrientDB 1.5. Please consider using Document or Graph API by writing an additional layer of mapping with your POJO.

API: [Object Database](Object-Database.md)


## What to use? Feature Matrix

|    | Graph | Document | Object |
|----|----|----|----|
|API|[Graph API](Graph-Database-Tinkerpop.md)|[Document API](Document-Database.md)|[Object Database](Object-Database.md)|
|Use this if|You work with **graphs** and want your code to be **portable** across **TinkerPop Blueprints** implementations|Your domain fits better the Document Database use case with **schema-less structures**|If you need a full **Object Oriented** abstraction that binds all the database entities to **POJO** (Plain Old Java Object)|
|Easy to switch from|Other GraphDBs like Neo4J or Titan. If you used TinkerPop standard OrientDB is a drop-in replacement|Other DocumentDB like MongoDB and CouchDB|JPA applications|
|Java class|<a href="https://github.com/orientechnologies/orientdb/blob/master/graphdb/src/main/java/com/tinkerpop/blueprints/impls/orient/OrientGraph.java">OrientGraph</a>|<a href="http://www.orientechnologies.com/javadoc/latest/index.html?com/orientechnologies/orient/core/db/document/ODatabaseDocumentTx.html">ODatabaseDocumentTx</a>|<a href="http://www.orientechnologies.com/javadoc/latest/index.html?com/orientechnologies/orient/object/db/OObjectDatabaseTx.html">OObjectDatabaseTx</a>|
|Query|Yes|Yes|Yes|
|Schema Less|Yes|Yes|Yes
|Schema full|Yes|Yes|Yes
|Speed<code>*</code>|90%|100%|50%|

<code>*</code> Speed comparison for generic CRUD operations such as query, insertion, update and deletion. Larger is better. 100% is fastest. In general the price of a high level of abstraction is a speed penalty, but remember that Orient is orders of magnitude faster than the classic RDBMS. So using the Object Database gives you a high level of abstraction with much less code to develop and maintain.

## Which library do I use?

OrientDB comes with some jar files contained in the lib directory

|JAR name|Description|When required|Depends on 3rd party jars|
|-----|-----|------|------|
|`orientdb-core-*.jar`|Core library|Always|`snappy-*.jar` as optional, performance pack: `orientdb-nativeos-*.jar`, `jna-*.jar` and `jna-platform-*.jar`|
|`orientdb-client-*.jar`|Remote client|When your application talks with a remote server|
|`orientdb-enterprise-*.jar`|Base package with the protocol and network classes shared by client and server|When your application talks with a remote server|
|`orientdb-server-*.jar`|Server component|It's used by the server component. Include it only if you're embedding a server|
|`orientdb-tools-*.jar`|Contain the console and console commands|Never, unless you want to execute console command directly by your application. Used by the console application|
|`orientdb-object-*.jar`|Contain the Object Database interface|Include it if you're using this interface|`javassist.jar`, `persistence-api-1.0.jar`|
|`orientdb-graphdb-*.jar`|Contain the GraphDB interface|Include it if you're using this interface|`blueprints-core-*.jar`|
|`orientdb-distributed-*.jar`|Contain the distributed plugin|Include it if you're working with a server cluster|`hazelcast-*.jar`|