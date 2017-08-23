---
search:
   keywords: ['functions', 'database', 'rollback', 'transaction']
---

# Functions - rollback()

This method cancels a transaction within the function, reverting the database to its earlier state.

## Using Transactions

When using a transactional database, which are retrieved using the methods `orient.getGraph()` or `orient.getDatabase()` and not `orient.getGraphNoTx()`, you can manage transactions within your functions.  You may find this useful in situations where you want the function to rollback operations when it encounters conflicts or similar problems.

For more information on transactional methods, see [`begin()`](Functions-Database-begin.md) and [`commit()`](Functions-Database-commit.md). 

### Syntax

```
db.rollback()
```


