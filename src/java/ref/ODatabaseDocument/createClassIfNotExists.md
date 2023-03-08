
# ODatabaseDocument - createClassIfNotExists()

This method creates a new database class if the given name does not already exist.

## Creating Database Classes

OrientDB borrows from the Object Oriented programming paradigm the concept of classes, which in these Reference pages is called a *database class*, to avoid confusion with classes in Java.  Internally, each database class is an instance of [`OClass`](../OClass.md).  Using this method, you can create new database classes on the database, when the given name doesn't exist already.


### Syntax

```
default OClass ODatabaseDocument().createClassIfNotExist(
      String name,
	  String... superclasses)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the database class name |
| **`superclasses`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the superclass the new class belongs to |

#### Return Value

This method returns an [`OClass`](../OClass.md) instance for the database class.


