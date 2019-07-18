---
search:
   keywords: ['java', 'otransaction', 'getnewrecordentriesbyclass']
---

# OTransaction - getNewRecordEntriesByClass()

Retrieves a list of records of the given class added to the database by this transaction.

## Retrieving Records

During transactions you may occasionally or often need to write to the database.  Using this method you can retrieve a list of records modified by the current transaction that belong to the given class.

### Syntax

```
List<ORecordOperation> OTransaction().getNewRecordEntriesByClass(
   OClass class,
   boolean isPolymorphic)
```

| Argument | Type | Description |
|---|---|---|
| **`class`** | [`OClass`](../OClass.md) | Defines the class you want to check for new records |
| **`isPolymorphic`** | `boolean` | Defines whether to check subclasses as well as the given class |

#### Return Value

This method returns a `List` of [`ORecordOperation`](../ORecordOperation.md) instances.  Each instance represents a record updated within the transaction.

