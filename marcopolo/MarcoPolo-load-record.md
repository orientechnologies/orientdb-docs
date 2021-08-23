
# MarcoPolo - `load_record()`

This function loads a record from the database.

## Loading Records

Eventually, you'll want to operate on records from within your Elixir application.  Using this function, you can retrieve records from the database by their Record ID's.


### Syntax

```
load_record(<conn>, <record-id>, <opts>)
```

- **`<conn>`** Defines the database connection.
- **`<record-id>`** Defines the Record ID.
- **`<opts>`** Defines addtional options for the function.  For more information on the available options, see the [Options](#options) section below.

#### Options

This function supports a series of additional options defined through the final argument.

- **`:fetch_plan`** Defines a [fetch plan](../java/Fetching-Strategies.md). 
- **`:ignore_cache`** Defines whether you want to ignore the cache.  It defaults to `true`.
- **`:load_tombstones`** Defines whether you want to load information on deleted records.  It defaults to `false`.
- **`:if_version_not_latest`** Defines whether you want to load the record in cases where the provided version is not the latest.  This functionality was introduced in version 2.1 of OrientDB. 
- **`:version`** Defines the record version that you want to load.
- **`:timeout`** Defines the timeout value in milliseconds.  In the event that the query takes lnger than the allotted time, MarcoPolo sends an exit signal to the calling process.

#### Return Values

When the operation is successful, the function returns the tuple `{:ok, response}`.  The variable itself is a tuple that contains two elements: the loaded record and the set of records linked to it.  You can control the number and depth of linked records using the `:fetch_plan` option.

In the event that the operation fails, it returns the tuple `{:error, message}`, where the variable provides the exception message.

### Example

Picture an environmental monitoring application where various sensors on write to particular clusters in your database.  For each sensor you have a record defining what it monitors and where it is located, and edges that connect to separate vertices noting the readings taken at particular times.  You might use a function like the below to retrieve histories on particular sensors.

```elixir
@doc """ Retrieves sensor data """
def fetch_data(conn, cluster, id) do

	# Log Operation
	IO.puts("Loading Records")


	# Create Record ID
	rid = MarcoPolo.RID( cluster_id: cluster, position: id)

	# Define Options
	options = [fetch_plan: "*.-1"]

	# Load Record
	MarcoPolo.load_record(conn, rid, options) 

end
```
