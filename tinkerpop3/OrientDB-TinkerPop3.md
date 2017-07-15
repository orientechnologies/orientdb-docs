---
search:
   keywords: ['Graph', 'Apache TinkerPop']
---

#OrientDB with Apache TinkerPop 3
**(since v 3.0)** 

OrientDB adheres to the [Apache TinkerPop](http://tinkerpop.apache.org) standard and implements TinkerPop Stack interfaces.

In version pior 3.0, OrientDB uses the [TinkerPop 2.x](https://github.com/tinkerpop/blueprints) implementation as the default for [Java Graph API](../java/Graph-Database-Tinkerpop.md).

Starting from version 3.0, OrientDB ships it's own 
APIs for handling Graphs ([Multi-Model API](../java/Java-MultiModel-API.md)). Those APIs are used to implement the TinkerPop 3 interfaces.

The OrientDB TinkerPop development happens [here](https://github.com/orientechnologies/orientdb-gremlin)


- [Installation](#installation)
- [Gremlin Console]()
- [Gremlin Server]()
- [Graph API]()



## Installation

Since TinkePop stack has been removed as dependency from OrientDB community, starting from version 3.0 it will be available for [download](http://orientdb.com/download) an Apache TinkerPop 3 enabled edition of OrientDB based on the Community Edition.

It contains all the feature of OrientDB Community plus the integration with the Tinkerpop stack:

- [Gremlin Console](#gremlin)
- [Gremlin Server](#gremlin-server)
- [Gremlin Driver](#gremlin-server)

### Source Code Installation

In addition to the binary packages, you can compile the OrientDB TinkerPop enabled distribution from the source code.
This process requires that you install [Git](http://www.git-scm.com/) and [Apache Maven](https://maven.apache.org/) on your system. 

```sh
$ git clone https://github.com/orientechnologies/orientdb-gremlin
$ cd orientdb-gremlin
$ git checkout develop
$ mvn clean install
```

It is possible to skip tests:

```sh
$ mvn clean install -DskipTests
```

This project follows the branching system of [OrientDB](../admin/installation/Installation-from-Source.md). 

The build process installs all jars in the local maven repository and creates archives under the `distribution` module inside the `target` directory. At the time of writing, building from branch `develop` gave: 

```sh
$ls -l distribution/target/
total 266640
drwxr-xr-x   2 staff  staff    68B Mar 21 13:07 archive-tmp/
drwxr-xr-x   3 staff  staff   102B Mar 21 13:07 dependency-maven-plugin-markers/
drwxr-xr-x  12 staff  staff   408B Mar 21 13:07 orientdb-community-3.0.0-SNAPSHOT/
drwxr-xr-x   3 staff  staff   102B Mar 21 13:07 orientdb-gremlin-community-3.0.0-SNAPSHOT.dir/
-rw-r--r--   1 staff  staff    65M Mar 21 13:08 orientdb-gremlin-community-3.0.0-SNAPSHOT.tar.gz
-rw-r--r--   1 staff  staff    65M Mar 21 13:08 orientdb-gremlin-community-3.0.0-SNAPSHOT.zip
$
```

The directory `orientdb-gremlin-community-3.0.0-SNAPSHOT.dir` contains the OrientDB Gremlin distribution uncompressed.

## Gremlin Console

The Gremlin Console is an interactive terminal or REPL that can be used to traverse graphs and interact with the data that they contain. For more information about it see the documentation [here](http://tinkerpop.apache.org/docs/current/reference/#gremlin-console)

To start the Gremlin console run **the gremlin.sh** (or gremlin.bat on Windows OS) script located in the **bin** directory of the OrientDB Gremlin Distribution

```
$ ./gremlin.sh 

         \,,,/
         (o o)
-----oOOo-(3)-oOOo-----
plugin activated: tinkerpop.orientdb
gremlin> 
```

Alternatively if you downloaded the Gremlin Console from the Apache Tinkerpop [Site](https://tinkerpop.apache.org/), just install the OrientDB Gremlin Plugin with

```
gremlin> :install com.orientechnologies orientdb-gremlin {version}
```

and then activate it

```
gremlin> :plugin use tinkerpop.orientdb
```

### Open the graph database

Before playing with [Gremlin](http://gremlindocs.com) you need a valid **[OrientGraph](Graph-Database-Tinkerpop.md#work_with_graphdb)** instance that points to an OrientDB database. To know all the database types look at [Storage types](../datamodeling/Concepts.md#database-url).

When you're working with a local or an in-memory database, if the database does not exist it's created for you automatically. Using the remote connection you need to create the database on the target server before using it. This is due to security restrictions.

Once created the **[OrientGraph](#orientdb-tinkerpop-graph-api)** instance with a proper URL is necessary to assign it to a variable. [Gremlin](https://tinkerpop.apache.org/gremlin.html) is written in Groovy, so it supports all the Groovy syntax, and both can be mixed to create very powerful scripts!

Example with a memory database (see below for more information about it):

```java
gremlin> graph = OrientGraph.open();
==>orientgraph[memory:orientdb-0.5772652169975153]
```

Some useful links:

- [The Graph](http://tinkerpop.apache.org/docs/current/reference/#graph)
- [All available steps](http://tinkerpop.apache.org/docs/current/reference/#traversal)

#### Working with in-memory database

In this mode the database is volatile and all the changes will be not persistent. Use this in a clustered configuration (the database life is assured by the cluster itself) or just for test.

```java
gremlin> graph = OrientGraph.open()
==>orientgraph[memory:orientdb-0.4274754723616194]
```

#### Working with local database

This is the most often used mode. The console opens and locks the database for exclusive use. This doesn't require starting an OrientDB server.

```java
gremlin> graph = OrientGraph.open("embedded:/tmp/gremlin/demo");
==>orientgraph[plocal:/tmp/gremlin/demo]
```


#### Working with a remote database

To open a database on a remote server be sure the server is up and running first. To start the server just launch **server.sh** (or server.bat on Windows OS) script. For more information look at [OrientDB Server](../internals/DB-Server.md)

```java
gremlin> graph = OrientGraph.open("remote:localhost/demodb");
==>orientgraph[remote:localhost/demodb]
```

#### Use security

OrientDB supports security by creating multiple users and roles associated with certain privileges. To know more look at [Security](Security.md). To open the graph database with a different user than the default, pass the user and password as additional parameters:

```java
gremlin> graph = OrientGraph.open("remote:localhost/demodb","reader","reader");
==>orientgraph[remote:localhost/demodb]
```

#### With Configuration

```
gremlin> config = new BaseConfiguration()
==>org.apache.commons.configuration.BaseConfiguration@2d38edfd
gremlin> config.setProperty("orient-url","remote:localhost/demodb")
==>null
gremlin> graph = OrientGraph.open(config)
==>orientgraph[remote:localhost/demodb]
```

Available configurations are :

- **orient-url**: Connection URL.
- **orient-user**: Database User.
- **orient-pass**: Database Password.
- **orient-transactional**: Transactional. Configuration. If true the `OrientGraph` instance will support transactions (Disabled by default).


### Mutating the Graph

#### Create a new Vertex

To create a new vertex, use the **addVertex()** method. The vertex will be created and a unique id will be displayed as the return value.

```java
graph.addVertex();
==>v[#5:0]
```

#### Create an edge

To create a new edge between two vertices, use the **v1.addEdge(label, v2)** method. The edge will be created with the label specified.

In the example below two vertices are created and assigned to a variable (Gremlin is based on Groovy), then an edge is created between them.

```java
gremlin>  v1 = graph.addVertex();
==>v[#10:0]

gremlin>  v2 = graph.addVertex();
==>v[#11:0]

gremlin> e = v1.addEdge('friend',v2)
==>e[#17:0][#10:0-friend->#11:0]
```

#### Close the database

To close a graph use the **close()** method:

```java
gremlin> graph.close()
==>null
```

This is not strictly necessary because OrientDB always closes the database when the Gremlin Console quits.

#### Transactions

OrientGraph supports Transactions. By default Tx are disabled. Use configuration to enable it.


```
gremlin> config = new BaseConfiguration()
==>org.apache.commons.configuration.BaseConfiguration@2d38edfd
gremlin> config.setProperty("orient-url","remote:localhost/demodb")
==>null
gremlin> config.setProperty("orient-transactional",true)
==>null
gremlin> graph = OrientGraph.open(config)
==>orientgraph[remote:localhost/demodb]
```

When using transactions OrientDB assigns a temporary identifier to each vertex and edge that is created.
use `graph.tx().commit()` to save them.

Transaction Example

```
gremlin> config = new BaseConfiguration()
==>org.apache.commons.configuration.BaseConfiguration@6b7d1df8
gremlin> config.setProperty("orient-url","remote:localhost/demodb")
==>null
gremlin> config.setProperty("orient-transactional",true)
==>null
gremlin> graph = OrientGraph.open(config)
==>orientgraph[remote:localhost/demodb]
gremlin> graph.tx().isOpen()
==>true
gremlin> v1 = graph.addVertex()
==>v[#-1:-2]
gremlin> v2 = graph.addVertex()
==>v[#-1:-3]
gremlin> e = v1.addEdge("friends",v2)
==>e[#-1:-4][#-1:-2-friends->#-1:-3]
gremlin> graph.tx().commit()
==>null
```

### Traversal

The power of Gremlin is in traversal. Once you have a graph loaded in your database you can traverse it in many different ways. For more info about traversal with Gremlin see [here](http://tinkerpop.apache.org/docs/current/reference/#traversal)

The entry point for traversal is a TraversalSource that can be easily obtained by an opened OrientGraph instance with:

```
gremlin> graph = OrientGraph.open()
==>orientgraph[memory:orientdb-0.41138060448051794]
gremlin> g = graph.traversal()
==>graphtraversalsource[orientgraph[memory:orientdb-0.41138060448051794], standard]
```

#### Retrieve a vertex

To retrieve a vertex by its ID, use the **V(id)** method passing the [RecordId](Concepts.md#recordid) as an argument (with or without the prefix '#'). This example retrieves the first vertex created in the above example.

```java
gremlin> g.V('#33:0')
==>v[#33:0]
```

#### Get all the vertices

To retrieve all the vertices in the opened graph use **.V()** (V in upper-case):

```java
gremlin> g.V()
==>v[#33:0]
==>v[#33:1]
==>v[#33:2]
==>v[#33:3]
```

#### Retrieve an edge

Retrieving an edge is very similar to retrieving a vertex.  Use the `E(id)` method passing the [RecordId](../datamodeling/Concepts.md#recordid) as an argument (with or without the prefix '#'). This example retrieves the first edge created in the previous example.

```java
gremlin> g.E('145:0')
==>e[#145:0][#121:0-IsFromCountry->#33:29]
```

#### Get all the edges

To retrieve all the edges in the opened graph use `.E()` (E in upper-case):

```java
gremlin> g.E()
==>e[#145:0][#121:0-IsFromCountry->#33:29]
==>e[#145:1][#121:1-IsFromCountry->#40:11]
==>e[#145:2][#121:2-IsFromCountry->#37:0]
```

#### Basic Traversal

To display all the outgoing edges of a vertex use `.outE(<label>)` .
 Label is optional and if passed the outgoing edges will be filtered by that label

Example:

```java
gremlin> g.V('#41:1').outE()
==>e[#221:6][#41:1-HasFriend->#42:1]
==>e[#222:6][#41:1-HasFriend->#43:1]
```

To display all the incoming edges of a vertex use `.inE(<label>)`. Example:

```java
gremlin> g.V('#41:1').inE()
==>e[#224:0][#41:0-HasFriend->#41:1]
==>e[#217:2][#42:0-HasFriend->#41:1]
==>e[#217:3][#43:0-HasFriend->#41:1]
==>e[#224:3][#44:0-HasFriend->#41:1]
==>e[#222:4][#45:0-HasFriend->#41:1]
==>e[#219:5][#46:0-HasFriend->#41:1]
==>e[#223:5][#47:0-HasFriend->#41:1]
==>e[#218:6][#48:0-HasFriend->#41:1]
==>e[#185:0][#121:0-HasProfile->#41:1]
```

For more information look at the [Gremlin Traversal](http://tinkerpop.apache.org/docs/current/reference/#traversal).

#### Filter results

This example returns all the outgoing edges of all the vertices with label equal to 'friend'.

```java
gremlin> g.V('#41:1').inE('HasProfile')
==>e[#185:0][#121:0-HasProfile->#41:1]
gremlin> 
```

#### Create complex paths

[Gremlin](https://tinkerpop.apache.org/gremlin.html) allows you to concatenate expressions to create more complex traversals in a single line:

```java
g.V().in().out()
```

Of course this could be much more complex. Below is an example with the graph taken from the official documentation:

```java
gremlin> g.V('44:0').out('HasFriend').out('HasFriend').values('Name').dedup()
==>Frank
==>Emanuele
==>Paolo
==>Colin
==>Andrey
==>Sergey
gremlin> 
```

## Gremlin Server


## OrientDB TinkerPop Graph API


In order to use the OrientDB TinkerPop Graph API implementation, you need to create an instance of the `OrientGraph` class. If the database already exists, the Graph API opens it. 

>**NOTE**: When creating a database through the Graph API, you can only create `PLocal` and `Memory` databases.  Remote databases must already exist.

>**NOTE**: In v. 2.2 and following releases, when using PLocal or Memory,please set MaxDirectMemorySize (JVM setting) to a high value, like 512g ``` -XX:MaxDirectMemorySize=512g ```

When building multi-threaded application, use one instance of `OrientGraph` per thread.  Bear in mind that all graph components, such as vertices and edges, are not thread safe.  So, sharing them between threads may result in unpredictable results.

Remember to always close the graph instance when you are done with it, using the `.close()` method. 


#### Working with in-memory database

```java
OrientGraph graph = OrientGraph.open();
try {
  ...
} finally {
  graph.close();
}
```


#### Working with local database

```java
OrientGraph graph = OrientGraph.open("embedded:/tmp/gremlin/demo");
try {
  ...
} finally {
  graph.close();
}
```


#### Working with remote database

```java
OrientGraph graph = OrientGraph.open("remote:localhost/demodb");
try {
  ...
} finally {
  graph.close();
}
```

#### Using the Graph Factory

The `OrientGraphFactory` act as a factory for `OrientGraph` instances
Using a Graph Factory in your application is relatively straightforward.  First, create and configure a factory instance using the `OrientGraphFactory` class.  Then, use the factory whenever you need to create an `OrientGraph` instance and shut it down to return it to the pool.  When you're done with the factory, close it to release all instances and free up system resources.

```java
OrientGraphFactory factory = new OrientGraphFactory("remote:localhost/demodb","admin","admin");
```

Then you can:

-  retrieve a transactional instance, use the getTx() method on your factory object: 

```java
OrientGraph txGraph = factory.getTx();
```

- retrieve a non-transactional instance, use the getNoTx() method on your factory object:

```
OrientGraph noTxGraph = factory.getNoTx();
```


#### Shutting Down Graph Instances

When you're done with a Graph Database instance, you can return it to the pool by calling the `close()` method on the instance.  This method does not close the instance.  The instance remains open and available for the next requester:
 
```java
graph.close();
```

#### Releasing the Graph Factory

When you're ready to release all instances, call the `close()` method on the factory.  In the case of pool usage, this also frees up the system resources claimed by the pool:

```java
factory.close();
```




