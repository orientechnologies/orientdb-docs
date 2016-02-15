# Import from Neo4j

Neo4j is an open-source graph database that queries and manipulates data using its own Cypher Query Language and can export in GraphML, an XML-based file format for graphs.  Given that OrientDB can read GraphML, it is relatively straightforward to import data from Neo4j into OrientDB.  You can manage the imports using the Console or the Java API.

>Neo4j is a registered trademark of Neo Technology, Inc.  For more information on the differences between Neo4j and OrientDB, see [OrientDB vs. Neo4j]((http://www.orientechnologies.com/orientdb-vs-neo4j/).



## Exporting GraphML

In order to export data from Neo4j into GraphML, you need to install the [Neo4j Shell Tools](https://github.com/jexp/neo4j-shell-tools) plugin.  Once you have this package installed, you can use the `export-graphml` utility to export the database.

1. Change into the Neo4j home directory:

   <pre>
   $ <code class="lang-sql userinput">cd /path/to/neo4j-community-2.3.2</code>
   </pre>
   
1. Download the Neo4j Shell Tools:

   <pre>
   $ <code class="lang-sh userinput">curl http://dist.neo4j.org/jexp/shell/neo4j-shell-tools_2.3.2.zip \
         -o neo4j-shell-tools.zip</code>
   </pre>
   
1. Unzip the `neo4j-shell-tools.zip` file into the `lib` directory:

   <pre>
   $ <code class="lang-sh userinput">unzip neo4j-shell-tools.zip -d lib</code>
   </pre>
   
1. Restart the Neo4j Server.  In the event that it's not running, `start` it:

   <pre>
   $ <code class="lang-sh userinput">./bin/neo4j restart</code>
   </pre>
   
1. Once you have Neo4j restarted with the Neo4j Shell Tools, launch the [Neo4j Shell](http://docs.neo4j.org/chunked/stable/shell.html) tool, located in the `bin/` directory:

   <pre>
   $ <code class="lang-sh userinput">./bin/neo4j-shell</code>
   Welcome to the Neo4j Shell! Enter 'help' for a list of commands
   NOTE: Remote Neo4j graph database service 'shell' at port 1337

   neo4j-sh (0)$
   </pre>

1. Export the database into GraphML:

   <pre>
   neo4j-sh (0)$ <code class="lang-sh userinput">export-graphml -t -o /tmp/out.graphml</code>
   Wrote to GraphML-file /tmp/out.graphml 0. 100%: nodes = 302 rels = 834
   properties = 4221 time 59 sec total 59 sec
   </pre>
   
This exports the database to the path `/tmp/out.graphml`.




## Importing GraphML

There are three methods available in importing the GraphML file into OrientDB: through the Console, through Gremlin or through the Java API.

### Importing through the OrientDB Console

For more recent versions of OrientDB, you can import data from GraphML through the OrientDB Console.  If you have version 2.0 or greater, this is the recommended method given that it can automatically translate the Neo4j labels into classes.

1. Log into the OrientDB Console.

   <pre>
   $ <code class="lang-sh userinput">$ORIENTDB_HOME/bin/console.sh</code>
   </pre>
   
1. In OrientDB, create a database to receive the import:

   <pre>
   orientdb> <code class="lang-sql userinput">CREATE DATABASE PLOCAL:/tmp/db/test</code>
   Creating database [plocal:/tmp/db/test] using the storage type [plocal]...
   Database created successfully.

   Current database is: plocal:/tmp/db/test
   </pre>

1. Import the data from the GraphML file:

   <pre>
   orientdb {db=test}> <code class="lang-sql userinput">IMPORT DATABASE /tmp/out.graphml</code>
   
   Importing GRAPHML database database from /tmp/out.graphml...
   Transaction 8 has been committed in 12ms
   </pre>

This imports the Neo4j database into OrientDB on the `test` database.



### Importing through the Gremlin Console

For older versions of OrientDB, you can import data from GraphML through the Gremlin Console.  If you have a version 1.7 or earlier, this is the method to use.  It is not recommended on more recent versions, given that it doesn't consider labels declared in Neo4j.  In this case, everything imports as the base vertex and edge classes, (that is, `V` and `E`).  This means that, after importing through Gremlin you need to refactor you graph elements to fit a more structured schema.

To import the GraphML file into OrientDB, complete the following steps:

1. Launch the Gremlin Console:

   <pre>
   $ <code class="lang-sh userinput">$ORIENTDB_HOME/bin/gremlin.sh</code>
   
            \,,,/
            (o o)
   -----oOOo-(_)-oOOo-----
   </pre>

1. From the Gremlin Console, create a new graph, specifying the path to your Graph database, (here `/tmp/db/test`):

   <pre>
   gremlin> <code class="lang-js userinput">g = new OrientGraph("plocal:/tmp/db/test");</code>
   ==>orientgraph[plocal:/db/test]
   </pre>
   
1. Load the GraphML file into the graph object (that is, `g`):

   <pre>
   gremlin> <code class="lang-js userinput">g.loadGraphML("/tmp/out.graphml");</code>
   ==>null
   </pre>
   
1. Exit the Gremlin Console:

   <pre>
   gremlin> <code class="lang-js userinput">quit</code>
   </pre>

This imports the GraphML file into your OrientDB database.



### Importing through the Java API

OrientDB Console calls the Java API.  Using the Java API directly allows you greater control over the import process.  For instance,

```java
new OGraphMLReader(new OrientGraph("plocal:/temp/bettergraph")).inputGraph("/temp/neo4j.graphml");
```

This line imports the GraphML file into OrientDB.


#### Defining Custom Strategies

Beginning in version 2.1, OrientDB allows you to modify the import process through custom strategies for vertex and edge attributes.  It supports the following strategies:

- `com.orientechnologies.orient.graph.graphml.OIgnoreGraphMLImportStrategy` 
Defines attributes to ignore.
- `com.orientechnologies.orient.graph.graphml.ORenameGraphMLImportStrategy` Defines attributes to rename.

**Exammples**

- Ignore the vertex attribute `type`:

  ```java
  new OGraphMLReader(new OrientGraph("plocal:/temp/bettergraph")).defineVertexAttributeStrategy("__type__", new OIgnoreGraphMLImportStrategy()).inputGraph("/temp/neo4j.graphml");
  ```

- Ignore the edge attribute `weight`:

  ```java
  new OGraphMLReader(new OrientGraph("plocal:/temp/bettergraph")).defineEdgeAttributeStrategy("weight", new OIgnoreGraphMLImportStrategy()).inputGraph("/temp/neo4j.graphml");
  ```
  
- Rename the vertex attribute `type` in just `type`:

  ```java
  new OGraphMLReader(new OrientGraph("plocal:/temp/bettergraph")).defineVertexAttributeStrategy("__type__", new ORenameGraphMLImportStrategy("type")).inputGraph("/temp/neo4j.graphml");
  ```



## Import Tips and Tricks

### Dealing with Memory Issues

In the event that you experience memory issues while attempting to import from Neo4j, you might consider reducing the batch size.  By default, the batch size is set to `1000`.  Smaller value causes OrientDB to process the import in smaller units.

- Import with adjusted batch size through the Console:

  <pre>
  orientdb {db=test}> <code class="lang-sql userinput">IMPORT DATABASE /tmp/out.graphml batchSize=100</code>
  </pre>

- Import with adjusted batch size through the Java API:

  ```java
  new OGraphMLReader(new OrientGraph("plocal:/temp/bettergraph")).setBatchSize(100).inputGraph("/temp/neo4j.graphml");
  ```

### Storing the Vertex ID's

By default, OrientDB updates the import to use its own ID's for vertices.  If you want to preserve the original vertex ID's from Neo4j, use the `storeVertexIds` option.

- Import with the original vertex ID's through the Console:

  <pre>
  orientdb {db=test}> <code class="lang-sql userinput">IMPORT DATABASE /tmp/out.graphml storeVertexIds=true</code>
  </pre>
  
- Import with the original vertex ID's through the Java API:

  ```java
  new OGraphMLReader(new OrientGraph("plocal:/temp/bettergraph")).setStoreVertexIds(true).inputGraph("/temp/neo4j.graphml");
  ```

