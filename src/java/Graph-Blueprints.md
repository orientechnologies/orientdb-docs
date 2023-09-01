
# Using the Blueprints Extensions

OrientDB is a graph database that merges graph, document and object-oriented worlds together.  Below are some of the features exclusive to OrientDB through the Blueprints Extensions.

>For information on tuning your graph database, see [Performance Tuning Blueprints](../tuning/Performance-Tuning-Graph.md).

## Custom Types

OrientDB supports custom types for vertices and edges in an Object Oriented manner.  This feature is not supported directly through Blueprints, but there is a way to implement them.  If you want to create a schema to work with custom types, see [Graph Schema](Graph-Schema.md).

Additionally, OrientDB introduces a few variants to Blueprint methods for working with types.

### Creating Vertices and Edges in Specific Clusters

By default, each class has one cluster with the same name.  You can add multiple clusters to the class, allowing OrientDB to write vertices and edges on multiple files.

For instance,

```java
// SAVE THE VERTEX INTO THE CLUSTER 'PERSON_USA' 
// ASSIGNED TO THE NODE 'USA'
graph.addVertex("class:Person,cluster:Person_usa");
```

### Retrieving Vertices and Edges by Type

To retrieve all vertices of the `Person` class, use the special `getVerticesOfClass(String className)` method.

For instance,

```java
for (Vertex v : graph.getVerticesOfClass("Person")) {
    System.out.println(v.getProperty("name"));
}
```

Here, it retrieves all vertices of the class `Person` as well as all sub-classes.  It does this because OrientDB uses polymorphism by default.  If you would like to retrieve only those vertices of the `Person` class, excluding sub-types, use the `getVerticesOfClass(String className, boolean polymorphic)` method, specifying `false` in the `polymorphic` argument.  For instance,

```java
for (Vertex v : graph.getVerticesOfClass("Person", false)) {
    System.out.println(v.getProperty("name"));
}
```

You can also use variations on these with the `.getEdges()` method:

- `getEdgesOfClass(String className)`
- `getEdgesOfClass(String, className, boolean polymorphic)`

## Ordered Edges

By default, OrientDB uses a set to handle edge collection.  But, sometimes it's better to have an ordered list to access the edge by an offset.  

- For instance,

  ```java
  person.createEdgeProperty(Direction.OUT, "Photos").setOrdered(true);
  ```

- Whenever you access the edge collection, it orders the edges.  Consider the example below, which prints all photos in the database in an ordered way:

  ```java
  for (Edge e : loadedPerson.getEdges(Direction.OUT, "Photos")) {
    System.out.println( "Photo name: " + e.getVertex(Direction.IN).getProperty("name") );
  }
  ```

- To access the underlying edge list, you need to use the Document Database API.  Consider this example, which swaps the tenth photo with the last:

  ```java
  // REPLACE EDGE Photos
  List<ODocument> photos = loadedPerson.getRecord().field("out_Photos");
  photos.add(photos.remove(9));
  ```
- You can get the same result through SQL by executing the following commands in the terminal:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE PROPERTY out_Photos LINKLIST</code>
  orientdb> <code class="lang-sql userinput">ALTER PROPERTY User.out_Photos CUSTOM ORDERED=TRUE</code>
  </pre>
  
## Detached Elements

When working with web applications, it is very common to query elements and render them to the user, allowing them to apply changes.

Consider what happens when the user changes some fields and saves.  Previously, the developer had to track the changes in a separate structure, load the vertex or edge from the database, and then apply the changes to the element.  Beginning in version 1.7 OrientDB, there are two new methods in the Graph API on the `OrientElement` and `OrientBaseGraph` classes:

- `OrientElement.detach()` and `OrientBaseGraph.detach(OrientElement)` methods fetch all record content in memory and resets the connection to the Graph instance.
- `OrientElement.attach()` and `OrientBaseGraph.attach(OrientElement)` methods save the detached element back into the database and restores the connection between the Graph Element and the Graph instance.

For instance, to use these begin by loading a vertex and detaching it:

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

Update the element, either from the GUI or by application:

```java
v.setProperty("name", "super fast!");
```

When the user saves, re-attach the element and save it to the database:

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

**Do `detach()` methods work recursively to detach all connected elements?**
No, it only works on the current element.

