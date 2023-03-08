# ODatabaseDocument - createClass()

This method creates a database class on the database.

## Creating Database Class

OrientDB borrows from the Object Oriented programming paradigm the concept of classes, which in these Reference pages is called a *database class*, to avoid confusion with classes in Java.  Internally, each database class is an instance of [`OClass`](../OClass.md).  Using this method, you can create new database classes on the database.

This method is implemented through the superclass `ODatabase`.

### Syntax

```
default OClass ODatabaseDocument().createClass(
      String name,
	  String... superclasses)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the database class name |
| **`superclasses`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the superclass to which the new class belongs |

#### Return Value

This method returns an [`OClass`](../OClass.md) instance for the new database class.
