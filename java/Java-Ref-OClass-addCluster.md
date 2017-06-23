---
search:
   keywords: ['Java API', 'OClass', 'cluster', 'add cluster', 'addCluster']
---

# OClass - addCluster()

This method adds a cluster to the database class.

## Adding Clusters

When OrientDB saves records, it stores then clusters, using either physical or in-memory storage.  With this method you can add a cluster to the class. 

### Syntax

```
OClass OClass().addCluster(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the cluster name |


#### Return Type

This method returns the updated [`OClass`](Java-Ref-OClass.md) instance.

