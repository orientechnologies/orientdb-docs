
# ODatabaseDocument - dropCluster()

Removes cluster from the database. 

## Removing Clusters

Clusters represent places on disk or in memory where OrientDB actually stores data.  Using this method, you can remove a cluster from the database.  With physical clusters this completely deletes the cluster and all its data. 

### Syntax

```
boolean ODatabaseDocument().dropCluster(int clusterId, boolean trunc)

boolean ODatabaseDocument().dropCluster(String name, boolean trunc)
```

| Argument | Type | Description |
|---|---|---|
| **`clusterId`** | `Integer` | Defines the Cluster ID |
| **`name`** | `String` | Defines the cluster name |
| **`trunc`** | `boolean` | Defines whether you want to truncate the cluster |

#### Return Value

This method returns a `boolean` value, which indicates whether the cluster was successfully removed.
