---
search:
   keywords: ['java', 'otransaction', 'getinvolvedindexes']
---

# OTransaction - getInvolvedIndexes()

Retrieves a list of indexes involved in the transaction.

## Getting Indexes

When you add a query or command to a transaction, the transaction keeps a record of the indexes called.  Using this method you can retrieve a list of all the indexes involved in the transaction.

### Syntax

```
List<String> OTransaction().getInvolvedIndexes()
```

#### Return Value

This method returns a `List` of `String` values, each `String` representing an involved index.


