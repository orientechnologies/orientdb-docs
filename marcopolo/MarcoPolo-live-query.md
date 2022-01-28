---
search:
   keywords: ['Elixir', 'MarcoPolo', 'live query', 'subscribe', 'live_query']
---

# MarcoPolo - `live_query()`

This function subscribes to a [live query](../java/Live-Query.md)

## Subscribing to Live Queries

When you issue queries using the stnadrd [`command()`](MarcoPolo-command.md) function, what it returns is effectively a snapshot of the records in the state they held when the query was issued.  In the event that another client modifies these records, there's no way you'll know unless you reissue the query. 

To get around this limitation, OrientDB provides Live Queries.  Instead of returning records, these queries return a subscription token.  When the records assigned to this token recieve an update, OrientDB pushes the changes to the given receiver function. 

This function subscribes to live queries.  When you're finished with the live query, you can call the [`live_query_unsubscribe()`](MarcoPolo-live-query-unsubscribe.md) function to deregister the token.

### Syntax

```
live_query(<conn>, <query>, <receiver>, <opts>)
```

- **`<conn>`** Defines the database connection.
- **`<query>`** Defines the query.
- **`<receiver>`** Defines the function to receive the records
- **`<opts>`** Defines additional options for the function.  For more information, see [Options](#options).

#### Options

This function can take one additional option: 

- **`:timeout`** Defines the timeout value in milliseconds.  In the event that the operation takes longer than the allotted time, MarcoPolo sends an exit signal to the calling process.

#### Return Value

When this operation is successful, it returns the tuple `{:ok, token}`, where the variable is a subscription token, which OrientDB uses to register any changes made to the records the query returns.  You can use this token with the [`live_query_unsubscribe()`](MarcoPolo-live-query-unsubscribe.md) function when you're ready to unsubscribe.

In the event that the operation fails, it returns `{:error, message}`, where the variable provides the exception message.

### Example

Imagine you have an application that handles monitoring for various environmental sensors.  Every fifteen minutes your application calls a series of functions to update the OrientDB database.  You might use a Live Query to test whether the sensor reading has met an alert condition, causing the application to send emails or text messages to on-call operators.  After a given timeout interval, the query resets itself, unsubscribing from the given Live Query.

```elixir
@doc """ Check Readings for Alert Conditions """
def check_readings(record) do

	# Retrieve Data
	data = record.fields["reading"]

	if data >= threshold do

		# Log Alert
		IO.puts("Alert Condition: #{data}")

		# Call Notification Function
		notify_operator(record)

	end
end

@doc """ Handler for monitor function check_readings() """
def read_handler(conn, sensor, interval) do

	# Log Operation
	IO.puts("Initializing #{sensor} Monitor")

	# Call Live Query
	{:ok, token } -> MarcoPolo.live_query(conn,
		"LIVE SELECT FROM Sensors WHERE sensor_name = '#{sensor}'",
		check_readings)

	# Wait Interval
	Process.sleep(interval)

	# Unsubscribe and Restart Monitor
	MarcoPolo.live_query_unsubscribe(token)

	# Recursive Restart 
	read_handler(conn, sensor, interval)

end
```



