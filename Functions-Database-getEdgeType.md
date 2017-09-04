---
search:
   keywords: ['functions', 'class', 'type', 'get edge type', 'getEdgeType']
---

# Functions - getEdgeType()

This methods retrieves the given edge class.

## Retrieving Classes 

OrientDB borrows the concept of class from the Object Oriented Programming paradigm. Classes can have subclasses and inherit from superclasses.  An edge class is any that extends the base edge class `E`.

Using this method, you can retrieve the given edge class instance, allowing you to operate on the class from within your function. 

### Syntax

```
var eclass = db.getEdgeType(<class>)
```

- **`<class>`** Defines the name of the class.

