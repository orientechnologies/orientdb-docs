# Graph Schema

Although OrientDB can work in schema-less mode, sometimes you need to enforce your data model using a schema. OrientDB supports schema-full or schema-hybrid solutions where the second one means to set such constraints only for certain fields and leave the user to add custom fields to the records. This mode is at class level, so you can have the "Employee" class as schema-full and "EmployeeInformation" class as schema-less.

- **Schema-Full**: enable the strict-mode at class level and set all the fields as mandatory
- **Schema-Less**: create classes with no properties. Default mode is non strict-mode so records can have arbitrary fields
- **Schema-Hybrid**, called also *Schema-Mixed* is the most used: create classes and define some fields but leave the record to define own custom fields

NOTE: _Changes to the schema are not transactional, so execute them outside a transaction._

To access to the schema, you can use [SQL](SQL.md#query-the-schema) or API. Will follow examples using Java API.

For a tutorial look at the following links:
- Orient Technologies's Blog post about [Using Schema with Graphs](http://orientechnologies.blogspot.it/2013/08/orientdb-using-schema-with-graphs.html)


## Class
A Class, or type, is a concept taken from the Object Oriented paradigm. In OrientDB defines a type of record. It's the closest concept to a Relational DBMS Table. Class can be schema-less, schema-full or mixed. A class can inherit from another shaping a tree of classes. Inheritance means that the sub-class extends the parent one inheriting all the attributes as they was own.

A class must have at least one cluster defined (as its default cluster), but can support multiple ones. In this case By default OrientDB will write new records in the default cluster, but reads will always involve all the defined clusters. When you create a new class by default a new physical cluster is created with the same name of the class in lower-case.

The Graph structure is based on two classes: "V" for Vertices and "E" for Edges. These class are automatically built once a database is built using the mode "graph". If you don't have these classes just create them (see below).

You can build a graph using V and E instances but it's strongly suggested to use custom types for vertices and edges.

### Working with custom vertex and edge types

To create a custom Vertex class (or type) use the ``createVertexType(<name>)``:

    OrientGraph graph = new OrientGraph("local:/temp/db");
    OrientVertexType account = graph.createVertexType("Account");

To create a vertex of type "Account" pass a string with the format ``"class:<name>"`` as vertex id:

    Vertex v = graph.addVertex("class:Account");

Since classes are polymorphic if you look for generic Vertices also "Account" instances are returned:

    Iterable<Vertex> allVertices = graph.getVertices();

To retrieve only the vertices of "Account" class:

    Iterable<Vertex> accountVertices = graph.getVerticesOfClass("Account");

In Blueprints Edges has the concept of "label" to distinguish between edge types. In OrientDB we binds the concept of Edge label to Edge class. To create an Edge custom type use the similar method ``createEdgeType(<name>)``:

    OrientGraph graph = new OrientGraph("local:/temp/db");
    OrientVertexType accountVertex = graph.createVertexType("Account");
    OrientVertexType addressVertex = graph.createVertexType("Address");
    // CREATE THE EDGE TYPE
    OrientEdgeType livesEdge = graph.createEdgeType("Lives");

    Vertex account = graph.addVertex("class:Account");
    Vertex address = graph.addVertex("class:Address");

    // CREATE THE EDGE
    Edge e = account.addEdge("Lives", address);

### Inheritance tree
Classes can extends other classes. Starting from 2.1 OrientDB supports also multiple inheritance. To create a class that extends a class different by "V" (Vertex) and E (Edge) types, pass the class name on construction:

    graph.createVertexType(<class-name>, <super-class>); // VERTEX TYPE
    graph.createEdgeType(<class-name>, <super-class>);  // EDGE TYPE

Example to create a base class "Account" and two sub-classes "Provider" and "Customer":

    graph.createVertexType("Account");
    graph.createVertexType("Customer", "Account");
    graph.createVertexType("Provider", "Account");

### Get custom types

To retrieve such custom classes use the methods ``graph.getVertexType(<name>)`` and ``graph.getEdgeType(<name>)``. Example:

    OrientVertexType accountVertex = graph.getVertexType("Account");
    OrientEdgeType livesEdge = graph.getEdgeType("Lives");

### Drop persistent types

To drop a persistent class use the ``dropVertexType(<name>)`` and  ``dropVertexType(<name>)``  methods.

    graph.dropVertexType("Address");
    graph.dropEdgeType("Lives");

## Property
Properties are the fields of the class. In this guide Property is synonym of Field.

### Create a property
Once the class has been created, you can define fields (properties). Below an example:

    OrientVertexType accountVertex = graph.getVertexType("Account");
    accountVertex.createProperty("id", OType.INTEGER);
    accountVertex.createProperty("birthDate", OType.DATE);

Please note that each field must belong to one of [Types supported types].

### Drop the Class property
To drop a persistent class property use the ``OClass.dropProperty(String)`` method.

    accountVertex.dropProperty("name");

The dropped property will not be removed from records unless you explicitly delete them using the [SQLUpdate SQL UPDATE + REMOVE statement]. Example:

    accountVertex.dropProperty("name");
    database.command(new OCommandSQL("UPDATE Account REMOVE name")).execute();

### Constraints

| | |
|----|-----|
|![](images/warning.png)|Constraints with distributed databases could cause problems because some operations are executed at 2 steps: create + update. For example in some circumstance edges could be first created, then updated, but constraints like MANDATORY and NOTNULL against fields would fail at the first step making the creation of edges not possible on distributed mode.|

OrientDB supports a number of constrains for each field:
- **Minimum value**, accepts a string because works also for date ranges ``setMin()``
- **Maximum value**, accepts a string because works also for date ranges ``setMax()``
- **Mandatory**, it must be specified ``setMandatory()``
- **Readonly**, it may not be updated after record is created ``setReadonly()``
- **Not Null**, can't be NULL ``setNotNull()``
- **Unique**, doesn't allow duplicates and speedup searches.
- **Regexp**, it must satisfy the [Regular expression](http://en.wikipedia.org/wiki/Regular_expression).
- **Ordered**, specify if edge list must be ordered, so a List will be used in place of Set. The method is ``setOrdered()``

Example:

    profile.createProperty("nick", OType.STRING).setMin("3").setMax("30").setMandatory(true).setNotNull(true);
    profile.createIndex("nickIdx", OClass.INDEX_TYPE.UNIQUE, "nick"); // Creates unique constraint

    profile.createProperty("name", OType.STRING).setMin("3").setMax("30");
    profile.createProperty("surname", OType.STRING).setMin("3").setMax("30");
    profile.createProperty("registeredOn", OType.DATE).setMin("2010-01-01 00:00:00");
    profile.createProperty("lastAccessOn", OType.DATE).setMin("2010-01-01 00:00:00");

#### Indexes as constrains

To let to a property value to be UNIQUE use the UNIQUE index as constraint by passing a Parameter object with key "type":

    graph.createKeyIndex("id", Vertex.class, new Parameter("type", "UNIQUE"));

This constraint will be applied to all the Vertex and sub-types instances. To specify an index against a custom type use the additional parameter "class":

    graph.createKeyIndex("name", Vertex.class, new Parameter("class", "Member"));

You can also have both UNIQUE index against custom types:

    graph.createKeyIndex("id", Vertex.class, new Parameter("type", "UNIQUE"), new Parameter("class", "Member"));

To get a vertex or an edge by key prefix the class name to the field. For the example above use "Member.name" in place of only "name" to use the index created against the field "name" of class "Member":

    for( Vertex v : graph.getVertices("Member.name", "Jay") ) {
      System.out.println("Found vertex: " + v );
    }

If the class name is not passed, then "V" is taken for vertices and "E" for edges:

    graph.getVertices("name", "Jay");
    graph.getEdges("age", 20);

For more information about indexes look at [Index guide](Indexes.md).

(Go back to [Graph-Database-Tinkerpop](Graph-Database-Tinkerpop.md))
