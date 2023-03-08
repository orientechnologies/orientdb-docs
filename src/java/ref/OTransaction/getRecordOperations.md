
# OTransaction - getRecordOperations()

Retrieves all the records from the transaction.

## Retrieving Record Operations

The transaction keeps track of the operations you perform on database records.  Using this method, you can retrieve all the record operations in the given transaction to further operate on them.

### Syntax

```
Iterable<? extends ORecordOperation> OTransaction().getRecordOperations()
```

#### Return Value

This method returns an `Iterable` instance that contains an [`ORecordOperation`](../ORecordOperation.md) for the records modified by the transaction.







