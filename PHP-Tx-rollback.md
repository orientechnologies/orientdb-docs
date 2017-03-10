---
search:
   keywords: ['PHP', 'PhpOrient', 'transaction', 'rollback']
---

# PhpOrient - `rollback()`

This method reverts changes made on the current transaction.


## Rolling Back Transactions

In certain situations you may encounter an issue where you need to revert a series of changes already made to the database.  When working with transactions, you can manage this by rolling the database back to its state when the transaction was begun.


### Syntax

```
$tx->rollback()
```

### Example

In the event that you work with transactions often, you might want to put together a routine function to handle commit and rollback operations.

```php
// TX HANDLER
function transactionOp($testResult){

	// Fetch Globals
	global $tx;

	if($testResult){

		// Log Operation
		echo "Commiting Transaction";

		// Commit
		$tx->commit();
	} else {

		// Log Operation
		echo "Rolling Back Transaction";
		$tx->rollback();
	}

}
```

Whenever you're finished with a transaction test it with a boolean operation, then pass the results to this function.  If the test passed, the if statement within this function commits the transaction.  If it failed, it rolls the database back the attached operations. 
