---
search:
   keywords: ['PHP', 'PhpOrient', 'transaction', 'commit']
---

# PhpOrient - `commit()`

This method commits operations attached to the transaction to the database.

## Committing Transaction

When you're finished with a transaction and satisfied with the changes you've made to it, you need to commit the changes to the database to make them persistent.  This method commits all attached operations.

### Syntax

```
$tx->commit()
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


