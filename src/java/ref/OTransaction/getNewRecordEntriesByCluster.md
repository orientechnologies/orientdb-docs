---
search:
   keywords: ['java', 'otransaction', 'getnewrecordentriesbycluster']
---

# OTransaction - getNewRecordEntriesByCluster()

Retrieves a list of records of the given class added to the database by this transaction.

## Retrieving Records

During transactions you may occasionally or often need to write to the database.  Using this method you can retrieve a list of records modified by the current transaction that belong to the given cluster.

### Syntax

```
List<ORecordOperation> OTransaction().getNewRecordEntriesByClass(
   int[] ids
```

| Argument | Type | Description |
|---|---|---|
| **`ids`** | `int[]` | Defines an array of Cluster ID's to check |

#### Return Value

This method returns a `List` of [`ORecordOperation`](../ORecordOperation.md) instances.  Each instance represents a record updated within the transaction.

