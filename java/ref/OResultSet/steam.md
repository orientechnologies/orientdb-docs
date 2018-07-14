---
search:
   keywords: ['java', 'oresultset', 'stream']
---

# OResultSet - stream()

Streams records in the result-set.

## Streaming Records

When you want to operate on all records in the result-set in a [`Stream`]({{ book.javase }}/java/util/stream/Stream.html), you can do so using this method.

### Syntax

```
Stream<OResult> OResultSet().stream()
```

#### Return Value

This method returns a [`Stream`]({{ book.javase }}/java/util/stream/Stream.html)[`<OResult>`](../OResult.md) instance representing the results in the result-set.
