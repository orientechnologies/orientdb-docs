
# OLiveQueryResultListener - onError()

Executes whenever an error is generated by a [Live Query](../../Live-Query.md) 

## Live Queries 

In OrientDB, a Live Query is composed of a query that defines the records you want to monitor and a listener that controls what your application does in the event of changes to those records.  Using this method you can define what happens when a Live Query encounters an error. 

### Syntax

```
void OLiveQueryResultListener().onError(
   ODatabaseDocument db,
   OException exception)
```

| Argument | Type | Description |
|---|---|---|
| **`db`** | [`ODatabaseDocument`](../ODatabaseDocument.md) | Provides the database in which the Live Query executes |
| **`exception`** | `OException` | Provides exception instance |




