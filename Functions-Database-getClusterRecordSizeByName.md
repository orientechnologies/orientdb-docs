---
search:
   keywords: ['functions', 'database', 'cluster', 'size', 'get cluster size by name', 'getClusterSizeByName']
---

# Functions - getClusterSizeByName()

This method returns the number of records in a cluster identified by its logical name.

## Retrieving Cluster Counts

OrientDB uses clusters to determine where it stores records.  Using this method you can determine the number of records in a cluster.  You may find this useful in any sort of counting function to check and report the size of a cluster.

### Syntax

```
var count = db.getClusterRecordSizeByName(<name>)
```

- **`<name>`** Defines the cluster name.
