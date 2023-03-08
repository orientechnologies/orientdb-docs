
# OClass - addClusterId()

This method adds a cluster to the database class.

## Adding Clusters

When OrientDB saves records, it stores then clusters, using either physical or in-memory storage.  With this method you can add a cluster to the class, defining the cluster by the Cluster ID. 

### Syntax

```
OClass OClass().addClusterId(int name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`Integer`]({{ book.javase }}/api/java/lang/Integer.html) | Defines the Cluster ID |


#### Return Type

This method returns the updated [`OClass`](../OClass.md) instance.

