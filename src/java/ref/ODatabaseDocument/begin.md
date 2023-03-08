---
search:
   keywords: ['Java API', 'ODatabaseDocument', 'begin', 'transaction']
---

# ODatabaseDocument - begin()

This method initiates a transaction on the database.

## Beginning Transactions

OrientDB supports the use of ACID transactions.   This allows you to isolate database operations into units of work that you can commit or rollback later, depending on whether later conditions are met.  Using this method you can intiate a transaction.  To save a transaction or revert the changes,  see [`commit()`](commit.md) and [`rollback()`](rollback.md) methods.

### Syntax

```
ODatabase<T> ODatabaseDocument.begin()
```

#### Return Type

This method returns the database instance itself, providing a fluent interface.  This is useful when calling multiple methods in a chain.
