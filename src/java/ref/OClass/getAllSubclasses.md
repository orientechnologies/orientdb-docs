
# OClass - getAllSubclasses()

This method retrieves all subclasses of the class.

## Retrieving Subclasses

OrientDB borrows the concept of a class from the Object Oriented programming paradigm.  This borrowing includes polymorphism, the idea that a database class can have subclasses.  Using this method, you can retrieve all subclasses of the given class and the subclasses of these subclasses.

Note, the method retrieves the complete hierarchy of the class, following inheritance of subclasses to the immediate subclasses.  In cases where you only want to retrieve the immediate subclasses to the clas, use the [`getSubclasses()`](getSubclasses.md) method.

### Syntax

```
Collection<OClass> OClass().getAllSubclasses()
```

#### Return Value

This method returns a [`Collection`]({{ book.javase }}/api/java/util/Collection.html) instance that contains a series of [`OClass`](../OClass.md) instances for the retrieved subclasses. 


