---
search:
   keywords: ['Java API', 'OVertex', 'get edges', 'getEdges']
---

# OVertex - getEdges()

This method retrieves all connected edges to or from this vertex. 

## Retrieving Edges

In a Graph database, edges represent relationships between vertices.  These relationships have a direction, leading from one vertex to another.  Using this method, you can retrieve all edges that connect to this vertex or connect from this vertex. 

### Syntax

Edges in OrientDB have direction and class.  In the case of direction, the edge is created pointing from one vertex to another.  This direction is implemented as the `ODirection` class.  Additionally, edges like all records have classes internal to the database, which are implemented as [`OClass`](../OClass.md) instance.   On the database they either belong to the `E` class, or a class that extends the `E` class.

The first method uses the `E` class, and thus retrieves all edges that connect to or from the vertex.  The remaining methods allow you to define which database class of edges you want to retrieve.

```
// METHOD 1
Iterable<OEdge> OVertex().getEdges(ODirection dir)

// METHOD 2
Iterable<OEdge> OVertex().getEdges(ODirection dir, OClass... type)

// METHOD 3
Iterable<OEdge> OVertex().getEdges(ODirection dir), String... name
```

| Argument | Type | Description |
|---|---|---|
| **`dir`** | `ODirection` | Defines the direction |
| **`type`** | [`OClass`](../OClass.md) | Defines the database class |
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the database class name |

#### Return Value

This method returns an [`Iterable`]({{ book.javase }}/api/java/lang/Iterable.html) instance that contains a series of [`OEdge`](../OEdge.md) instances representing the connected edges.
