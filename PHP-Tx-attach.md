---
search:
   keywords: ['PHP', 'PhpOrient', 'transaction', 'attach']
---

# PhpOrient - `attach()`

This method attaches the given database operation to a transaction.

## Attaching Operations

In building transactions, you can attach specific operations to the given transaction.  This allows you to later commit the transactions to the database or roll the changes back to an earlier state.

### Syntax

```
$tx->attach(<operation>)
```

- **`<operation>`** Defines the operation to attach.

### Example

For instance, imagine a web application that handles blog entries.  With multiple users connecting to the application and attempting to update the database.  Using transactions, you can isolate the changes they make to the database to help avoid conflicts.

```php
// CREATE RECORDS
function createRecord($class, $records){

	// Log Operation
	echo "Creating Record";

	// Fetch Global Variables
	global $client;
	global $tx;

	// Begin Transaction
	$tx = $tx->begin()

	// Loop Over Record Data
	foreach($records as $record){

		// Create Record
		$createdRecord = $client->recordCreate(
			(new Record())
				->setOClass($class)
				->setOData($data)
				->setRid(new ID())
		);	

		// Attach Operation to Transaction
		$tx->attach($createdRecord);
	}

	// Commit Changes
	$tx->commit();
}
```
