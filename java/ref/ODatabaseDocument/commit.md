---
search:
   keywords: ['Java', 'ODatabaseDocument', 'transaction', 'commit']
---

# ODatabaseDocument - commit() 

This method saves changes made in a transaction onto the database.

## Beginning Transactions

OrientDB supports the use of ACID transactions.   This allows you to isolate database operations into units of work that you can commit or rollback later, depending on whether later conditions are met.  Using this method you can commit a transaction.  To initiate a transaction or revert the changes,  see [`begin()`](Java-Ref-ODatabaseDocument-begin.md) and [`rollback()`](Java-Ref-ODatabaseDocument-rollback.md) methods.

### Syntax

```
ODatabase<T> ODatabaseDocument.commit()
```

#### Exceptions

In the event of error, such as the transaction encountering a conflict, this method raises an `OTransactionException` exception.

#### Return Type

This method returns the database instance itself, providing a fluent interface.  This is useful when calling multiple methods in a chain.
