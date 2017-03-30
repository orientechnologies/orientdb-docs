---
search:
   keywords: ['Elixir', 'MarcoPolo', 'create record', 'create_record']
---

# MarcoPolo - `create_record()`

This method create a record on the database, using the given data.

## Creating Records

When you want to create new records, you can build [`Document`](MarcoPolo-Document.md) instances within your Elixir application code and pass it to this method to add it to the database.

### Syntax

```
create_record(<conn>, <cluster-id>, <data>, <opts>)
```

- **`<conn>`** Defines the database connection.
- **`<cluster-id>`** Defines the Cluster you want to use.
- **`<data>`** Defines the data to use in the record.
- **`<opts>`** Defines optional options to pass to the function.  For more information on the available options, see [Options](#options) below.

#### Options

This function takes the following options:

- **`:no_response`** Defines whether the function should wait on a response from the OrientDB Server.  If set `false`, it returns `:ok` regardless of whether or not the operation was successful.

- **`:timeout`** Defines the timeout value in milliseconds.  In the event that the query takes longer than the alloted time, MarcoPolo sends an exit signal to the calling process.


#### Return Values

When the function is successful, it returns the tuple `{:ok, record_info}`.  The `record_info` value is a tuple containing the Record ID and record version.  In the event that the record creation fails, it returns `{:error, term}`.  The `term` variable provides the error message.


### Example

For instance, consider the use case of a web application.  You might want a function to streamline adding new blog entries to the database.

```elixir
@doc """Takes given data and add new blog entry to database"""
def add_blog(conn, author, title, text) do

	# Log Operation
	IO.puts("Adding Blog for User: #{author}")

	# Build Document
	record = %MarcoPolo.Document{class: "BlogEntry",
		fields: %{
			"title" => title,
			"author" => author,
			"text": => text}}

	# Create Record
	case MarcoPolo.create_record(conn, 15, record) do
		{:ok, {record_id, version}} -> IO.puts("Record Created")
		{:error, reason} -> IO.puts("Error: #{reason}")

	end
end
```
