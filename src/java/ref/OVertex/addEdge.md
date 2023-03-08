
# OVertex - addEdge()

This method adds an edge linking this vertex to another.

## Adding Edges

In a Graph database, edges function as relationships linking different vertices together.  Using this method, you can link one [`OVertex`](../OVertex.md) instance to another.  You can create the edge as either a Lightweight Edge or a Regular Edge.

### Syntax

Records in OrientDB have their own classes on the database, which extend the [`OClass`](../OClass.md) class.  All edges are extensions of the `E` database class.  The first method creates the edge as an instance of the default `E` class.  The remaining methods allow you to define the class to which the new edge belongs. 

```
// METHOD 1 
OEdge OVertex().addEdge(OVertex toVertex)

// METHOD 2 
OEdge OVertex().addEdge(OVertex toVertex, OClass type)

// METHOD 3 
OEdge OVertex.addEdge(OVertex toVertex, String name)
```

| Argument | Type | Description |
|---|---|---|
| **`toVertex`** | [`OVertex`](../OVertex.md) | Defines the vertex the edge connects to |
| **`type`** | [`OClass`](../OClass.md) | Defines the OrientDB database class the edge belongs to |
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html)  | Defines the OrientDB database class the edge belongs to |

#### Return Value

This method returns an [`OEdge`](../OEdge.md) instance, which represents the edge you've added to the vertex.
