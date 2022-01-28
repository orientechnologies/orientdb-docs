---
search:
   keywords: ['PHP', 'PhpOrient', 'record', 'Record ID', 'get record id', 'getRid']
---

# PhpOrient - `getRid()`

This method returns the Record ID of the given Record object.

## Retrieving Record ID's

In cases where you want to access the Record ID of a given [`Record()`](PHP-Record.md) object, this method allows you to retrieve the [`ID()`](PHP-ID.md) instance from the record.  You can then use this to call additional methods on the Record ID in further operations.


### Syntax

```
$record->getRid()
```

### Example

Consider the use-case of a logging operation tied to an asynchronous query.  As the query runs, each record triggers a callback function.  Using this method, you can fetch the Record ID of each record to echo to the console.

```php
// CALLBACK FUNCTION
function logReturn(Record $record) {

	// Fetch Record ID
	$id = $record->getRid();
	$rid = $id->_toString();

	// Log Operation
	echo 'Retrieved Record: $rid';
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






