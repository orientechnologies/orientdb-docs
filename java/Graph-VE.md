---
search:
   keywords: ['Graph API', 'vertex', 'vertices', 'edge']
---

# Vertices and Edges

Similar to the Console interface, you can also create, manage and control vertices and edges through the Graph API.


## Vertices

To create a new vertex in the current Graph Database instance, call the [`Vertex OrientGraph.addVertex(Object id)`](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientBaseGraph.html#addVertex(java.lang.Object) method.  Note that this ignores the `id` parameter, given that the OrientDB implementation assigns a unique ID once it creates the vertex.  To return the unique ID, run the [`Vertex.getId()`](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientElement.html#getId() method on the object.

For instance,

```java
Vertex v = graph.addVertex(null);
System.out.println("Created vertex: " + v.getId());
```

### Retrieving Vertices

To retrieve all vertices on the object, use the `getVertices()` method.  For instance,

```java
for (Vertex v : graph.getVertices()) {
    System.out.println(v.getProperty("name"));
}
```

To lookup vertices by a key, call the `getVertices()` method by passing the field name and the value to match. Remember that in order to use indexes, you should use the "class" dot (.) "property name" as field name. Example:

```java
for( Vertex v : graph.getVertices("Account.id", "23876JS2") ) {
  System.out.println("Found vertex: " + v );
}
```

To know more about how to define indexes look at: [Using Graph Indexes](http://orientdb.com/docs/last/Performance-Tuning-Graph.html#use-indexes-to-lookup-vertices-by-an-id).

### Removing Vertices

To remove a vertex from the current Graph Database, call the [`OrientGraph.removeVertex(Vertex vertex)`](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientBaseGraph.html#removeVertex(Vertex) method.  This disconnects the vertex from the graph database and then removes it.  Disconnection deletes all vertex edges as well.

For instance,

```java
graph.removeVertex(luca);
```

Disconnects and removes the vertex `luca`.


## Edges

Edges link two vertices in the database.  The vertices must exist already.  To create a new edge in the current Graph Database, call the [`Edge OrientGraph.addEdge(Object id, Vertex outVertex, Vertex inVertex, String label )`](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientBaseGraph.html#addEdge(java.lang.Object,-Vertex,-Vertex,-java.lang.String) method.

Bear in mind that OrientDB ignores the `id` parameter, given that it assigns a unique ID when it creates the edge.  To access this ID, use the [`Edge.getId()`](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientElement.html#getId() method.  `outVertex` refers to the vertex instance where the edge starts and `inVertex` refers to where the edge ends.  `label` indicates the edge label.  Specify it as `null` if you don't want to assign a label.

For instance,

```java
Vertex luca = graph.addVertex(null);
luca.setProperty("name", "Luca");

Vertex marko = graph.addVertex(null);
marko.setProperty("name", "Marko");

Edge lucaKnowsMarko = graph.addEdge(null, luca, marko, "knows");
System.out.println("Created edge: " + lucaKnowsMarko.getId());
```

For more information on optimizing edge creation through concurrent threads and clients, see [Concurrency on Adding Edges](../Concurrency.md#concurrency-on-adding-edges).

### Retrieving Edges

To retrieve all edges use the [getEdges()](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientBaseGraph.html#getEdges() method:

```java
for (Edge e : graph.getEdges()) {
    System.out.println(e.getProperty("age"));
}
```

When using [Lightweight Edges](../Lightweight-Edges.md), OrientDB stores edges as links rather than records.  This improves performance, but as a consequence, the `.getEdges()` method only retrieves records of the class `E`.  When using Lightweight Edges, OrientDB only creates records in class `E` under certain circumstances, such as when the edge has properties.  Otherwise, the edges exist as links on the in and out vertices.

If you want to use `.getEdges()` to return all edges, disable the Lightweight Edges feature by executing the following command:

<pre>
orientdb> <code class="lang-sql userinput">ALTER DATABASE my_db useLightweightEdges=FALSE</code>
</pre>

You only need to run this command once to disable Lightweight Edges.  The change only takes effect on edges you create after running it.  For existing edges, you need to convert them from links to actual edges before the `.getEdges()` method returns all edges.  For more information, see [Troubleshooting](../Troubleshooting.md#why-cant-i-see-all-the-edges).

>**NOTE**: Since version 2.0 of OrientDB, the Lightweight Edges feature is disabled by default.


### Removing Edges

To remove an edge from the current Graph Database, call the [`OrientGraph.removeEdge(Edge edge)`](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientBaseGraph.html#removeEdge(Edge) method.  It removes the edge connecting two vertices.

For instance,

```java
graph.removeEdge(lucaKnowsMarko);
```

## Vertex and Edge Properties

Vertices and Edges can have multiple properties.  The key to this property is a String, the value any [Types](../Types.md) supported by OrientDB.

| Method | Description |
|---|---|
| [**`setProperty(String key, Object value)`**](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientElement.html#setProperty(java.lang.String,-java.lang.Object) | Sets the property.|
| [**`Object getProperty(String key)`**](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientElement.html#getProperty(java.lang.String) | Retrieves the property.|
| [**`void removeProperty(String key)`**](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientElement.html#removeProperty(java.lang.String) | Removes the property.|

For instance,

```java
vertex2.setProperty("x", 30.0f);
vertex2.setProperty("y", ((float) vertex1.getProperty( "y" )) / 2);

for (String property : vertex2.getPropertyKeys()) {
      System.out.println("Property: " + property + "=" + vertex2.getProperty(property));
}

vertex1.removeProperty("y");
```

### Setting Multiple Properties

The OrientDB implementation of the Blueprints extension supports setting multiple properties in one command against vertices and edges, using the [`setProperties(Object ...)`](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientElement.html#setProperties(java.lang.Object...) method.  This improves performance by allowing you to avoid saving the graph element each time you set a property.

For instance,

```java
vertex.setProperties( "name", "Jill", "age", 33, "city", "Rome", "born", "Victoria, TX" );
```

You can also pass a Map of values as the first argument.  In this case all map entries are set as element properties:

```java
Map<String,Object> props = new HashMap<String,Object>();
props.put("name", "Jill");
props.put("age", 33);
props.put("city", "Rome");
props.put("born", "Victoria, TX");
vertex.setProperties(props);
```

### Creating Element and Properties Together

In addition to the above methods, using the OrientDB Blueprint implementation, you can also set the initial properties while creating vertices or edges.

For instance,

- To create a vertex and set the initial properties:

  ```java
  graph.addVertex("class:Customer", "name", "Jill", 
	  "age", 33, "city", "Rome", "born", "Victoria, TX");
  ```

  This line creates a new vertex of the class `Customer`.  It sets the initial properties for `name`, `age`, `city`, and `born`.

- The same procedure also works for edges.

  ```java
  person1.addEdge("class:Friend", person1, person2, null, 
	  "since", "2013-07-30");
  ```

  This creates an edge of the class `Friend` between the vertices `person1` and `person2` with the property `since`.
  
Both methods accept `Map<String, Object>` as a parameter, allowing you to set one property per map entry, such as in the above example.

## Using Indices 

OrientDB allows query execution against any field of a vertex or edge, indexed or non-indexed.  To speed up queries, set up indices on key properties that use in the query.

-  For instance, say that you have a query that looks for all vertices with the name `OrientDB`.  For instance,

  ```java
  graph.getVertices("name", "OrientDB");
  ```

- Without an index against the property `name`, this query can take up a lot of time.  You can improve performance by creating a new index against the `name` property:

  ```java
  graph.createKeyIndex("name", Vertex.class);
  ```

- In cases where the name must be unique, you can enforce this constraint by setting the index as `UNIQUE`.  (This feature is only available in OrientDB).

  ```java
  graph.createKeyIndex("name", Vertex.class, new Parameter("type", "UNIQUE"));
  ```

   It applies this constraint to vertices and sub-type instances.

-  To create an index against a custom type, such as the `Customer` vertex, use the additional `class` parameter:

  ```java
  graph.createKeyIndex("name", Vertex.class, new Parameter("class", "Customer"));
  ```

- You can also have both unique indices against custom types:

  ```java
  graph.createKeyIndex("name", Vertex.class, new Parameter("type", "UNIQUE"), new Parameter("class", "Customer"));
  ```
- To create a case-insensitive index, use the `collate` parameter:

  ```java
  graph.createKeyIndex("name", Vertex.class, new Parameter("type", "UNIQUE"), new Parameter("class", "Customer"),new Parameter("collate", "ci"));
  ```
  
- To get a vertex or edge by key prefix, use the class name before the property.  For example above, you would use `Customer.name` instead of just `name` to create the index against the field of that class:

  ```java
  for (Vertex v : graph.getVertices("Customer.name", "Jay")) {
      System.out.println("Found vertex: " + v);
  }
  ```

- In the event that the class name is not passed, it uses `V` for vertices and `E` for edges:

  ```java
  graph.getVertices("name", "Jay");
  graph.getEdges("age", 20);
  ```

>For more information, see [Indexes](../indexing/Indexes.md).


