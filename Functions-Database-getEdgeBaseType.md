---
search:
   keywords: ['functions', 'database', 'get edge base type', 'classes', 'getEdgeBaseType', 'E']
---

# Functions - getEdgeBaseType()

This method returns the OrientDB base class for edges, which by default is the `E` class.

## Retrieving Classes

OrientDB borrows from the Object Oriented Programming paradigm the concept of a class.  Where a cluster indicates where you want to store a record, classes indicate the types of records you want to store.  Classes can have inherit from super classes and themselves have subclasses.

In a graph database, the base class for an edge, which is the `E` class.  This method retrieves `E` into your function, allowing you to operate on the class.

### Syntax

```
var eclass = db.getEdgeBaseType()
```


