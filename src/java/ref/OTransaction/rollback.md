
# OTransaction - rollback()

Reverts the transaction to earlier state. 

## Beginning Transactions

OrientDB supports the use of transactions to isolate database operations and roll back or save changes once the task is complete. Using this method, you can roll a transaction back.  To initiate it, see the [`begin()`](begin.md) method.  To save it to the database, see the [`commit()`](commit.md) method.


### Syntax

```
void OTransaction().rollback()

void OTransaction().rollback(boolean force)
```

| Argument | Type | Description |
|---|---|---|
| **`force`** | `boolean` | Defines whether to force the rollback |

