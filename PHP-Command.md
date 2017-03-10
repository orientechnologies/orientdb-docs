---
search:
   keywords: ['PHP', 'PhpOrient', 'database', 'command']
---

# PhpOrient - `command()`

This method issues an [SQL](SQL.md) command to the database.

## Sending Commands

In certain situations, you may find it more convenient or preferable to issue commands to the database using SQL rather than PhpOrient methods.  Use this method only to perform non-idempotent commands.

### Syntax

```
$client->command(<sql>)
``` 

- **`<sql>`** Defines the SQL command to run.

### Example

For instance, if you find yourself frequently inserting complex data into your database, you might want to develop a function that takes the client interface, class, and an array mapping property names to values.

```php
function insertData($client, $class, $dataArray){

	// CONSTRUCT BASE SQL INSERT STATEMENT
	$sql = 'INSERT INTO $class';

	// LOOP IN DATA VALUES FROM ARRAY
	foreach($dataArray as $property => $value) {

		// ADD INSERT
		$sql = '$sql SET $property = \'$value\'';
	}

    // ISSUE COMMAND
	$client->command($sql);
}
```

Here, your function constructs an [`INSERT`](SQL-Insert.md) statement from the given array, then issues the command to OrientDB.
