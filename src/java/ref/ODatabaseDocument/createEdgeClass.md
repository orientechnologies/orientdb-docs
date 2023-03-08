
# ODatabaseDocument - createEdgeClass()

This method creates a database class, which extends the `E` class on the database.

## Creating Edge Classes

OrientDB borrows from the Object Oriented programming paradigm the concept of classes, which in these Reference pages is called a *database class*, to avoid confusion with classes in Java.  Internally, each database class is an instance of [`OClass`](../OClass.md).  Using this method, you can create new database classes on the database, which extend the `E` edge class.

To create a vertex class instead, see [`createVertexClass()`](createVertexClass.md).

### Syntax

```
default OClass ODatabaseDocument().createEdgeClass(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the database class name |

#### Return Value

This method returns an [`OClass`](../OClass.md) instance for the new database class.




