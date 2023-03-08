
# Classes in the Graph Database

Classes are a concept drawn from the Object-Oriented Programming paradigm.  OrientDB defines it as a record-type.  In the Relational Model, it is nearest the concept of the table.  Classes can be schema-less, schema-full or mixed.  Classes can inherit from another class, shaping a tree of classes.  Due to inheritance, the subclass extends the parent class, inheriting all the attributes as though they were its own.

Each class has one cluster defined as its default cluster, but it can support multiple clusters.  In this case by default, OrientDB writes new records in the default cluster, but reads always occur on defined clusters.  When you create a new class, it creates a default physical cluster with the same name as the class, changed to lowercase. 

In Graph Databases, the structure follows tow classes: `V` as the base class for vertices and `E` as the base class for edges.  OrientDB builds these classes automatically when you create the graph database.  In the event that you don't have these classes, create them, (see below).


## Working with Vertex and Edge Classes

While you can build graphs using `V` and `E` class instances, it is strongly recommended that you create custom types for vertices and edges.

To create a custom vertex class (or type) use the `createVertexType(<name>)`:

```java
// Create Custom Vertex Class
OrientVertexType account = graph.createVertexType("Account");
```

To create a vertex of that class `Account`, pass a string with the format `"class:<name>"`:

```java
// Add Vertex Instance
Vertex v = graph.addVertex("class:Account");
```

In Blueprints, edges have the concept of labels used in distinguishing between edge types.  OrientDB binds the concept of edge labels to edge classes.  There is a similar method in creating custom edge types, using `createEdgeType(<name)`:

```java
// Create Graph Database Instance
OrientGraph graph = new OrientGraph("plocal:/tmp/db");

// Create Custom Vertex Classes
OrientVertexType accountVertex = graph.createVertexType("Account");
OrientVertexType addressVertex = graph.createVertexType("Address");

// Create Custom Edge Class
OrientEdgeType livesedge = graph.createEdgeType("Lives");

// Create Vertices
Vertex account = graph.addVertex("class:Account");
Vertex address = graph.addVertex("class:Address");

// Create Edge
Edge e = account.addEdge("Lives", address);
```

## Inheritance Tree

Classes can extend other classes.  To create a class that extend a class different from `V` or `E`, pass the class name in the construction:

```java
graph.createVertexType(<class>, <super-class>); // Vertex
graph.createEdgeType(<class>, <super-class>); // Edge
```

For instance, create the base class `Account`, then create two subclasses: `Provider` and `Customer`:

```java
// Create Vertex Base Class
graph.createVertexType("Account");

// Create Vertex Subclasses
graph.createVertexType("Customer", "Account");
graph.createVertexType("Provider", "Account");
```


## Retrieve Types

Classes are polymorphic.  If you search for generic vertices, you also receive all custom vertex instances:

```java
// Retrieve Vertices
Iterable<Vertex> allVertices = graph.getVertices();
```

To retrieve custom classes, use the `getVertexType()` and the `getEdgeType` methods.  For instance, retrieving from the `graph` database instance:

```java
OrientVertexType accountVertex = graph.getVertexType("Account");
OrientEdgeType livesEdge = graph.getEdgeType("Lives");
```

## Drop Persistent Types

To drop a persistent class, use the `dropVertexType()` and `dropVertexType()` methods.  For instance, dropping from the `graph` database instance:

```java
graph.dropVertexType("Address");
graph.dropEdgeType("Lives");
```
