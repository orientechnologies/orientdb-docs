---
search:
   keywords: ['PHP', 'PhpOrient', 'transaction' ]
---

# PhpOrient - Transactions

OrientDB supports transactions, allowing you to organize database operations into units of work that you can then commit or roll back as need.  You may find this useful in cases where you want to provide reliable units of work to allow correct recovery from failures and keep the database consistent or you would like to provide isolation between clients accessing the database concurrently, such as in the case of a web application.

## Using Transactions

Transactions are managed through a transaction interface.  You can initialize this interface using the `getTransactionStatement()` method on the client interface.  For instance,

```php
// Fetch Transaction Interface
$tx = $client->getTransactionStatement();
```

Once you have this interface initialized, there are a series of methods you can call to begin transactions, attach database operations to the transaction, then commit the changes to the database or roll the changes back to the earlier database state.

| Method | Description |
|---|---|
| [`attach()`](PHP-Tx-attach.md) | Attach an operation to the transaction |
| [`begin()`](PHP-Tx-begin.md) | Begin a transaction |
| [`commit()`](PHP-Tx-commit.md) | Commit the transaction |
| [`rollback()`](PHP-Tx-rollback.md) | Roll the transaction back |

Consider the example of a web application.  You might want a dedicated function to handle common operations like updating records in the database.  Using a global transaction interface, you can begin and commit transactions within the function.

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

>For more information, see [Transactions](Transactions.md).
