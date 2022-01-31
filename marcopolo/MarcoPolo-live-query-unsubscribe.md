
# MarcoPolo - `live_query_unsubscribe()`

This function unsubscribes a receiver from a live query.

## Unsubscribing from Live Queries

When you issue queries using the standard [`command()`](MarcoPolo-command.md) function, what it returns is effectively a snapshot of the records in the state they held when the query was issued.  In the event that another client modifies these records, there's no way you'll know unless you reissue the query.

To get around this limitation, OrientDB provides [Live Queries](../java/Live-Query.md).  Instead of returning records, these queries return a subscription token.  When the records assigned to this token receive an update, OrientDB pushes the changes to the receiver function.

To subscribe to a live query in your Elixir application, use the [`live_query()`](MarcoPolo-live-query.md) function.  This function unsubscribes to the live query.

### Syntax

```
live_query_unsubscribe(<conn>, <token>)
```
- **`<conn>`** Defines the database connection.
- **`<token>`** Defines the live query token.

#### Return Values

This function only returns the value `:ok`.

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


