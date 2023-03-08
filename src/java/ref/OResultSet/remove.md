---
search:
   keywords: ['java', 'oresuletset', 'remove']
---

# OResultSet - remove()

Removes the next element from the result-set.

## Removing Elements

Using this method you can remove a record from the result-set.  Specifically, this method calls the `remove()` method on the underlying [`Iterator`]({{ book.javase }}/java/util/Iterator.html)[`<OResult>`](../OResult.md) instance.  Doing so removes the last element returned by the iterator from a [`next()`](next.md) call.

### Syntax

```
default void OResultSet().remove()
```
