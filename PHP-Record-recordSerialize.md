---
search:
   keywords: ['PHP', 'PhpOrient', 'record', 'record serialize', 'recordSerialize']
---

# PhpOrient - `recordSerialize()`

This method returns a serialized instance of the given record.

## Serializing Records

In cases where you want to pass the record instance to another application or would otherwise like to serialize the data, you can do so using this method.  It takes no arguments and returns a serialized instance of the record.  It is similar to the [`jsonSerialize()`](PHP-Record-jsonSerialize.md) method, which serializes the record into JSON data.

### Syntax

```
$record->recordSerialize()
```

### Example

```php
// FETCH SERIAL RECORD
function serialData(Record $record){

	// Fetch Serial Record
	$serial = $record->recordSerialize();
	echo "$serial";
}

// QUERY RECORDS 
function serialRecordsQuery($sql, $fetchplan){

	// Query
	global $client;
	$results = $client->queryAsync($sql,
		['fetch_plan' => $fetchPlan,
		'_callback' => serialData]

	// Return Results
	return $results;
}
```


