
# ODatabaseDocument - existsCluster()

Determines whether the given cluster exists on the database.

## Checking Clusters

Clusters are where OrientDB actually stores data.  You can store the data on disk using a physical cluster or you can store it using a volatile in-memory cluster.  In the event that you are not sure whether a cluster exists on the database either at the moment or at that point in the execution of your code, you can use this method to get a `boolean` value telling you whether it's available by name.

### Syntax

```
boolean ODatabaseDocument().existsCluster(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | `String` | The logical name of the cluster |


#### Return Value

This method returns a `boolean` instance.  A value of `true` indicates that the cluster exists on the database.

