---
search:
   keywords: ['Java API', 'OElement', 'isVertex', 'is vertex', 'vertex']
---

# OElement - isVertex()

This method determines whether the record is a vertex.

## Checking Vertices

When OrientDB is serving as a Graph database, [`OElement`](Java-Ref-OElement.md) serves as the superclass to both edges and vertices.  Using this method you can check whether or not the element is a vertex on the database.  To determine whether the element is an edge, see [`isEdge()`](Java-Ref-OElement-isEdge.md).

### Syntax

```
Boolean OElement().isVertex()
```

#### Return Value

This method returns a [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) instance.  If the return value is `true`, the element is a vertex.
