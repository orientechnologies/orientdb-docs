
# OTransaction - amountOfNestedTxs()

Returns the number of transactions nested in the current instance.

## Nesting Transactions

OrientDB does not support nested transactions.  Instead, further calls to [`begin()`](begin.md) are applied to the current transaction, which keeps track of the call stack to let the final [`commit()`](commit.md) commit the transaction.  Using this method, you can see how many transactions have been set on this [`OTransaction`](../OTransaction.md) instance.

### Syntax

```
int OTransaction().amountOfNestedTxs()
```

#### Return Value

This method returns an `int`, which represents the number of nested transactions.
