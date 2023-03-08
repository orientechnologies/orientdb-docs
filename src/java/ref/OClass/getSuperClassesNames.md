
# OClass - getSuperClassesNames()

This method retrieves the names of all classes registered as superclasses of this class.

## Retrieving Super Classes

OrientDB borrows the concept of class from the Object Oriented programming paradigm.  This borrowing includes polymorphism, the idea that a class can have subclasses that inherit features from it.In cases where the given [`OClass`](../OClass.md) instance is itself a subclass, you can use this method to retrieve a list of all classes that are superclasses to this class.

### Syntax

```
List<String> OClass().getSuperClassesNames()
```

#### Return Value

This method returns a [`List`]({{ book.javase }}/api/java/util/List.html) instance that contains instances of the [`String`]({{ book.javase }}/api/java/lang/String.html) class, providing names of all classes registered as superclasses of this class.
