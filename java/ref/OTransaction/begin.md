---
search:
   keywords: ['java', 'otransaction', 'begin']
---

# OTransaction - begin()

Initiates the transaction.

## Beginning Transactions

OrientDB supports the use of transactions to isolate database operations and roll back or save changes once the task is complete. Using this method, you can begin a transaction. To roll it back later, see the [`rollback()`](rollback.md) method.  To save it to the database, see [`commit()`](commit.md) method.


### Syntax

```
void OTransaction().begin()
```

