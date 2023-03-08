
# ODatabaseDocument - createVertexClass()

This method creates a new database class, which extends the `V` class.

## Creating Vertex Classes

OrientDB borrows from the Object Oriented programming paradigm the concept of classes, which in these Reference pages is called a *database class*, to avoid confusion with classes in Java.  Internally, each database class is an instance of [`OClass`](../OClass.md).  Using this method, you can create new database classes on the database, which extend the `V` edge class.

To create a edge class instead, see [`createEdgeClass()`](createEdgeClass.md).

### Syntax

```
default OClass ODatabaseDocument().createVertexClass(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the database class name |

#### Return Value

This method returns an [`OClass`](../OClass.md) instance that represents the new database class.

