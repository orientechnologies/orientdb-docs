
# ODatabaseDocument - getTransaction()

Retrieves the current transaction.

## Fetching Transactions

OrientDB is ACID compliant and supports the use of transactions.  Internally, transactions are tracked using an [`OTransaction`](../OTransaction.md) instance.  Using this method, you can retrieve the active [`OTransaction`](../OTransaction.md) instance.  In the event that no transaction is currently active on the database, this method returns an `OTransactionNoTx` instance.

### Syntax

```
OTransaction ODatabaseDocument().getTransaction()
```

#### Return Value

This method returns an [`OTransaction`](../OTransaction.md) implementation.

