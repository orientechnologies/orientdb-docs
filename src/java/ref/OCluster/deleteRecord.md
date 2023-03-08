
# OCluster - deleteRecord()

Removes the given Record ID from the cluster.

## Removing Records

In OrientDB, the Record ID is composed of two numeric values: the Cluster ID and the record's position in the cluster.  Using this method, you can remove records from the cluster by position.

### Syntax

```
boolean OCluster().deleteRecord(long position)
```

| Argument | Type | Description |
|---|---|---|
| **`position`** | `long` | Position of record to delete |


#### Return Value

This method returns a `boolean` instance.  A value of `true` indicates that the record was successfully deleted.
