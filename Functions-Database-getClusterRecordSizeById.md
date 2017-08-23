---
search:
   keywords: ['functions', 'count', 'cluster', 'getClusterRecordSizeById']
---

# Functions - getClusterRecordSizeById()

This method returns the number of records in a cluster identified by its Cluster ID.

## Retrieving Cluster Counts

OrientDB uses clusters to determine where it stores records.  Using this method you can determine the number of records in a cluster.  You may find this useful in any sort of counting function to check and report the size of a cluster.

### Syntax

```
var size = db.getClusterRecordsById(<id>)
```

- **`<id>`** Defines the Cluster ID.
