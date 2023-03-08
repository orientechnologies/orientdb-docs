---
search:
   keywords: ['java', 'odatabasedocument', 'listeners', 'registerlistener']
---

# ODatabaseDocument - registerListener()

Subscribes the given listener to database events.

## Using Listeners

Listeners allow you to monitor the database for particular events.  For instance, if you would like certain methods to execute whenever the database closes, initiates or commits a transaction, and so on.  Using this method, you can register an [`ODatabaseListener`](../ODatabaseListener.md) instance with the database. 

### Syntax

```
void ODatabaseDocument().registerListener(ODatabaseListener listener)
```

| Argument | Type | Description |
|---|---|---|
| **`listener`** | [`ODatabaseListener`](../ODatabaseListener.md) | Listener to register |


