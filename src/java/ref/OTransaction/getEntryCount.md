---
search:
   keywords: ['java', 'otransaction', 'getentrycount']
---

# OTransaction - getEntryCount()

Retrieves the number of entries in the transaction.

## Counting Entries

Whenever you execute a statement in a running transaction, the transaction records the entry.  Using this method, you can retrieve a count of the number of entries in the given transaction.

### Syntax

```
int OTransaction().getEntryCount()
```

#### Return Value

This method returns an `int` value, which represents the number of entries in the current transaction.




