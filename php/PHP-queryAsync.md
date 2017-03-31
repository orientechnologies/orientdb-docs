---
search:
   keywords: ['PHP', 'PhpOrient', 'asynchronous query', 'query async', 'queryAsync']
---

# PhpOrient - `queryAsync()`

This method issues a query to the database.  For each record the query returns, it executes the given callback function.

## Querying the Database

When issue a query to OrientDB using the [`query()`](PHP-Query.md) method, PhpOrient executes the SQL statement against the open database and then gives you all of the records as a return value.  In cases where this is not the desired result, you can use this method to execute a callback function on each record the query returns.

You may find this useful in cases where you need to initiate certain calculations in advance of the final result, or to log information as the query runs.

### Example

During development, you may find it useful to implement a debugging option that allows you to dump additional information to standard output.  Using this method with the `var_dump()` function, you can display information on records retrieved from the database.

```php
// DEFAULT DEBUG OPTION
$debug = True;

// QUERY DEBUG FUNCTION
function queryDebug(Record $record){

	// LOG OPERATION
	echo "Record Returned:";

	// DUMP RECORD INFORMATION 
	global $debug;
	if ($debug){

		// DUMP RECORD
		var_dump($record);
	}
}

// QUERY DATABASE
function queryDatabase($client, $sql, $fetchPlan){

	// LOG OPERATION
	echo "Querying Database";

	// ISSUE ASYNC QUERY
	$client->queryAsync($sql, 
		['fetch_plan' => $fetchPlan, 
		'_callback' => queryDebug]);
}
```
