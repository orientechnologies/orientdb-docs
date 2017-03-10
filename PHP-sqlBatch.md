---
search:
   keywords: ["PHP", "PhpOrient", "batch", "SQL batch", "sqlbatch"]
---

# PhpOrient - `sqlBatch()`

This method issues [`BATCH`](SQL-batch.md) commands to the database.

## Executing Batch Commands

OrientDB supports the execution of arbitrary scripts written JavaScript with a minimal SQL engine for batch commands.  Using this method, you can execute batch commands through your PhpOrient application.

### Syntax

```
$client->sqlBatch(<batch>)
```

- **`<batch>`** Defines a string containing the commands you want to execute.

### Example

For instance, if you have a series of records that you want to create on the database, you might find it more convenient to manage them through batch commands in a function.

```php
// BATCH CREATION
function batchCreate($records){

	// LOG OPERATION
	echo "Running Batch Command";

	// INITIALIZE BATCH COMMAND
	$batchCmd = "begin; "

	// LOOP THROUGH RECORDS
	foreach($records as $class => $data){

		// INITIALIZE RECORD CREATION
		$create = "insert into $class ";

		// LOOP OVER PROPERTIES
		foreach($data as $property => $value){
			
			// ADD SETTINGS
			$create = "$create set $property = '$value' ";
		}

		// ADD CREATE STATEMENT
		$batchCmd = "$batchCmd $create; ";

	}

	// ADD COMMIT LINE
	$batchCmd = "$batchCmd commit retry 100;";

	// FETCH GLOBAL CLIENT
	global $client;

	// EXECUTE BATCH COMMAND
	$client->sqlBatch($batchCmd);	
}
```

