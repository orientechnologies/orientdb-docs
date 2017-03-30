---
search:
   keywords: ['Elixir', 'MarcoPolo', 'database size', 'db_size']
---

# MarcoPolo - `db_size()`

This function returns the size of the database.

## Sizing the Database

In certain situations you may find it useful to size the database or to count the number of records it contains.  The [`db_countrecords()`](MarcoParco-db-countrecords.md) function returns the record count.  This function returns the size.

### Syntax

```
db_size(<conn>, <opts>)
```

- **`<conn>`** Defines the database connection.
- **`<opts>`** Defines additional options for the function.

#### Options

This function provides only one additional option:

- **`:timeout`** Defines the timeout value in milliseconds.  In the event that the operation takes longer than the allotted time, MarcoPolo sends an exit signal to the calling process.

#### Return Value

When this function is successful, it returns the tuple `{:ok, size}`, where `size` is a non-negative integer indicating the database size.  In the event that the operation fails, the function returns the tipe `{:error, reason}`, where `reason` contains the exception message.


### Example

For instance, consider the use case of a logging operation.  Whenever you close a database connection, you would like to log the size of the database at the time it was closed, to check against later.

```elixir
@doc """ Close the Database """
def close_database(conn) do

	# Log Operation
	IO.puts("Closing Database")

	# Fetch Size
	size = MarcoPolo.db_size(conn)
	IO.puts("Database Size: #{size}")

	# Close Database
	MarcoPolo.stop(conn)
	IO.puts("Database Closed")

end
```
