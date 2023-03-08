
# OElement - asVertex()

This method returns the record as an `OVertex` instance.

## Creating Vertices

The [`OElement`](../OElement.md) class corresponds to a document record in a Document database.  When you use OrientDB as a Graph database, it serves as the superclass to both vertices and edges.  In the event that you want a record to serve as a vertex, use this method to operate on it as an [`OVertex`](../OVertex.md) instance.

### Syntax

```
Optional<OVertex> OElement().asVertex()
```

#### Return Value

When the record corresponding to this [`OElement`](../OElement.md) instance is a vertex, this method returns an [`OVertex`](../OVertex.md) instance.  In the event that the record is a document or edge, (that is, not a vertex), it returns an empty [`Optional`]({{ book.javase }}/api/java/util/Optional.html) instance.
