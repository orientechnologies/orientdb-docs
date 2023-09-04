
# OClass - isEdgeType()

This method determines whether the class is an edge.

## Checking Edges

In a Graph database, certain records serve as vertices while others serve as edges connecting the vertices to each other.  Both of these each have their own database classes.  When a record serves as an edge it belongs either to the `E` database class or to a class that extends the `E` class.  

Using this method, you can determine whether the given class functions as an edge on the database.  To determine whether the class is a vertex, see [`isVertexType()`](isVertexType.md).

### Syntax

```
boolean OClass().isEdgeType()
```

#### Return Value

This method returns a [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) instance, where `true` indicates that the class is an edge.





