---
search:
   keywords: ['functions', 'class', 'type', 'get vertex type', 'getVertexType']
---

# Functions - getVertexType()

This methods retrieves the given vertex class.

## Retrieving Classes 

OrientDB borrows the concept of class from the Object Oriented Programming paradigm. Classes can have subclasses and inherit from superclasses.  A vertex class is any that extends the base vertex class `V`.

Using this method, you can retrieve the given vertex class instance, allowing you to operate on the class from within your function. 

### Syntax

```
var vclass = db.getVertexType(<class>)
```

- **`<class>`** Defines the name of the class.

