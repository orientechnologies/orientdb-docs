---
search:
   keywords: ['Java API', 'OEdge', 'OElement', 'get to vertex', 'getTo']
---

# OEdge - getTo()

This method retrieves the vertex that connects to this edge.

## Retrieving Vertices

Edges provide links between vertices.  The link connects from one vertex to another.  This method allows you to retrieve the [`OVertex`](Java-Ref-OVertex.md) instance that links to the edge.  To access the vertex that links from the edge, see the [`getFrom()`](Java-Ref-OEdge-getFrom.md) method.

### Syntax

```
OVertex OEdge().getTo()
```

#### Return Value

This method returns the [`OVertex`](Java-Ref-OVertex.md) instance that links to the edge.
