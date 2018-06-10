---
search:
   keywords: ['Java API', 'OVertex', 'get vertices', 'edge', 'getVertices']
---

# OVertex - getVertices()

This method retrieves all vertices connected by edges to this vertex.

## Retrieving Vertices

In a Graph database, a vertex connects to other vertices through edges.  Using this method you can follow the given edges to retrieve the connected [`OVertex`](../OVertex.md) instances.

### Syntax

Edges in OrientDB have direction and all records are defined by a database class.  In the case of direction, the edge is created pointing from one vertex to another.  This direction is implemented as the `ODirection` class.  Records have classes internal to the database, which are implemented as the [`OClass`](../OClass.md) class.  Vertices on the database belong either to the `V` class or as a class that extends the `V` class.

The first method uses the default `V` class.  The other methods allow you to define what database class of vertices you want to retrieve.

```
// METHOD 1
Iterable<OVertex> OVertex().getVertices(ODiriection dir)

// METHOD 2
Iterable<OVertex> OVertex().getVertices(ODiriection dir, OClass... type)

// METHOD 3
Iterable<OVertex> OVertex().getVertices(ODiriection dir, String... name)
```

| Argument | Type | Description |
|---|---|---|
| **`dir`** | `ODirection` | Defines the direction to search |
| **`type`** | [`OClass`](../OClass.md) | Defines the database class |
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the name of the database class |

#### Return Value

This method returns an [`Iterable`]({{ book.javase }}/api/java/lang/Iterable.html) instance that contains a series of [`OVertex`](../OVertex.md) instances representing the connected vertices.
