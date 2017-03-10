---
search:
   keywords: ['PHP', 'PhpOrient', 'load record', 'record load', 'recordLoad']
---

# PhpOrient - `reacordLoad()`

This method returns a record from the database.

## Loading Records

In addition to the [`query()`](PHP-Query.md) method, you can also manually select and load records from the database using this method.  Unlike the query, you need to define the record you want using its Record ID, through the `ID()` class.

### Syntax

In OrientDB a RecordID is built from two numeric values: the Cluster ID and the Record Position.  The `ID()` class in PhpOrient provides you with a few different ways to define the particular Record ID that you want to load.

```
// DEFINING RECORD ID AS STRING 
$client->recordLoad(new ID('<record-id>'))

// DEFINING CLUSTER AND POSITION AS ARGUMENTS
$client->recordLoad(new ID(<cluster-id>, <record-position>))

// DEFINING CLUSTER AND POSITION WITH ARRAY
$client->recordLoad(new ID(['cluster' => <cluster-id>, 
							'position' => <record-position>]))
```

- **`<record-id>`** Defines the Record ID that you want to return.
- **`<cluster-id>`** Defines the Cluster ID to search.
- **`<record-position>`** Defines the record's position in the cluster.

When successful, this method returns an array with a single entry. In order to access the reocrd itself, you need to add a call to the 0 position at the end of the method, for instance:

```php
$record = $client->recordLoad(new ID('#3:22'))[0]
``` 

### Examples

For instance, if you find yourself frequently loading records by Record ID, you might want to build a function that retrieves an array of record ID's.

```php
// FETCH RECORDS
function fetchRecords($client, $ridArray){

	// LOG OPERATION
	echo "Retrieving Records";

	// INITIALIZE ARRAY
	$records = array();

	// LOOP OVER RID'S
	foreach($rid in $ridArray){

		// FETCH RECORD
		$record = $client->recordLoad(new ID($rid))[0];
		
		// APPEND ARRAY
		array_push($records, $record);
	}

	// RETURN RECORDS
	return $records;

}
```


#### Loading Records with Callback Function

Similar to the [`queryAsync()`](PHP-queryAsync.md) method, you can define a [fetching strategy](Fetching-Strategies.md) and callback function.  You can manage these features by passing a mapped array as the second argument to the method.

For instance, during development you might want to call the `var_dump()` function for each record the method returns.

```php
// DEFAULT DEBUG OPTION
$debug = True;

// QUERY DEBUG FUNCTION
function queryDebug(Record $record){

	// LOG OPERATION
	echo "Record Returned:";

	// DUMP RECORD INFORMATION
	global $debug;
	if ($debug) {
		
		// DUMP RECORD
		var_dump($record);
	}
}

// QUERY DATABASE
function queryDatabase($client, $rid, $fetchPlan){

	// LOG OPERATION
	echo "Loading Record: $rid";

	// LOAD RECORD
	$record = $client->recordLoad(
		new ID($rid), 
		['fetch_plan' => $fetchPlan,
		 '_callback' => $queryDebug]);

	// RETURN RECORD
	return $record;
}
```
