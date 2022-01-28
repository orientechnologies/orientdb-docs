---
search:
   keywords: ['PHP', 'PhpOrient', 'record', 'class', 'get class', 'getOClass']
---

# PhpOrient - `getOClass()`

This method retrieves the OrientDB class for the record.

## Retrieving Classes

In cases where you want to access the class for the given `Record()` instance, this method returns the class name.  You might find it useful in cases such as logging operations, where you would like to report the specific class rather than its Record ID.

### Syntax

```
$record->getOClass()
```

### Example

Consider the use-case of a logging operation tied to the callback function for an asynchronous query.  For each record the query returns, it calls a function that logs the class that it's operating on.

```php
// CALLBACK FUNCTION
function logReturn(Record $record){
	// Fetch Record ID
	$rid = $record->getRid()->_toString();

	// Fetch Class
	$class = $record-getOClass();

	// Log Operation
	echo "Retrieving $class Record: $rid";
}

// ASYNCHRONOUS QUERY
function runQuery($sql, $fetchPlan){

	// Fetch Global
	global $client;

	// Run Query
	$results = $client->queryAsync($sql,
		['fetch_plan' => $fetchPlan,
		'_callback' => logReturn]);

	// Return Results
	return $results;
}
```


