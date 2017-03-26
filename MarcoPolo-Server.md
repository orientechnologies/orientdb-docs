---
search:
   keywords: ['Elixir', 'MarcoPolo', 'server']
---

# MarcoPolo - Server Operations

OrientDB differentiates between connections made to the database and connections made to the server.  While you can get both from the `start_link()` function in MarcoPolo, which you choose determines the kinds of operations you can perform.  Server operations including creating and dropping databases, and checking that they exist.

## Connecting to the Server

In order to operate on the server, you first need to connect to it.  To manage this, call the `start_link()` function, then pass `:server` to the `connection` parameter.  For instance. 

```elixir
@doc """ Connect to OrientDB Server """
def orientdb_server(user, passwd) ::
	{:ok, conn } = MarcoPolo.start_link(
		user: user, password: passwd, connection: :server)
end
```


## Using Server Connections

When you call the `start_live()` function, it returns a connection interface to your application, which by convention is called `conn` here.  With the connection interface initialized to your OrientDB Server, there are a number of operations that become available by passing the `conn` value to MarcoPolo functions.

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



| Function | Description |
|---|---|
| [`create_db()`](MarcoPolo-create_db.md) | Creates a database. |
| [`db_exists?()`](MarcoPolo-db-exists.md) | Determines if database exists. |
| [`distrib_config()`](MarcoPolo-distrib-config.md) | Fetches distributed server configuration. |
| [`drop_db()`](MarcoPolo-drop-db.md) | Removes a database. |
| [`stop()`](#closing-connections) | Closes the server connection. |

### Closing Connections

When you are finished with a connection, whether the connection interface was opened on a database or a server, you can close the connection and free up resources by calling the `stop()` function.

For instance, consider the use case of a web application that operates on several databases on an OrientDB server.  You might want a function to loop over a series of database names, determining whether or not they exist and creating them where they don't, then close the connection once this operation is complete.

```elixir
@doc """ Takes connection and list of databases and creates those that don't exist. """
def create_databases(user, passwd, databases) do

	# Open Connection
	IO.puts("Connecting to OrientDB Server")
	{:ok, conn} = MarcoPolo.start_link(
		user: user
		password: passwd
		connect: :server)

	# Loop Over Databases
	for db <- databases do

		# Check Existence
		IO.puts("Database Test: #{db}")
		unless MarcoPolo.exists(conn, db, :graph, :plocal) do

			# Create Database
			IO.puts("Database #{db} not found, creating...")
			MarcoPolo.create_db(conn, db, :graph, :plocal)

		end
	end

	# Close Connection
	IO.puts("Closing Server Connection")
	MarcoPolo.stop(conn)

end
```

Bear in mind, the `stop()` function returns `:ok` regardless of whether or not it was successful in closing connection.
