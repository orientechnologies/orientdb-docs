---
search:
   keywords: ['Elixir', 'MarcoPolo', 'reload database', 'database reload', 'db_reload']
---

# MarcoPolo - `db_reload()`

This function reloads the database connection.

## Reloading Databases

Occasionally, you may need to reload the database connection.

### Syntax

```
db_reload(<conn>, <opts>)
```

- **`<conn>`** Defines the database connection.
- **`<opts>`** Defines additional options for the function.

#### Options

This function can take one additional option.

- **`:timeout`** Defines the timeout value in milliseconds.  In the event that the reload operate takes longer than the alloted time, MarcoPolo sends an exit signal to the calling process.

### Example

Consider the use case of a multithreaded application or some similar deployment in which multiple clients are operating on the given OrientDB database.  You might want to set up a basic timer that reloads the database connection periodically from a separate thread.

```elixir
@doc """ Reload the database connection at set intervals"""
def reload(conn, interval) do

	# Log Operataion
	IO.puts("Starting Reload Function")

	# Start Timer
	timer.apply_interval(interval, MarcoPolo, db_reload, conn)

end
```
