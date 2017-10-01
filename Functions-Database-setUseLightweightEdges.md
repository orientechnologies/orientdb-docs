---
search:
   keywords: ['functions', 'database', 'edges', 'lightweight edges', 'setUseLightweightEdges']
---

# Functions - setUseLightweightEdges()

This method enables or disables the use of lightweight edges on the database.


## Using Lightweight Edges

When you create an edge in OrientDB, there are two modes in which it's stored on the database.  With regular edges, the edge is a separate record that indicates the connecting vertices and any other informtion you would like to store on it.  By contrast, databases using [Lightweight Edges](Lightweight-Edges.md) don't store the edge as a separate record.  Instead,  it stores the edge as properties on the connecting vertices.

In cases where you need to change how the database handles edges, you can use this method to enable or disable the feature on the database.  To check the current use of lightweight edges, see the [`isUseLightweightEdges()`](Functions-Database-isUseLightweightEdges.md) method.


### Syntax

```
db.setUseLightweightEdges()
```
