---
search:
   keywords: ['java', 'olivequeryresultlistener', 'live query']
---

# OLiveQueryResultListener

Interface provides a listener interface for live queries.

## Using Live Query Listeners

In OrientDB, [Live Queries](../Live-Query.md) allows you to execute code in response to changes on the database.  It has two parts, a query that defines the records you want to monitor and a listener that controls what your application does in response to changes in these records.  Using this interface, you can implement your own listener with the specific code you want to run in response to changes.

To use `OLiveQueryListener` in your application, import it into your code:

```java
import com.orientechnologies.orient.core.db.OLiveQueryResultListener;
```

## Methods

When your Live Query registers an event, such as a user running an [`UPDATE`](../../sql/SQL-Update.md) or [`DELETE`](../../sql/SQL-Delete.md) statement, OrientDB attempts to call methods on the listener.   You can define what actions your application takes by overriding the following methods, implementing your own code. 

| Method | Description |
|---|---|
| [**`onCreate()`**](OLiveQueryResultListener/onCreate.md) | Executes on record creation |
| [**`onDelete()`**](OLiveQueryResultListener/onDelete.md) | Executes on record deletion |
| [**`onEnd()`**](OLiveQueryResultListener/onEnd.md) | Executes on unsubscribe |
| [**`onError()`**](OLiveQueryResultListener/onError.md) | Executes on errors |
| [**`onUpdate()`**](OLiveQueryResultListener/onUpdate.md) | Executes on record updates |


