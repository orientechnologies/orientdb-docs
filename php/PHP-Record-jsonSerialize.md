---
search:
   keywords: ['PHP', 'PhpOrient', 'record', 'serialize', 'json serialize', 'jsonSerialize']
---

# PhpOrient - `jsonSerialize()`

This method returns the record serialized in JSON format.

## Serializing Records

In some cases, you may find it more convenient to operate on a record in JSON format rather than the standard format provided by PhpOrient.  Alternatively, you may want to save JSON instances of records for backup or logging purposes.  This method takes no arguments and returns a JSON instance of the record.  It is similar to the [`recordSerialize()`](PHP-Record-recordSerialize.md) method.

### Syntax

```
$record->jsonSerialize()
```

### Example

For instance, you might want to use this method as part of a logging operation, echoing a JSON instance of the record to the console on asynchronous queries.

```php
// LOG QUERY
function logQuery(Record $record){

	// Fetch JSON
	$json = $record->jsonSerialize();

	// Log to Console
	echo "$json";
}

// ASYNC QUERY
function query($sql, $fetchPlan){

	// Query Database
	global $client;
	$results = $client->queryAsync($sql,
		['fetch_plan' => $fetchPlan,
		'_callback' => logQuery ]);

	// Return Results
	return $results;
}
```
