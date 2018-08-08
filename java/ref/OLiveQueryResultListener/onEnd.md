---
search:
   keywords: ['java', 'olivequeryresultlistener', 'live query', 'onend']
---

# OLiveQueryResultListener - onEnd()

Executes when the database unsubscribes to a [Live Query](../../Live-Query.md).

## Live Queries 

In OrientDB, a Live Query is composed of a query that defines the records you want to monitor and a listener that controls what your application does in the event of changes to those records.  Using this method you can define what happens when a database unsubscribes to a Live Query result-set.


### Syntax

```
void OLiveQueryResultListener().onCreate(
   ODatabaseDocument db)
```

| Argument | Type | Description |
|---|---|---|
| **`db`** | [`ODatabaseDocument`](../ODatabaseDocument.md) | Provides the database in which the Live Query executes |




