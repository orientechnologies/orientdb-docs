# PyOrient OGM - Schemas

By definition, an OGM maps objects in your application to classes in a Graph Database.  In doing so, it defines a schema in the database to match classes and sub-classes in the application.

## Building Schemas

PyOrient only maps classes to the database schema that belong to the registry on your PyOrient `Graph` object.  There are two types of registeries, one indicating a vertex, (or node), and the other an edge, (or relationation).  Adding Python classes to the registries is handled through subclassing.  For instance, 

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

