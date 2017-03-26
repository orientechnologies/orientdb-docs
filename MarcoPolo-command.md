---
search:
   keywords: ['Elixir', 'MarcoPolo', 'command', 'query']
---

# MarcoPolo - `command()`

This function executes a query or command on the database.

## Issuing Commands

OrientDB SQL differentiates between idempotent queries (such as [`SELECT`](SQL-Query.md) and non-idempotent commands, such as [`INSERT`](SQL-Insert.md).  The MarcoPolo Elixir API does not make this distinction, providing this function for use with both queries and commands..

### Syntax

```
command(<conn>, <query>, <opts>)
```

- **`<conn>`** Defines the database connection.
- **`<query>`** Defines teh query or command you want to execute.
- **`<opts>`** Defines additional options to set on the command.

### Example
