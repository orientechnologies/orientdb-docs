---
search:
   keywords: ['java', 'ocluster', 'hiderecord', 'tombstone']
---

# OCluster - hideRecord()

Removes a record from queries without deleting the record from the database.

## Hiding Records

In OrientDB you can remove a record from queries without actually removing the data from the database.  This is done by setting a 'tombstone' on the record, indicating to OrientDB that it should remain hidden.  You may find this useful when implementing a 'trashcan' safety feature, to prevent users from accidentally deleting data from the database.

### Syntax

```
boolean OCluster().hideRecord(long pos)
```

| Argument | Type | Description |
|---|---|---|
| **`pos`** | `long` | The position of the record in the cluster |

#### Return Type

This method returns a `boolean` value, indicating whether the record was successfully hidden.
