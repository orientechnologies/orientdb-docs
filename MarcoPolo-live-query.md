---
search:
   keywords: ['Elixir', 'MarcoPolo', 'live query', 'subscribe', 'live_query']
---

# MarcoPolo - `live_query()`

This function subscribes to a [live query](Live-Query.md)

## Subscribing to Live Queries

When you issue queries using the stnadrd [`command()`](MarcoPolo-command.md) function, what it returns is effectively a snapshot of the records in the state they held when the query was issued.  In the event that another client modifies these records, there's no way you'll know unless you reissue the query. 

To get around this limitation, OrientDB provides Live Queries.  Instead of returning records, these queries return a subscription token.  When the records assigned to this token recieve an update, OrientDB pushes the changes to the given receiver function. 

This function subscribes to live queries.  When you're finished with the live query, you can call the [`live_query_unsubscribe()`](MarcoPolo-live-query-unsubscribe.md) function to deregister the token.

### Syntax

```
live_query(<conn>, <query>, <receiver>, <opts>)
```

- **`<conn>`** Defines the database connection.
- **`<query>`** Defines the query.
- **`<receiver>`** Defines the function to receive the records
- **`<opts>`** Defines additional options for the function.  For more information, see [Options](#options).

#### Options

This function can take one additional option: 

- **`:timeout`** Defines the timeout value in milliseconds.  In the event that the operation takes longer than the allotted time, MarcoPolo sends an exit signal to the calling process.

#### Return Value

When this operation is successful, it returns the tuple `{:ok, token}`, where the variable is a subscription token, which OrientDB uses to register any changes made to the records the query returns.  You can use this token with the [`live_query_unsubscribe()`](MarcoPolo-live-query-unsubscribe.md) function when you're ready to unsubscribe.

In the event that the operation fails, it returns `{:error, message}`, where the variable provides the exception message.

### Example
