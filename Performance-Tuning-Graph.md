# Tuning the Graph API
This guide is specific for the [TinkerPop Blueprints Graph Database](Graph-Database-Tinkerpop.md). Please be sure to read the generic guide to the [Performance-Tuning](Performance-Tuning.md).

## Connect to the database locally

Local connection is much faster than remote. So use "plocal" based on the storage engine used on database creation. If you need to connect to the database from the network you can use the ["Embed the server technique"](Embedded-Server.md).

## Avoid putting properties on edges
Even though supports properties on edges, this is much expensive because it creates a new record per edge. So if you need them you've to know that the database will be bigger and insertion time will be much longer.

## Set properties all together
It's much lighter to set properties in block than one by one. Look at this paragraph: [Graph-Database-Tinkerpop#setting-multiple-properties](Graph-Database-Tinkerpop.md#setting-multiple-properties).

## Set properties on vertex and edge creation
It's even faster if you set properties directly on creation of vertices and edges. Look at this paragraph: [Graph-Database-Tinkerpop#create-element-and-properties](Graph-Database-Tinkerpop.md#create-element-and-properties).

## Massive Insertion

See [Generic improvement on massive insertion](Performance-Tuning.md#massive_insertion). To access to the underlying database use:

    database.getRawGraph().declareIntent( new OIntentMassiveInsert() );

    // YOUR MASSIVE INSERTION

    database.getRawGraph().declareIntent( null );

## Avoid transactions if you can

Use the OrientGraphNoTx implementation that doesn't use transaction for basic operations like creation and deletion of vertices and edges. If you plan to son't use transactions change the [consistency level](Graph-Consistency.md). OrientGraphNoTx is not compatible with OrientBatchGraph so use it plain:

    OrientGraphNoTx graph = new OrientGraphNoTx("local:/tmp/mydb");

## Use the schema

Even if you can model your graph with only the entities (V)ertex and (E)dge it's much better to use schema for your types extending Vertex and Edge classes. In this way traversing will be faster and vertices and edges will be split on different files. For more information look at: [Graph Schema](Graph-Schema.md).

Example:

    OClass account = graph.createVertexType("Account");
    Vertex v = graph.addVertex("class:Account");

## Use indexes to lookup vertices by an ID

If you've your own ID on vertices and you need to lookup them to create edges then create an index against it:

    graph.createKeyIndex("id", Vertex.class, new Parameter("class", "Account"));

If the ID is unique then create an UNIQUE index that is much faster and lighter:

    graph.createKeyIndex("id", Vertex.class, new Parameter("type", "UNIQUE"), new Parameter("class", "Account"));

To lookup vertices by ID:

    for( Vertex v : graph.getVertices("Account.id", "23876JS2") ) {
      System.out.println("Found vertex: " + v );
    }

## Disable validation

Every time a graph element is modified, OrientDB executes a validation to assure the graph rules are all respected, that means:
- put edge in out/in collections
- put vertex in edges in/out

Now if you use the Graph API without bypassing graph element manipulation this could be turned off with a huge gain in performance:

    graph.setValidationEnabled(false);

## Reduce vertex objects

You can avoid the creation of a new ODocument for each new vertex by reusing it with ODocument.reset() method that clears the instance making it ready for a new insert operation. Bear in mind that you will need to assign the document with the proper class after resetting as it is done in the code below.

*NOTE: This trick works ONLY IN NON-TRANSACTIONAL contexts, because during transactions the documents could be kept in memory until commit.*

Example:
```java
db.declareIntent( new OIntentMassiveInsert() );

ODocument doc = db.createVertex("myVertex");
for( int i = 0; i < 1000000; ++i ){
  doc.reset();
  doc.setClassName("myVertex");
  doc.field("id", i);
  doc.field("name", "Jason");
  doc.save();
}

db.declareIntent( null );
```

## Cache management

Graph Database, by default, caches the most used elements. For massive insertion is strongly suggested to disable cache to avoid to keep all the element in memory. [Massive Insert Intent](Performance-Tuning.md#use_the_massive_insert_intent) automatically sets it to false.
```java
graph.setRetainObjects(false);
```
