
# OResultSet - edgeStreram()

Retrieves a stream of edges from the result-set.

## Streaming Edges

In cases where your result-set contains a number of elements, some of which are vertices and some of which are edges, you can use this method to filter [`OResultSet`](../OResultSet.md) to only return those records that are [`OEdge`](../OEdge.md) instances.

### Syntax

```
default Stream<OEdge> OResultSet().edgeStream()
```

#### Return Value

This method returns a [`Stream`]({{ book.javase }}/java/util/Stream.html) of [`OEdge`](../OEdge.md) instances contained in the result-set.





