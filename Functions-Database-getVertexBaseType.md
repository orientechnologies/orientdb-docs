---
search:
   keywords: ['functions', 'database', 'get vertex base type', 'classes', 'getVertexBaseType', 'V']
---

# Functions - getVertexBaseType()

This method returns the OrientDB base class for vertices, which by default is the `V` class.

## Retrieving Classes

OrientDB borrows from the Object Oriented Programming paradigm the concept of a class.  Where a cluster indicates where you want to store a record, classes indicate the types of records you want to store.  Classes can have inherit from super classes and themselves have subclasses.

In a graph database, the base class for a vertex is the `V` class.  This method retrieves `V` into your function, allowing you to operate on the class.

### Syntax

```
var vclass = db.getVertexBaseType()
```


