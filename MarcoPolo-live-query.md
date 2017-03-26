---
search:
   keywords: ['Elixir', 'MarcoPolo', 'live query', 'subscribe', 'live_query']
---

# MarcoPolo - `live_query()`

This function subscribes to a [live query](Live-Query.md)

## Subscribing to Live Queries

### Syntax

```
live_query(<conn>, <query>, <receiver>, <opts>)
```

- **`<conn>`** Defines the database connection.
- **`<query>`** Defines the query.
- **`<receiver>`** Defines the function to receive the records
- **`<opts>`** Defines additional options for the function.

### Example
