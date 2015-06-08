# Gremlin API

[Gremlin](http://gremlindocs.com) is a language specialized to work with [Property Graphs](https://github.com/tinkerpop/gremlin/wiki/Defining-a-Property-Graph). [Gremlin](http://gremlindocs.com) is part of [TinkerPop](http://www.tinkerpop.com) Open Source products. For more information:
- [Gremlin Documentation](http://gremlindocs.com)
- [Gremlin WiKi](https://github.com/tinkerpop/gremlin/wiki)
- [OrientDB adapter to use it inside Gremlin](https://github.com/tinkerpop/blueprints/wiki/OrientDB-Implementation)
- [OrientDB implementation of TinkerPop Blueprints](Graph-Database-Tinkerpop.md)

To know more about [Gremlin](http://gremlindocs.com) and [TinkerPop](http://www.tinkerpop.com)'s products subscribe to the [Gremlin Group](http://groups.google.com/forum/#!forum/gremlin-users).

# Get Started

Launch the **gremlin.sh** (or gremlin.bat on Windows OS) console script located in the **bin** directory:
```java
> gremlin.bat

         \,,,/
         (o o)
-----oOOo-(_)-oOOo-----
```

# Open the graph database

Before playing with [Gremlin](http://gremlindocs.com) you need a valid **[OrientGraph](Graph-Database-Tinkerpop.md#work_with_graphdb)** instance that points to an OrientDB database. To know all the database types look at [Storage types](Concepts.md#storage).

When you're working with a local or an in-memory database, if the database does not exist it's created for you automatically. Using the remote connection you need to create the database on the target server before using it. This is due to security restrictions.

Once created the **[OrientGraph](Graph-Database-Tinkerpop.md#work_with_graphdb)** instance with a proper URL is necessary to assign it to a variable. [Gremlin](http://gremlindocs.com) is written in Groovy, so it supports all the Groovy syntax, and both can be mixed to create very powerful scripts!

Example with a local database (see below for more information about it):
```java
gremlin> g = new OrientGraph("plocal:/home/gremlin/db/demo");
==>orientgraph[plocal:/home/gremlin/db/demo]
```

Some useful links:
- [All Gremlin methods](https://github.com/tinkerpop/gremlin/wiki/Gremlin-Methods)
- [All available steps](https://github.com/tinkerpop/gremlin/wiki/Gremlin-Steps)

## Working with local database

This is the most often used mode. The console opens and locks the database for exclusive use. This doesn't require starting an OrientDB server.
```java
gremlin> g = new OrientGraph("plocal:/home/gremlin/db/demo");
==>orientgraph[plocal:/home/gremlin/db/demo]
```

## Working with a remote database

To open a database on a remote server be sure the server is up and running first. To start the server just launch **server.sh** (or server.bat on Windows OS) script. For more information look at [OrientDB Server](DB-Server.md)
```java
gremlin> g = new OrientGraph("remote:localhost/demo");
==>orientgraph[remote:localhost/demo]
```

## Working with in-memory database

In this mode the database is volatile and all the changes will be not persistent. Use this in a clustered configuration (the database life is assured by the cluster itself) or just for test.
```java
gremlin> g = new OrientGraph("memory:demo");
==>orientgraph[memory:demo]
```

## Use security

OrientDB supports security by creating multiple users and roles associated with certain privileges. To know more look at [Security](Security.md). To open the graph database with a different user than the default, pass the user and password as additional parameters:

```java
gremlin> g = new OrientGraph("memory:demo", "reader", "reader");
==>orientgraph[memory:demo]
```

# Create a new Vertex

To create a new vertex, use the **addVertex()** method. The vertex will be created and a unique id will be displayed as the return value.
```java
g.addVertex();
==>v[#5:0]
```

# Create an edge

To create a new edge between two vertices, use the **addEdge(v1, v2, label)** method. The edge will be created with the label specified.

In the example below two vertices are created and assigned to a variable (Gremlin is based on Groovy), then an edge is created between them.
```java
gremlin> v1 = g.addVertex();
==>v[#5:0]

gremlin> v2 = g.addVertex();
==>v[#5:1]

gremlin> e = g.addEdge(v1, v2, 'friend');
==>e[#6:0][#5:0-friend->#5:1]
```

# Save changes
OrientDB assigns a temporary identifier to each vertex and edge that is created. To save them to the database stopTransaction(SUCCESS) should be called
```groovy
gremlin> g.stopTransaction(SUCCESS)
```

# Retrieve a vertex

To retrieve a vertex by its ID, use the **v(id)** method passing the [RecordId](Concepts.md#recordid) as an argument (with or without the prefix '#'). This example retrieves the first vertex created in the above example.
```java
gremlin> g.v('5:0')
==>v[#5:0]
```

## Get all the vertices

To retrieve all the vertices in the opened graph use **.V** (V in upper-case):
```java
gremlin> g.V
==>v[#5:0]
==>v[#5:1]
```

# Retrieve an edge

Retrieving an edge is very similar to retrieving a vertex.  Use the *e(id)* method passing the [RecordId](Concepts.md#recordid) as an argument (with or without the prefix '#'). This example retrieves the first edge created in the previous example.
```java
gremlin> g.e('6:0')
==>e[#6:0][#5:0-friend->#5:1]
```

## Get all the edges

To retrieve all the edges in the opened graph use **.E** (E in upper-case):
```java
gremlin> g.E
==>e[#6:0][#5:0-friend->#5:1]
```


# Traversal

The power of Gremlin is in traversal. Once you have a graph loaded in your database you can traverse it in many different ways.

## Basic Traversal

To display all the outgoing edges of the first vertex just created append the **.outE** at the vertex. Example:
```java
gremlin> v1.outE
==>e[#6:0][#5:0-friend->#5:1]
```

To display all the incoming edges of the second vertex created in the previous examples append the **.inE** at the vertex. Example:
```java
gremlin> v2.inE
==>e[#6:0][#5:0-friend->#5:1]
```

In this case the edge is the same because it's the outgoing edge of 5:0 and the incoming edge of 5:1.

For more information look at the [Basic Traversal with Gremlin](https://github.com/tinkerpop/gremlin/wiki/Basic-Graph-Traversals).

## Filter results

This example returns all the outgoing edges of all the vertices with label equal to 'friend'.
```java
gremlin> g.V.outE('friend')
==>e[#6:0][#5:0-friend->#5:1]
```

# Close the database

To close a graph use the **shutdown()** method:
```java
gremlin> g.shutdown()
==>null
```
This is not strictly necessary because OrientDB always closes the database when the [Gremlin](http://gremlindocs.com) console quits.

# Create complex paths

[Gremlin](http://gremlindocs.com) allows you to concatenate expressions to create more complex traversals in a single line:
```java
v1.outE.inV
```

Of course this could be much more complex. Below is an example with the graph taken from the official documentation:
```java
g = new OrientGraph('memory:test')

// calculate basic collaborative filtering for vertex 1
m = [:]
g.v(1).out('likes').in('likes').out('likes').groupCount(m)
m.sort{a,b -> a.value <=> b.value}

// calculate the primary eigenvector (eigenvector centrality) of a graph
m = [:]; c = 0;
g.V.out.groupCount(m).loop(2){c++ < 1000}
m.sort{a,b -> a.value <=> b.value}
```

# Passing input parameters

Some [Gremlin](http://gremlindocs.com) expressions require declaration of input parameters to be
run. This is the case, for example, of bound variables, as described
in [JSR223 Gremlin Script Engine](https://github.com/tinkerpop/gremlin/wiki/Using-Gremlin-through-Java). OrientDB has enabled a mechanism to
pass variables to a [Gremlin](http://gremlindocs.com) pipeline declared in a command as
described below:

```java
Map<String, Object> params = new HashMap<String, Object>();
params.put("map1", new HashMap());
params.put("map2", new HashMap());
db.command(new OCommandSQL("select gremlin('
current.as('id').outE.label.groupCount(map1).optional('id').sideEffect{map2=it.map();map2+=map1;}
')")).execute(params);
```
## GremlinPipeline

You can also use native Java GremlinPipeline like:

```java
new GremlinPipeline(g.getVertex(1)).out("knows").property("name").filter(new PipeFunction<String,Boolean>() {
  public Boolean compute(String argument) {
    return argument.startsWith("j");
  }
}).back(2).out("created");
```

For more information: [Using Gremlin through Java](https://github.com/tinkerpop/gremlin/wiki/Using-Gremlin-through-Java)

# Declaring output

In the simplest case, the output of the last step (https://github.com/tinkerpop/gremlin/wiki/Gremlin-Steps) in the Gremlin pipeline corresponds to the output of the overall Gremlin expression. However, it is possible to instruct the Gremlin engine to consider any of the input variables as output. This can be declared as:

```java
Map<String, Object> params = new HashMap<String, Object>();
params.put("map1", new HashMap());
params.put("map2", new HashMap());
params.put("output", "map2");
db.command(new OCommandSQL("select gremlin('
current.as('id').outE.label.groupCount(map1).optional('id').sideEffect{map2=it.map();map2+=map1;}
')")).execute(params);
```
There are more possibilities to define the output in the [Gremlin](http://gremlindocs.com) pipelines.  So this mechanism is expected to be extended in the future. Please, contact OrientDB mailing list to discuss customized outputs.

# Conclusions

Now you've learned how to use [Gremlin](http://gremlindocs.com) on top of OrientDB.  The best place to go in depth with this powerful language is the [Gremlin WiKi](https://github.com/tinkerpop/gremlin/wiki).
