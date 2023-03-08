
# OCluster - truncate()

Deletes cluster content without deleting the cluster. 

## Truncating Clusters

Occasionally, you may find yourself in situations where you need to remove data from the cluster without removing the cluster itself.  Using this method, you can truncate the cluster, just as you would in OrientDB SQL using the [`TRUNCATE CLUSTER`](../../../sql/SQL-Truncate-Cluster.md) statement.

### Syntax

```
void OCluster().truncate()
```

