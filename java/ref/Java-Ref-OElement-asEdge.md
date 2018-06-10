---
search:
   keywords: ['Java API', 'OElement', 'as edge', 'asEdge']
---

# OElement - asEdge()

This method returns the record as an `OEdge` instance.

## Creating Edges

The [`OElement`](Java-Ref-OElement.md) class corresponds to a document record in a Document database.  When you use OrientDB as a Graph database, it serves as the superclass to both vertices and edges.  In the event that you want a record to serve as an edge, use this method to operate on it an [`OEdge`](Java-Ref-OEdge.md) instance.

### Syntax

```
Optional<OEdge> OElement().asEdge()
```

#### Return Value

When the record corresponding to this [`OElement`](Java-Ref-OElement.md) instance is an edge, this method returns an [`OEdge`](Java-Ref-OEdge.md) instance.  In the event that the record is a document or vertex, (that is, not an edge), it returns an empty [`Optional`]({{ book.javase }}/api/java/util/Optional.html) instance.


