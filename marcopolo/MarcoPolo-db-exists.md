---
search:
   keywords: ['Elixir', 'MarcoPolo', 'database exists', 'db_exists']
---

# MarcoPolo - `db_exists?()`

This function retunrs a boolean value indicating whether the given database exists on the server.

## Checking Database Existence

Occasionally, you may encounter issues where you aren't certain whether a particular database exists on a server.  This might come up in distributed deployments or similar situations where you have many OrientDB Servers running in different data centers used for various purposes.  This function checks with OrientDB to confirm whether the given database exists on the server.

### Syntax

```
db_exists?(<conn>, <database>, <storage-type>, <opts>)
```

- **`<conn>`** Defines the server connection.
- **`<database>`** Defines the database name.
- **`<storage-type>`** Defines the storage type.  There are two storage types supported:
  - *`:plocal`* Sets the storage-type to PLocal storage.
  - *`:memory`* Sets the storage-type to in-memory storage.
- **`<opts>`** Defines additional options to pass to the function.  For more information on available options, see the [Options](#options) section below.

#### Options

This function supports one additional option:

- **`:timeout`** Defines the timeout value in milliseconds.  In the event that the operation takes longer than the allotted time, MarcoPolo sends an exit signal to the calling process.

#### Return Value

When the operation is successful, the function returns the tuple `{:ok, exists}`, where the variable is a boolean value indicating whether or not the database exists on the server.  In the event that the operation fails, the it returns the tuple `{:error, message}`, where the variable provides the exception message.

### Example

For instance, you might want a functin that integrates the [`create_db()`](MarcoPolo-create-db.md) function with `db_exists?()` function.  This would allow you to create a new database only in cases where one of the same name and type does not already exist.

```elixir
@doc """ Check if Database Exists, Create it if it does not """
def create_db(conn, dbname, type) when type in [:plocal, :memory] do

	# Check Database Existence
	unless MarcoPolo.db_exists?(conn, dbname, type) do

		# Log Operation
		IO.puts("Creating Database: #{dbname}")
		
		# Create Database
		MarcoPolo.db_create(conn, dbname, :document, type)

	end
end 
```

