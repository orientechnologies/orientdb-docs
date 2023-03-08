# OCluster - getTombstonesCount()

Retrieves the number of hidden records in the cluster.

## Hidden Records

In OrientDB it's possible to remove a record from queries without deleting the data from the cluster.  This is done by setting a 'tombstone' on the record.  You may find this useful in cases where you would like to implement a trashcan safety features, where deleted records are hidden for a time before they're permanently removed from the database.  Using this method, you can retrieve the number of tombstone records in the cluster.

### Syntax

```
long OCluster().getTombstonesCount()
```

#### Return Value

This method returns a `long` value, which indicates the number of hidden records in the cluster.

