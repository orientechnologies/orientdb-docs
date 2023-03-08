---
search:
   keywords: ['Java API', 'OClass', 'class', 'subclass', 'get subclasses', 'getSubclasses']
---

# OClass - getSubclasses()

This method retrieves the immediate subclasses for the class.

## Retrieving Subclasses

OrientDB borrows the concept of a class from the Object Oriented programming paradigm.  This borrowing includes polymorphism, the idea that a database class can have subclasses.  Using this method, you can retrieve all subclasses of the given class.

Note, the method only retrieves those classes that use this class as their immediate superclass.  It does not follow the inheritance any deeper to subclasses of these subclasses.  To retrieve all subclasses, including subclasses of the immediate subclasses, use the [`getAllSubclasses()`](getAllSubclasses.md) method.

### Syntax

```
Collection<OClass> OClass().getSubclasses()
```

#### Return Value

This method returns a `Collection` instance that contains [`OClass`](../OClass.md) instances for each subclass registered to this class.
