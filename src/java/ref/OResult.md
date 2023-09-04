
# OResult

Provides an interface for interacting with records in a result-set.

## Managing Results 

Results are the records that OrientDB returns from queries.  You typically get them from the [`OResultSet`](OResultSet.md) interface.  In order to use `OResult` you need to import the class into your code.

```java
import com.orientechnologies.orient.core.sql.executor.OResult;
```

## Methods

### Typing Results

`OResult` provides a series of methods to determine whether the result is of one type or another.  All of these methods return `boolean` values.

| Method | Description |
|---|---|
| **`isBlob()`** | Returns `true` if the result is an `OBlob` instance |
| **`isEdge()`** | Returns `true` if the result is an [`OEdge`](OEdge.md) instance |
| **`isElement()`** | Returns `true` if the result is an [`OElement`](OElement.md) instance |
| **`isRecord()`** | Returns `true` if the result is a record |
| **`isVertex()`** | Returns `true` if the result is an [`OVertex`](OVertex.md) element |

