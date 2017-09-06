---
search:
   keywords: ['functions', 'database', 'edges', 'lightweight edges', 'isUseLightweightEdges']
---

# Functions - isUseLightweightEdges()

This method determines whether the database uses lightweight edges.

## Using Lightweight Edges

When you create an edge in OrientDB, there are two modes in which it's stored on the database.  With regular edges, the edge is a separate record that indicates the connecting vertices and any other informtion you would like to store on it.  By contrast, databases using [Lightweight Edges](Lightweight-Edges.md) don't store the edge as a separate record.  Instead,  it stores the edge as properties on the connecting vertices.

In cases where the use of Lightweight Edges affects your function, you can use this method to determine whether it's enabled for the database.  To change the setting, see the [`setUseLightweightEdges()`](Functions-Database-setUseLightweightEdges.md) method.

### Syntax

```
var isEnabled = db.isUseLightweightEdges()
```
