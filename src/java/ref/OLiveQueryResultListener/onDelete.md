---
search:
   keywords: ['java', 'olivequeryresultlistener', 'live query', 'ondelete']
---

# OLiveQueryResultListener - onDelete()

Executes when a record  is removed from a [Live Query](../../Live-Query.md).

## Live Queries and Deleted Records

In OrientDB, a Live Query is composed of a query that defines the records you want to monitor and a listener that controls what your application does in the event of changes to those records.  Using this method, you can define what happens when a record is removed from a Live Query result-set.

### Syntax

```
void OLiveQueryResultListener().onDelete(
   ODatabaseDocument db,
   OResult data)
```

| Argument | Type | Description |
|---|---|---|
| **`db`** | [`ODatabaseDocument`](../ODatabaseDocument.md) | Provides the database in which the Live Query executes |
| **`data`** | [`OResult`](../OResult.md) | Provides the data |

