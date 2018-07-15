---
search:
   keywords: ['java', 'odatabasedocument', 'live', 'live queries']
---

# ODatabaseDocument - live()

Subscribes a query as a live query for use with future create and update events.

## Using Live Queries

In OrientDB, a [Live Query](../../Live-Query.md) is essentially a [`SELECT`](../../../sql/SQL-Query.md) statement with push functionality.  The database identifies the records that the query would return, anytime a record is added that fits the query and anytime the records returned by the query are changed, OrientDB pushes the changes through to the listener.  Using this method, you can subscribe a query as a live query then configure how your application receives updates from OrientDB.

### Syntax

```
OLiveQueryMonitor ODatabaseDocument().live(
   String query,
   OLiveQueryResultListener listener
   Map<String, ?> args)
OLiveQueryMonitor ODatabaseDocument().live(
   String query,
   OLiveQueryResultListener listener
   Object... args)
```

| Argument | Type | Description |
|---|---|---|
| **`query`** | `String` | Query to define the records you want to monitor |
| **`listener`** | [`OLiveQueryResultListener`](../OLiveQueryResultListener.md) | Provides the listener to receive query results |
| **`args`** | `Map<String, ?>| Object...` | Arguments used in formatting the query |


#### Return Value

This method returns an [`OLiveQueryMonitor`](../OLiveQueryMonitor.md) instance.

