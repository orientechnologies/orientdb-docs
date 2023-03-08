---
search:
   keywords: ['Java API', 'OElement', 'is edge', 'isEdge']
---

# OElement - isEdge()

This method determines whether the record is an edge.

## Checking Edges

When OrientDB is serving as a Graph database, [`OElement`](../OElement.md) serves as the superclass to both edges and vertices.  Using this method you can check whether or not the element is an edge on the database.  To determine whether the record is a vertex, see [`isVertex`](isVertex.md).

### Syntax

```
Boolean OElement().isEdge()
```

#### Return Value

This method returns a [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) instance.  If the return value is `true`, the element is an edge.
