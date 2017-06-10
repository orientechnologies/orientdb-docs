---
search:
   keywords: ['Elixir', 'MarcoPolo', 'command', 'query']
---

# MarcoPolo - `command()`

This function executes a query or command on the database.

## Sending Commands

OrientDB SQL differentiates between idempotent queries (such as [`SELECT`](SQL-Query.md) and non-idempotent commands, such as [`INSERT`](SQL-Insert.md).  The MarcoPolo Elixir API does not make this distinction, providing this function for use with both queries and commands..

### Syntax

```
command(<conn>, <query>, <opts>)
```

- **`<conn>`** Defines the database connection.
- **`<query>`** Defines the query or command you want to execute.
- **`<opts>`** Defines additional options to set on the command.  For more information, see [options](#options) below.


#### Options

When issuing queries or commands using this function, there are a series of additional options available to you to further define how MarcoPolo performs the operation.

- **`:params`** Defines a map of parameters for OrientDB to use in building prepared statements.  The map must use atoms or strings as keys, but can take any encodable term as values.

  It defaults to `#{}`

- **`:timeout`** Defines the timeout value in milliseconds.  In the event that the query takes longer than the allotted time, MarcoPolo sends an exit signal to the calling process.

- **`:fetch_plan`** Defines a [fetch plan](Fetching-Strategies.md), which is only available when using this function with idempotent queries.  It is a mandatory argument with fetch queries.


#### Return Values

When the query or command is successful it returns the tuple `{:ok, values}`.  The `values` variable is a map with the following keys:

- **`:response`** Provides the return value given by OrientDB.  This varies depending the query.  For instance, [`SELECT`](SQL-Query.md) returns a list of records, [`CREATE CLUSTER`](SQL-Create-Cluster.md) returns the new cluster's Cluster ID.

- **`:linked_records`** Provides a set of additional records fetched by OrientDB.  The `:fetch_plan` option controls the number of records retrieved to this value. 

In the event that the query or command fails, it returns the tuple `{:error, term}`.  The `term` variable provides the error message.

### Examples


#### Non-idempotent Commands

For instance, in cases where you find yourself making frequent insertions of a particular class, you might want to set up a function to streamline this process and to make it easier to insert a series of records through a single function call.

```elixir
@doc """Inserts records from array into the given class"""
def insert_records(conn, class, properties, records) do

	# Log Operation
	IO.puts("Adding Records to #{class}")
	
	# Build Initial INSERT Statement
	joined_prop = Enum.join(properties, ",")
	insert = "INSERT INTO #{class} (#{joined_prop}) "

	# Loop over Given Records
	for record <- records do

		# Complete INSERT Statement
		data = Enum.join(record, ", ")
		sql = "#{insert} VALUES(#{data})"

		# Issue INSERT Statement
		MarcoPolo.command(conn, sql)

	end
end
```

#### Idempotent Queries 

You might find yourself in similar situations when working with idempotent queries.  For instance, if you frequently query the same class on the database with close or identical options passed to the query, you can save yourself some time by standardizing the process in a function.

```elixir
@doc """ Retrieve User Profile """
def fetch_profile(conn, user) do

	# Log Operation
	IO.puts("Retrieving Profile for User ID: #{uid}"

	# Build SELECT Statement
	select = "SELECT FROM :class WHERE userId=':uid'"

	# Query Database
	options = [params: %{uid: user, class: "Profile"}, fetch_plan: "*:-1"]
	MarcoPolo.command(conn, select, options)
end
```





