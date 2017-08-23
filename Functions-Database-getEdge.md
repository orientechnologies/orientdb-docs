---
search:
   keywords: ['functions', 'get edge', 'getEdge']
---

# Functions - getEdge()

This method retrieves an edge.

## Retrieving Edges

When you have the [Record ID](Concepts.md#record-id) for a given edge and want to retrieve it into the function to operate on, you can do so using this method.  It is comparable to the [`load()`](Functions-Database-load.md) method on document databases and the [`getVertex`](Functions-Database-getVertex.md) method with vertices.

### Syntax

```
var edge = db.getEdge(<record-id>)
```

- **`<record-id>`** Defines the Record ID.

