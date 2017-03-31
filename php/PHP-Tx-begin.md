---
search:
   keywords: ['PHP', 'PhpOrient', 'transaction', 'begin']
---

# PhpOrient - `begin()`

This method begins a transaction.

## Beginning Transactions

Once you have the transaction interface initialized through the `getTransactionStatement()` client interface method, using this method you can initialize a transaction statement, using the other methods to attach and commit or revert the changes as need.

### Syntax

```
$tx = $tx->begin()
```

### Example

Consider the use-case of a web application in which you frequently update records as part of a transaction.  You might use a function similar to this to handle both the transaction and update operations together.

```php
// INITIALIZE TRANSACTION INTERFACE
$tx = $client->getTransactionStatement();

// UPDATE RECORD
function updateRecord($class, $data, $rid){

	// Log Operation
	echo "Updating Record";

	// Fetch Globals
	global $client;
	global $tx;

	// Begin Trasnaction
	$tx = $tx->begin();

	// Build Updated Record
	$record = new Record();
	$record->setOClass($class);
	$record->setOData($data);
	$record->setRid($rid);

	// Update Database
	$update = $client->recordUpdate($record);

	// Attach Operation to Transaction
	$tx->attach($update);

	// Commit Changes
	return $tx->commit();
}
```


