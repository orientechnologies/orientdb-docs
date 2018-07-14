---
search:
   keywords: ['java', 'oresultset']
---

# OResultSet

This class provides an interface for operating on data returned by OrientDB queries and commands.

## Managing Result-sets

Whenever you issue a query or command to an OrientDB database, (through the [`ODatabaseDocument`](ODatabaseDocument.md) class, for instance), OrientDB returns results as an `OResultSet` instance.  You can then operate on this instance to retrieve data or further process it before returning it to the user.

To use `OResultSet`, you need to import it to your code.

```java
import com.orientechnologies.orient.core.sql.executor.OResultSet;
```

Once you've imported it, you can set variables with this class and retrieve results.


### Example

```java
private ODatabaseDocument db;
...

// Return Count of Accounts 
public long fetchAccountCount(){

	// Fetch Data
	OResultSet data = db.query("SELECT FROM Accounts");

	return data.elementStream().count();
}
```

## Methods

| Method | Return Type | Description |
|---|---|---|
| [`close()`](OResultSet/close.md) | `void` | Closes the result-set |
| [`edgeStream`](OResultSet/edgeStream.md) | [`Stream`]({{ book.javase }}/java/util/Stream.html)[`<OEdge>`](OEdge.md) | Returns a stream of edges from the result-set |
| [`elementStream()`](OResultSet/elementStream.md) | [`Stream`]({{ book.javase }}/java/util/Stream.html)[`<OElement>`](OElement.md) | Returns a stream of elements from the result-set |
| [`estimateSize()`](OResultSet/estimateSize.md) | `long` | Estimates the number of records in the result-set |
| [`hasNext()`](OResultSet/hasNext.md) | `boolean` | Determines whether the `Iterator` contains additional values |
| [`next()`](OResultSet/next.md) | [`OResult`](OResult.md) | Returns the next result in the result-set |
| [`remove()`](OResultSet/remove.md) | `void` | Removes the last value returned by the `Iterator` |
| [`stream()`](OResultSet/stream.md) | [`Stream`]({{ book.javase }}/java/util/Stream.html)[`<OResult>`](OResult.md) | Streams the results in the result-set |
| [`vertexStream()`](OResultSet/vertexStream.md) | [`Stream`]({{ book.javase }}/java/util/Stream.html)[`<OVertex>`](../OVertex.md) | Streams vertices from the result-set |

