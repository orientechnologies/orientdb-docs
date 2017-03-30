---
search:
   keywords: ['Elixir', 'MarcoPolo', 'live query', 'unsubscribe', 'live_query_unsubscribe']
---

# MarcoPolo - `live_query_unsubscribe()`

This function unsubscribes a receiver from a live query.

## Unsubscribing from Live Queries

When you issue queries using the standard [`command()`](MarcoPolo-command.md) function, what it returns is effectively a snapshot of the records in the state they held when the query was issued.  In the event that another client modifies these records, there's no way you'll know unless you reissue the query.

To get around this limitation, OrientDB provides [Live Queries](Live-Query.md).  Instead of returning records, these queries return a subscription token.  When the records assigned to this token receive an update, OrientDB pushes the changes to the receiver function.

To subscribe to a live query in your Elixir application, use the [`live_query()`](MarcoPolo-live-query.md) function.  This function unsubscribes to the live query.

### Syntax

```
live_query_unsubscribe(<conn>, <token>)
```
- **`<conn>`** Defines the database connection.
- **`<token>`** Defines the live query token.

#### Return Values

This function only returns the value `:ok`.

### Example
