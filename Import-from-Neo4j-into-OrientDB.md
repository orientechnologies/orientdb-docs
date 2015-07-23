# Import from Neo4j

This guide explains how to export a graph from Neo4j* and import it into OrientDB in 3 easy steps. If you want to know more about the differences between OrientDB and Neo4j, take a look at [OrientDB vs Neo4j](http://www.orientechnologies.com/orientdb-vs-neo4j/).

## 1) Download Neo4j Shell Tools plugin
In order to export the database in GraphML format, you need the additional [neo4j-shell-tools](https://github.com/jexp/neo4j-shell-tools) plugin:
- [Download it from the Neo4j web site](https://github.com/jexp/neo4j-shell-tools)
- Extract the ZIP content inside Neo4j `lib` folder

## 2) Export the Neo4j database to a file
Now launch the [Neo4j-Shell](http://docs.neo4j.org/chunked/stable/shell.html) tool located in the `bin` directory and execute the following command:

```
export-graphml -t -o /tmp/out.graphml
```

Where `/tmp/out.graphml` is the location to save the file in GraphML format.

Example:

```
$ bin/neo4j-shell
Welcome to the Neo4j Shell! Enter 'help' for a list of commands
NOTE: Remote Neo4j graph database service 'shell' at port 1337

neo4j-sh (0)$ export-graphml -t -o /tmp/out.graphml
Wrote to GraphML-file /tmp/out.graphml 0. 100%: nodes = 302 rels = 834 properties = 4221 time 59 sec total 59 sec
```

## 3) Import the database into OrientDB
The third and last step can be done in 3 ways, based on the OrientDB version you are using.

### 3a) Using the console with OrientDB 2.0.x or further
If you have OrientDB 2.0, this is the suggested method because it's easier and is able to import Neo4j labels as OrientDB classes automatically.

```
$ cd $ORIENTDB_HOME/bin
$ ./console.sh
orientdb> CREATE DATABASE plocal:/tmp/db/test
creating database [plocal:/tmp/db/test] using the storage type [plocal]...
Database created successfully.

Current database is: plocal:/tmp/db/test

orientdb {db=test}> IMPORT DATABASE /tmp/out.graphml

Importing GRAPHML database database from /tmp/out.graphml...
Transaction 8 has been committed in 12ms
```

### 3b) Using the console with OrientDB 1.7 or previous
This method uses the standard Gremlin importer, but doesn't take in consideration any label declared in Neo4j, so everything is imported as V (base Vertex class) and E (base Edge class). After importing you could need to refactor your graph element to fit in a more structured schema.

To import the GraphML file into OrientDB complete the following steps:
- execute the Gremlin console located in `$ORIENTDB_HOME/bin`
- create a new graph with the command `g = new OrientGraph("plocal:/tmp/db/test");` specifying the path of your new OrientDB Graph Database, `/tmp/db/test` in this case
- execute the command `g.loadGraphML('/tmp/out.graphml');` where `/tmp/out.graphml` is the path of the exported file

Example:

```
$ cd $ORIENTDB_HOME/bin
$ ./gremlin.sh

         \,,,/
         (o o)
-----oOOo-(_)-oOOo-----
gremlin> g = new OrientGraph("plocal:/tmp/db/test");
==>orientgraph[plocal:/db/test]
gremlin> g.loadGraphML('/tmp/out.graphml');
==>null
gremlin> quit
```

### 3c) Using Java API
Java API are called by console. Using Java API directly allows you more control on the importing process. 

Example of simple importing:
```java
new OGraphMLReader(new OrientGraph("plocal:/temp/bettergraph")).inputGraph("/temp/neo4j.graphml");
```

#### Define custom strategies
Starting from OrientDB 2.1 you can customize the importing process by specifying custom strategies for vertex and edge attributes. The suppoted strategies are:
- `com.orientechnologies.orient.graph.graphml.OIgnoreGraphMLImportStrategy` to ignore an attribute and
- `com.orientechnologies.orient.graph.graphml.ORenameGraphMLImportStrategy` to rename an attribute

Example to ignore the vertex attribute `type`:

```java
new OGraphMLReader(new OrientGraph("plocal:/temp/bettergraph")).defineVertexAttributeStrategy("__type__", new OIgnoreGraphMLImportStrategy()).inputGraph("/temp/neo4j.graphml");
```

Example to ignore the edge attribute `weight`:

```java
new OGraphMLReader(new OrientGraph("plocal:/temp/bettergraph")).defineEdgeAttributeStrategy("weight", new OIgnoreGraphMLImportStrategy()).inputGraph("/temp/neo4j.graphml");
```
Example on renaming the vertex attribute `type` in just `type`:

```java
new OGraphMLReader(new OrientGraph("plocal:/temp/bettergraph")).defineVertexAttributeStrategy("__type__", new ORenameGraphMLImportStrategy("type")).inputGraph("/temp/neo4j.graphml");
```
----
Congratulations! The database has been imported into OrientDB.

### Tricks and Tips
#### Memory problems
If you experiment out of memory problems, try to reduce the batchSize (default is 1000), by setting the `batchSize` property. Example from console:

```
orientdb {db=test}> IMPORT DATABASE /tmp/out.graphml batchSize=100
```

Example from Java API:

```java
new OGraphMLReader(new OrientGraph("plocal:/temp/bettergraph")).setBatchSize(100).inputGraph("/temp/neo4j.graphml");
```

#### Store the vertices ids
By deault OrientDB uses own IDs for vertices. If you want to save the original ids for vertices, use the option `storeVertexIds=true`. Example from console:

```
orientdb {db=test}> IMPORT DATABASE /tmp/out.graphml storeVertexIds=true
```
Example from Java API:

```java
new OGraphMLReader(new OrientGraph("plocal:/temp/bettergraph")).setStoreVertexIds(true).inputGraph("/temp/neo4j.graphml");
```

-----
*Neo4j is a registered trademark of Neo Technology Inc.
