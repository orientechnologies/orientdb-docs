
# OClass - isVertexType()

This method determines whether the class is a vertex.

## Checking Edges

In a Graph database, certain records serve as vertices while others serve as edges connecting the vertices to each other.  Both of these each have their own database classes.  When a record serves as a vertex it belongs either to the `V` database class or to a class that extends the `V` class.  

Using this method, you can determine whether the given class functions as a vertex on the database.  To determine whether the class functions as an edge, see [`isEdgeType()`](isEdgeType.md).


### Syntax

```
boolean OClass().isVertexType()
```

#### Return Value

This method returns a [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) instance, where `true` indicates that the class is a vertex.





