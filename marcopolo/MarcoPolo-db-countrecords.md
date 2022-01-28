---
search:
   keywords: ['Elixir', 'MarcoPolo', 'count records', 'db-countrecords']
---

# MarcoPolo - `db_countrecords()`

This function returns the number of records in a database.

## Counting Records

In certain situations you may find it useful to size the database or to count the number of records it contains.  The [`db_size()`](MarcoPolo-db-size.md) function returns the size.  This function returns the database record count. 

### Syntax

```
db_countrecords(<conn>, <opts>)
```

- **`<conn>`** Defines the database connection.
- **`<opts>`** Defines additional options.  For more information on the available options, see [Options](#options).

#### Options

This function only provides one additional option:
- **`:timeout`** Defines the timeout value in milliseconds.  In the event that the operation takes longer than the allotted time, MarcoPolo sends an exit signal to the calling process.

#### Return Values

When this function is successful it returns the tuple `{:ok, count}`, where `count` is a non-negative integer indicating the number of records in the connected database.  In the event that the function fails, it returns the tuple `{:error, reason}`, where the reason is the exception message the function receives. 

### Example

For instance, consider the use case of a logging operation.  Whenever you connect to the database it logs the record count to the console.

```elixir
@doc """ Open Database """
def connect() do

	# Log Operation
	IO.puts("Connecting to Database")

	# Connect to Database
	{:ok, conn} = MarcoPolo.start_link(
			user: "admin",
			password: "admin_passwd",
			connection: {:db, "blog"}) 

	# Log Number of Records
	count = MarcoPolo.db_countrecords(conn, {:timeout 5000})
	IO.puts("Record Count: #{count}")

	# Return Connection
	{:ok, conn}

end
```
