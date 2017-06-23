---
search:
   keywords: ['Java API', 'ODatabaseDocument', 'cluster', 'browse cluster', 'browseCluster']
---

# ODatabaseDocument - browseCluster()

This method retrieves all records stored on the given cluster.

## Browsing Records by Cluster

When you save records to the database, OrientDB stores them in a cluster.  The cluster can be physical or in-memory.  Using this method, you can retrieve records by the cluster they're stored in.

### Syntax

```
// METHOD 1
<REC extends ORecord> ORecordIteratorCluster<REC> ODatabaseDocument().browseCluster(
      String name)

// METHOD 2
<REC extends ORecord> ORecordIteratorCluster<REC> ODatabaseDocument().browseCluster(
      String name,
      long startPosition, 
	  long endPosition)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the cluster name |
| **`startPosition`** | [`long`]({{ book.javase/api/java/lang/Long.html) | Defines the starting position for the records you want to retrieve |
| **`endPosition`** | [`long`]({{ book.javase }}/api/java/lang/Long.html) | Defines the ending position for the record you want to retrieve |

#### Return Value

This method returns an `ORecordIteratatorCluster` instance, which contains instances of the generic, which can be any class that extends the `ORecord` class.  The `ORecord` class itself extends the [`OElement`](Java-Ref-OElement.md) class.
