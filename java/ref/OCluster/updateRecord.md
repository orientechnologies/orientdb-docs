---
search:
   keywords: ['java', 'ocluster', 'updaterecord']
---

# OCluster - updateRecord()

Updates the given record with new data.

## Updating Records

When working with clusters, you can update a record through the [`OCluster`](../OCluster.md) instance using this method.

### Syntax

```
void OCluster().updateRecord(
   long pos,
   byte[] content,
   int version,
   byte type)
```

| Argument | Type | Description |
|---|---|---|
| **`pos`** | `long` | Position of record in cluster |
| **`content`** | `byte[]` | Content to set on the record |
| **`version`** | `int` | Version of record to update |
| **`type`** | `byte` | Record type |