**Can you add an edge against detached elements?**
No, you can only get, set or remove a property while it's detached.  Any other operation that requires the database it throws an `IllegalStateException` exception.

## Executing Commands

The OrientDB Blueprints implementation allows you to execute commands using SQL, JavaScript and all other supported languages.

### SQL Queries

It is possible to have parameters in a query using [prepared queries](Document-API-Documents.md#prepared-queries).

```java
for (Vertex v : (Iterable<Vertex>) graph.command(new OCommandSQL(
			"SELECT EXPAND( out('bought') ) FROM Customer WHERE name = 'Jay'")).execute()) {
    System.out.println("- Bought: " + v);
}
```

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

### SQL Commands

In addition to queries, you can also execute any SQL command, such as [`CREATE VERTEX`](../sql/SQL-Create-Vertex.md), [`UPDATE`](../sql/SQL-Update.md), or [`DELETE VERTEX`](../sql/SQL-Delete-Vertex.md).  For instance, consider a case where you want to set a new property called `local` to `true` on all the customers that live in Rome.

```java
int modified = graph.command(
          new OCommandSQL("UPDATE Customer SET local = true WHERE 'Rome' IN out('lives').name")).execute());
```

If the command modifies the schema, (such as in cases like [`CREATE CLASS`](../sql/SQL-Create-Class.md), [`ALTER CLASS`](../sql/SQL-Alter-Class.md), [`DROP CLASS`](../sql/SQL-Drop-Class.md), [`CREATE PROPERTY`](../sql/SQL-Create-Property.md), [`ALTER PROPERTY`](../sql/SQL-Alter-Property.md), and [`DROP PROPERTY`](../sql/SQL-Drop-Property.md), remember you need to force the schema update of the database instance you're using by calling the `.reload()` method.

```java
graph.getRawGraph().getMetadata().getSchema().reload();
```

>For more information, see [SQL Commands](../sql/SQL-Commands.md)

### SQL Batch

To execute multiple SQL commands in a batch, use the `OCommandScript` and SQL as the language.  This is recommended when creating edges on the server-side, to minimize the network roundtrip.

```java
String cmd = "BEGIN;";
cmd += "LET a = CREATE VERTEX SET script = true;";
cmd += "LET b = SELECT FROM V LIMIT 1;";
cmd += "LET e = CREATE EDGE FROM $a TO $b RETRY 100;";
cmd += "COMMIT;";
cmd += "return $e;";

OIdentifiable edge = graph.command(new OCommandScript("sql", cmd)).execute();
```

>For more information, see [SQL Batch](../sql/SQL-batch.md)

### Database Functions

To execute database functions, you must write it in JavaScript or any other supported languages.  For the examples, consider a function called `updateAllTheCustomersInCity(cityName)` that executes the same update as above.  Note the `'Rome'` attribute passed in the `execute()` method:

```java
graph.command(new OCommandFunction(
	"updateAllTheCustomersInCity")).execute("Rome"));
```

### Executing Code

To execute code on the server side, you can select between the supported language, (which by default is JavaScript):

```java
graph.command(
          new OCommandScript("javascript", "for(var i=0;i<10;++i){ print('\nHello World!'); }")).execute());
```

This prints the line "Hello World!" ten times in the server console, or in the local console, if the database has been opened in PLocal mode.

## Accessing the Graph

The TinkerPop Blueprints API is quite raw and doesn't provide ad hoc methods for very common use cases.  To get around this, you may need to access the `ODatabaseGraphTx` object to extend what you can do through the underlying graph engine.  Common operations are:
- Counting incoming and outgoing edges without browsing them.
- Getting incoming and outgoing vertices without browsing the edges.
- Executing a query using an SQL-like language integrated in the engine.

The [`OrientGraph`]({{ javadoc }}/com/tinkerpop/blueprints/impls/orient/OrientGraph.html) class provides the method `.getRawGraph()` to return the underlying Document database. For instance,

```java
final OrientGraph graph = new OrientGraph("plocal:C:/temp/graph/db");
try {
  OResultSet result = graph.getRawGraph().query("SELECT FROM V WHERE color = 'red'");
} finally {
  graph.shutdown();
}
```

### Security

If you want to use OrientDB security, use the construction that retrieves the Database URL, user and password.  For more information on OrientDB security, see [Security](../security/Security.md).  By default, it uses the `admin` user.
