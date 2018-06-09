---
search:
   keywords: ['Java', 'ODatabaseDocument', 'transaction', 'rollback']
---

# ODatabaseDocument - rollback() 

This method reverts changes in a transaction, rolling the database back to its previous state. 

## Beginning Transactions

OrientDB supports the use of ACID transactions.   This allows you to isolate database operations into units of work that you can commit or rollback later, depending on whether later conditions are met.  Using this method you can revert changes in a transaction.  To initiate a transaction or commit the changes,  see [`begin()`](Java-Ref-ODatabaseDocument-begin.md) and [`commit()`](Java-Ref-ODatabaseDocument-commit.md) methods.

### Syntax

```
ODatabase<T> ODatabaseDocument.rollback()
```

#### Exceptions

In the event of error, such as the transaction encountering a conflict, this method raises an `OTransactionException` exception.

#### Return Type

This method returns the database instance itself, providing a fluent interface.  This is useful when calling multiple methods in a chain.
