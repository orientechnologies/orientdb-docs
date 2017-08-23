---
search:
   keywords: ['functions', 'graph', 'add edge', 'vertex', 'edge', 'addEdge']
---

# Functions - addEdge()

This method adds an edge to the database.

## Adding Edges

When working with a Graph database, whether transactional or non-transactional, when you want to add an edge to the graph, use this method.  This adds a new edge record to the database and ensures that the relevant vertices are also updated, keeping the graph consistent.


### Syntax

```
var edge = db.addEdge(<record-id>, <out>, <in>, <label>)
```

- **`<record-id>`** Defines the [Record ID](Concepts.md#record-id).
- **`<out>`** Defines the out vertex.
- **`<in>`**  Defines the in vertex.
- **`<label>`** Defines a name or label for the edge.

>**NOTE**: You can use the [`getVertex()`](Functions-Database-getVertex.md) method to retrieve the in and out vertices to connect the edge.
