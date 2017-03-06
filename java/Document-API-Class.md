---
search:
   keywords: ['Document API', 'schema', 'class']
---

# Classes in the Document Database

The Class is a concept taken from the Object-Oriented Programming paradigm.  In OrientDB, classes define types of records.  Conceptually, it's closest to the table in Relational Databases.  You can make classes schema-less, schema-full or schema-hybrid.

Classes can inherit from other classes.  Inheritance means that the sub-class extends the parent class, inheriting all its attributes as if they were its own.

Each class has its own clusters. A class must have at least one defined cluster as its default cluster, but can support multiple clusters.  OrientDB writes new records in the default cluster, but reads always involve all defined clusters.

When you create a new class, OrientDB creates a new physical cluster with it, which has the same name, but set in lowercase.


## Creating Persistent Classes

Each class contains one or more properties, (which are also called fields).  This mode is similar to the classical model of Relational Databases, where you define tables before storing records.

For instance, consider the use case of creating an `Account` class through the Java API.  By default, new [Physical Clusters](../datamodeling/Concepts.md#physical-cluster) are created to store the class instances.

```java
OClass account = database.createClass("Account");
```

To create a new vertex or edge type, you need to extend the `V` or `E` classes, respectively.  For example,

```java
OClass person = database.createVertexClass("Account");
```

For more information, see [Graph Schema](Graph-Schema.md).

## Retrieving Persistent Classes

To retrieve persistent classes, use the `.getClass(String)` method.  If the class does not exist, the method returns a null value.

```java
OClass account = database.getClass("Account");
```

## Dropping Persistent Classes

To drop a persistent class use the `OSchema.dropClass(String)` method, this will remove all persistent records of the class.  For instance,

```java
database.getMetadata().getSchema().dropClass("Account");
```

## Constraints

To use constraints in schema-full mode, set the strict mode at the class-level.  You can do this by calling the `setStrictMode(true)` method.  In this case, you must pre-define all properties of the record.


