---
search:
   keywords: ['PyOrient', 'Object Graph Mappers', 'OGM', 'schema']
---

# PyOrient OGM - Schemas

By definition, an OGM maps objects in your application to classes in a Graph Database.  In doing so, it defines a schema in the database to match classes and sub-classes in the application.

## Building Schemas from Classes

PyOrient only maps classes to the database schema that belong to the registry on your PyOrient `Graph` object.  There are two types of registries, one indicating a vertex, (or node), and the other an edge, (or relationship).  Adding Python classes to the registries is handled through subclassing.  For instance, 

```py
from pyorient.ogm import declarative

# Initialize Registries
Node = declarative.declarative_node()
Relationship = declarative.declarative_relationship()

# Create Vertex Class
class Person(Node):
   pass

# Create Edge Class
class Likes(Relationship):
   pass
```

Each call made to the `declarative_node()` and `declarative_relationship()` methods creates a new registry.  The OGM preserves inheritance hierarchies of nodes and relationships.  This registry is now accessible through `Node.registry` and `Relationship.registry`.

To create the corresponding classes in the OrientDB database schema, pass the registries to the `Graph` object, using the `create_all()` method.  For instance,

```py
# Initialize Schema
self.g.create_all(Node.registry)
self.g.create_all(Relationship.registry)
```

In the event that these classes already exist in your database schema, and you want to bind the Python objects too them rather than creating the schema anew, use the `include` method.

```py
# Bind Schema
self.g.include(Node.registry)
self.g.include(Relationship.registry)
```

## Building Classes from Schemas

Currently, PyOrient does not have a tool for automatically generating Python code from a database schema, but it come close.  Using the `build_mapping()` method, you can generate a dictionary of Python classes, (that is, a registry).  You can then pass the dictionary to the `include()` method on the PyOrient `Graph` class.

For instance,

```py
from pyorient.ogm.declarative import declarative_node, declarative_relationship

# Initial Schema Objects
SchemaNode = declarative_node()
SchemaRelationship = declarative_relationship()

# Retrive Schema from OrientDB
classes_from_schema = graph.build_mapping(
   SchemaNode,
   SchemaRelationship,
   auto_plural = True)

# Initialize Schema in PyOrient
graph.include(classes_from_schema)

```

Here, dynamically generated vertex classes have `SchemaNode` as their the top-level of their inheritance, while edge classes have `SchemaRelationship`.  By setting the `auto_plural` parameter to `True`, the subsequent `include()` method automatically assigns brokers to `graph` object.

>In the event that you would like to use custom names for your brokers, (such as, brokers that use the actual plural nouns), you need to perform some kind of post processing on the dict returned to `classes_from_schema`.  For instance, iterating through the broker names and adding "`s`" to the end of the string.




