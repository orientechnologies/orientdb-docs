---
search:
   keywords: ['function', 'get vertex', 'getVertex']
---

# Functions - getVertex()

This method retrieves a vertex from the database.

## Retrieving Vertices

When you have the [Record ID](Concepts.md#record-id) for a given vertex and want to retrieve it into the function to operate on, you can do so using this method.  It is comparable to the [`load()`](Functions-Database-load.md) method on document databases.  To retrieve an edge, see [`getEdge()`](Functions-Database-getEdge.md).

### Syntax

```
var vertex = db.getVertex(<record-id>)
```

- **`<record-id>`** Defines the Record ID.
