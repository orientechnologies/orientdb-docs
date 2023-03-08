
# OLiveQueryResultListener - onUpdate()

Executes when records are updated in a [Live Query](../../Live-Query.md).

## Live Queries 

In OrientDB, a Live Query is composed of a query that defines the records you want to monitor and a listener that controls what your application does in the event of changes to those records.  Using this method, you can define what happens when an [`UPDATE`](../../../sql/SQL-Update.md) statement is run affecting the Live Query result-set.

### Syntax

```
void OLiveQueryResultListener().onUpdate(
   ODatabaseDocument db,
   OResult before,
   OResult after)
```

| Argument | Type | Description |
|---|---|---|
| **`db`** | [`ODatabaseDocument`](../ODatabaseDocument.md) | Provides the database in which the Live Query executes |
| **`before`** | [`OResult`](../OResult.md) | Provides the data as it existed before the change |
| **`after`** | [`OResult`](../OResult.md) | Provides the data as it exists after the change | 




