
# MarcoPolo - Database Operations

OrientDB differentiates between connections made to the database and connections made to the server.  While you can get both from the `start_link()` function in MarcoPolo, which you choose determines the kinds of operations you can perform.  Database operations

## Connecting to the Database

In order to operate on a database, you first need to connnect to it.  To manage this, call the `start_lik()` function with your database credentials, then pass the database name to the `connection:` parameter.  For instance,

```elixir
@doc """ Connect to the given database using default credentials. """
def orientdb_database(user, passwd, dbname) ::
	{:ok, conn} = MarcoPolo.start_link(
		user: user, password: passwd,
		connect: {:db, dbname})
end
```

This function returns a connection interface that you can then pass to other MarcoPolo functions in performing further operations.


## Using Database Connections

When you call the `start_link()` function, it returns a connection interface to your application, which by convention is called `conn` here.  With the connection interface initialized to a particular database, there are a number of operations you can begin to call on the database, by passing the `conn` value to MarcoPolo functions.

```elixir
@doc """ Report the size of the connected database to stdout """
def size_database(conn) do

	# Fetch Size
	size = MarcoPolo.db_size(conn)

	# Log Size
	IO.puts("Database Size: #{size}")
end
```

| Function | Description |
|---|---|
| [`command()`](MarcoPolo-command.md) | Executes a query or command on the database. |
| [`create_record()`](MarcoPolo-create-record.md) | Creates a record. |
| [`db_countrecords()`](MarcoPolo-db-countrecords.md) | Returns the number of records in the database. |
| [`db_reload()`](MarcoPolo-db-reload.md) | Reloads the database. |
| [`db_size()`](MarcoPolo-db-size.md) | Returns the size of the database. |
| [`delete_record()`](MarcoPolo-delete-record.md) | Removes the given record from the database. |
| [`live_query()`](MarcoPolo-live-query.md) | Subscribes to a live query. |
| [`live_query_unsubscribe()`](MarcoPolo-live-query-unsubscribe.md) | Unsubscribes from a live query.|
| [`load_record()`](MarcoPolo-load-record.md) | Loads a record into your application. |
| [`script()`](MarcoPolo-script.md) | Executes a script on the database in the given language. |
| [`stop()`](#closing-connections) | Closes the database connection. |
| [`update_record()`](MarcoPolo-update-record.md) | Updates the given record. |

### Closing Connections

When you're finished using a connection, you can close it to free up resources by calliing the `stop()` function and passing it the connection argument.

For instance, imagine that you have a series of scripts that you need to run on an OrientDB database.  These scripts are used to perform a series of routine maintenance and logging tasks each night, to prepare reports for administrators the following morning.  You might want to set up a dedicated function to manage such operations:

```elixir
@doc """ Runs nightly maintenance scripts """
def maint_nightly(dbname, user, passwd, scripts) do

	# Log Operation
	IO.puts("Running Nightly Maintenance Scripts")

	# Open Connection
	IO.puts("Opening Database: #{dbname}")
	{:ok, conn } = MarcoPolo.start_link(
		user: user,
		password: passwd,
		connect: {:db, dbname})

	# Loop Over Each Script
	for script <- scripts do

		# Execute Script
		case MarcoPolo.script(conn, "JavaScript", script) do
			{:ok, record} -> IO.puts("Script Successful")
			{:error, reason} -> IO.puts("Error: #{reason}")
		end

	end

	# Close Database when Done
	IO.puts("Closing Database: #{dbname}")
	MarcoPolo.stop(conn)

end
```

Bear in mind, the `stop()` function returns `:ok` regardless of whether or not it was successful in closing connection.
