---
search:
   keywords: ['java', 'otransaction', 'commit']
---

# OTransaction - commit()

Commits the transaction to the database.

## Beginning Transactions

OrientDB supports the use of transactions to isolate database operations and roll back or save changes once the task is complete. Using this method, you can commit a transaction. To roll it back later, see the [`rollback()`](rollback.md) method.  To initiate it, see [`begin()`](begin.md) method.


### Syntax

```
void OTransaction().commit()

void OTransaction().commit)(boolean force)
```

| Argument | Type | Description |
|---|---|---|
| **`force`** | `boolean` | Defines whether to force the commit |
