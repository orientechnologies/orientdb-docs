---
search:
   keywords: ['MarcoPolo', 'Elixir', 'server', 'create database', 'create_db']
---

# MarcoPolo - `create_db()`

This function creates a database on the connected OrientDB Server.

## Creating Databases

While it is possible to connect your Elixir application to an existing database on the OrientDB Server, it is more likely that you'll want to create databases dynamically from within your application.  The `create_db()` takes the connection interface, database name and database options, then creates a database on the Server.  In the event that there is a problem it returns an error message.

### Syntax

```
create_db(<conn>, <name>, <database-type>, <storage type>, <opts>)
```

- **`<conn>`** Provides the server connection.
- **`<name>`** Defines the database name.
- **`<database-type>`** Defines the database-type.  Supported types are,
  - *`:document`* Creates a Document database.
  - *`:graph`* Creates a Graph database.
- **`<storage type>`** Defines the storage-type.  Supported types are,
  - *`:plocal`* Sets to the PLocal storage-type.
  - *`:memory`* Sets to the in-memory storage-type.
- **`<opts>`** Used for any additional keyword options passed to the function. 

#### Options

This function supports one additional option:

- **`:timeout`** Defines the timeout value in milliseconds.  In the event that the operation takes longer than the allotted time, MarcoPolo sends an exit signal to the calling process.


#### Return Values

When the function is successful, it returns `:ok`.  In the event that there is a problem, it returns `{:error, term}`, where `term` is the error message.


### Example

For instance, you might want a function that integrates the `create_db()` function with the [`db_exists?()`](MarcoPolo-db-exists.md) function.  This would allow you to create a new database only in cases where one of the same name and type does not already exist.

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

