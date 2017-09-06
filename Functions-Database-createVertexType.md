---
search:
   keywords: ['functions', 'database', 'vertex', 'create vertex class', 'create vertex type', 'extend v', 'createVertexType']
---

# Functions - createVertexType()

This method creates a database class that extends `V`.

## Creating Vertex Classes

Classes in OrientDB define the type of records you want to store.  Vertices in OrientDB belong to the `V` class or to a subclass of `V`.  Using this method, you can create a vertex class on your database.  It creates the class and performs additional operations so that the new class extends the base vertex class `V`.

### Syntax

```
var newClass = db.createVertexType(<class>, <superclass>)
```

- **`<class>`** Defines the class you want to create.
- **`<superclass>`** Defines the class you want to extend, defaults to the `V` class.





