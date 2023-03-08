---
search:
   keywords: ['java', 'otransaction', 'odatabasedocument', 'getdatabase']
---

# OTransaction - getDatabase()

Retrieves the database on which the transaction is running.

## Getting Databases

Transactions run on particular databases, or more specifically within an [`ODatabaseDocument`](../ODatabaseDocument.md) instance.  In the event that you need to operate on the database currently running the transaction, you can use this method to retrieve it.

### Syntax

```
ODatabaseDocument OTransaction().getDatabase()
```

#### Return Value

This method returns an [`ODatabaseDocument`](../ODatabaseDocument.md) instance, which represents the database on which the transaction is running.
