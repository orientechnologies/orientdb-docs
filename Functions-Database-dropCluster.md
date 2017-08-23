---
search:
   keywords: ['functions', 'drop cluster', 'remove cluster', 'dropCluster']
---

# Functions - dropCluster()

Removes the given cluster from the database.

## Removing Clusters

Clusters define where in the database OrientDB stores records.  They can be persistent and written to disk or volatile and stored in memory.  The first number in a Record ID refers to the Cluster ID, an integer used to identify the cluster internally.  Using this method, you can remove a cluster from the database.  You can also define whether you want to remove the cluster outright or only remove records from the cluster.

### Syntax

```
db.dropCluster(<cluster-id>, <truncate>)
```

- **`<cluster-id>`** Defines the Cluster ID.
- **`<truncate>`** Defines whether you want to truncate the cluster rather than removing it.  Truncating means that you remove the records from the cluster, while leaving it configured on the database for later use.

