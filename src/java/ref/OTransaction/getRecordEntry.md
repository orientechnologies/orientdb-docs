
# OTransaction - getRecordEntry()

Returns a record from the transaction.

## Retrieving Records

Using this method you can retrieve records from this transaction to further operate on them.  The record you want is identified by the given Record ID.

### Syntax

```
ORecordOperation OTransaction().getRecordEntry(ORID rid)
```

| Argument | Type | Description |
|---|---|---|
| **rid** | [`ORID`](../ORID.md) | Defines the record you want. |

#### Return Type

This method returns an [`ORecordOperation`](../ORecordOperation.md) instance for the requested record.



