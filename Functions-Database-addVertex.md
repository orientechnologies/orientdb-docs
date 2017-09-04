---
search:
   keywords: ['functions', 'graph', 'add vertex', 'vertex', 'edge', 'addVertex']
---

# Functions - addVertex()

This method adds a vertex to the database.

## Adding Vertices 

When working with a Graph database, whether transactional or non-transactional, when you want to add a vertex to the graph, use this method.  This adds a new vertex record to the database and ensures that the relevant edges are also updated, keeping the graph consistent.

To add an edge from within your function, see [`addEdge()`](Functions-Database-addEdge.md).


### Syntax

```
var vertex = db.addVertex(<record-id>)
```

- **`<record-id>`** Defines the [Record ID](Concepts.md#record-id).

