---
search:
   keywords: ['functions', 'database', 'remove edge', 'edge',  'removeEdge']
---

# Functions - removeEdge()

This method removes the given edge from the graph.

## Removing Vertices

While you can query graph records in the same manner you would query document records, removing them can sometimes require a number of additional steps to update the connecting records and keep the graph consistent.  OrientDB provides special functions for vertices and edges to ensure this update happens when you remove records in a graph.

>When removing records in a document database, you can use the standard [`delete()`](Functions-Database-delete.md) function.  To remove a vertex, use [`removeVertex()`](Functions-Database-removeVertex.md).

### Syntax

```
db.removeEdge(<edge>)
```

- **`<edge>`** Defines the edge you want to remove.
