
# OLiveQueryResultListener - onCreate()

Executes when new records are added to a [Live Query](../../Live-Query.md).

## Live Queries and New Records

In OrientDB, a Live Query is composed of a query that defines the records you want to monitor and a listener that controls what your application does in the event of changes to those records.  Using this method, you can define what happens when an [`INSERT`](../../../sql/SQL-Insert.md) or [`UPDATE`](../../../sql/SQL-Update.md) statement adds a new record to the Live Query result-set.

### Syntax

```
void OLiveQueryResultListener().onCreate(
   ODatabaseDocument db,
   OResult data)
```

| Argument | Type | Description |
|---|---|---|
| **`db`** | [`ODatabaseDocument`](../ODatabaseDocument.md) | Provides the database in which the Live Query executes |
| **`data`** | [`OResult`](../OResult.md) | Provides the data added |




