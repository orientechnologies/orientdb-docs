---
search:
   keywords: ['java', 'oresultset', 'vertexstream']
---

# OResultSet - vertexStream()

Retrieves a stream of vertices from the result-set.

## Retrieving Vertices

When you have a result-set that contains elements, vertices and edges all together and only want the vertices, you can use this method to filter them out.  It returns a stream of [`OVertex`](../OVertex.md) instances from the result-set.

### Syntax

```
Stream<OVertex> OResultSet().vertexStream()
```

#### Return Value

This method returns a [`Stream`]({{ book.javase }}/java/util/stream/Stream.html)[`<OVertex>`](../OVertex.md) instance representing the results in the result-set.

