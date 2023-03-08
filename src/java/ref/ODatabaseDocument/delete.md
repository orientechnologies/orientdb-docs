---
search:
   keywords: ['java', 'odatabasedocument', 'delete', 'delete record']
---

# ODatabaseDocument - delete()

This method removes the given record from the database.

## Removing Records

Using this method you can remove a record from the database, as defined by its Record ID.

### Syntax

```
ODatabase<T> ODatabaseDocument().delete(ORID rid)
```

| Argument | Type | Description |
|---|---|---|
| **`rid`** | [`ORID`](../ORID.md) | Record ID to delete |

#### Return Type

The method returns the database instance itself, providing a fluent interface, (which you may find useful when calling multiple methods in a chain).

