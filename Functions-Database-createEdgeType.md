---
search:
   keywords: ['functions', 'database', 'edge', 'create edge class', 'create edge type', 'extend e', 'createEdgeType']
---

# Functions - createEdgeType()

This method creates a database class that extends `E`.

## Creating Vertex Classes

Classes in OrientDB define the type of records you want to store.  Edges in OrientDB belong to the `E` class or to a class that inherits from `E`.  Using this method, you can create an edge class on your database.  It creates the class and performs additional operations so that the new class extends the base edge class `E`.

### Syntax

```
var newClass = db.createEdgeType(<class>, <superclass>)
```

- **`<class>`** Defines the class you want to create.
- **`<superclass>`** Defines the class you want to extend, defaults to the `E` class.





