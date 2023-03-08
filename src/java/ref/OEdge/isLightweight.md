
# OEdge - isLightweight()

This method determines whether an edge is a [lightweight edge](../../Lightweight-Edges.md).

## Lightweight Edges

When using OrientDB as a Graph database, there are two types of edges available.  The standard edge type is a Regular Edge, which extends the `E` class in the database and is stored as a separate record.  The newer edge type is the Lightweight Edge, which has no properties or identity on the database, since they exist only within vertex records.  This method allows you to determine whether an [`OEdge`](../OEdge.md) instance is a Lightweight or Regular edge.

### Syntax

```
Boolean OEdge().isLightweight()
```

#### Return Value

This method returns a [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) instance.  If the return value is `true`, it indicates that the [`OEdge`](../OEdge.md) instance is a Lightweight Edge.
