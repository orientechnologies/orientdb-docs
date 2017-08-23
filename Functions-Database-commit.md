---
search:
   keywords: ['functions', 'database', 'commit', 'transaction']
---

# Functions - commit() 

This method commits a transaction within the function.

## Using Transactions

When using a transactional database, which are retrieved using the methods `orient.getGraph()` or `orient.getDatabase()` and not `orient.getGraphNoTx()`, you can manage transactions within your functions.  You may find this useful in situations where you want the function to rollback operations when it encounters conflicts or similar problems.

For more information on transactional methods, see [`begin()`](Functions-Database-begin.md) and [`rollback()`](Functions-Database-rollback.md).

### Syntax

```
db.commit()
```


