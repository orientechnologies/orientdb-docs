---
search:
   keywords: ['Java API', 'OClass', 'superclass', 'get all super classes', 'getAllSuperClasses']
---

# OClass - getAllSuperClasses()

This method retrieves [`OClass`](../OClass.md) instances for all classes registered as superclasses of this class.

## Retrieving Super Classes

OrientDB borrows the concept of a class from the Object Oriented programming paradigm.  This borrowing includes polymorphism, the idea that a database class can have subclasses.  Using this method, you can retrieve all superclasses of the given class.

### Syntax

```
Collection<OClass> OClass().getAllSuperClasses()
```

#### Return Value

This method returns a [`Collection`]({{ book.javase }}/api/java/util/Collection.html) instance that contains instances of [`OClass`](../OClass.md) for each class that is a superclass of this class.
