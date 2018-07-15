---
search:
   keywords: ['java', 'odatabasedocument', 'truncatecluster']
---

# ODatabaseDocument - truncateCluster()

Removes all data from the given cluster.

## Truncating Cluster

On occasion you may find yourself in a situation where you need to remove data from a cluster without removing the cluster itself.  This is common in cases where the cluster was loaded with data during testing and now needs to be cleared for use in production.  Using this method you can truncate the cluster, deleting data without deleting the cluster.

### Syntax

```
void ODatabaseDocument().truncateCluster(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | `String` | Logical name of the cluster |



