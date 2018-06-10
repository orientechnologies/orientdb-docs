---
search:
   keywords: ['java','odatabasedocument','countclusterelements']
---

# ODatabaseDocument - countClusterElements()

This method counts all entities in the specified cluster.

## Counting Cluster Elements

A cluster is the physical or in-memory container in which records are stored.  Whenever you create an [`OClass`](Java-Ref-OClass.md) instance, OrientDB simultaneously creates a default [`OCluster`](Java-Ref-OCluster.md) in which to store data of that class.  Often a class will have several clusters, allowing you to better organize the data they contain.  Using this method you can determine the number of records stored in each cluster, as identified by its Cluster ID, (that is, the first number in the Record ID) or by an array of Cluster ID's.

### Syntax

```
long ODatabaseDocument().countClusterElements(int clusterId)
long ODatabaseDocument().countClusterElements(int[] clusterIds)
```

| Argument | Type | Description |
|---|---|---|
| **`clusterId`** | [`int`]({{ book.javase }}/api/java/lang/Integer.html) | Defines the identifier for an individual cluster. |
| **`clusterIds`** | [`int[]`]({{ book.javase }}/java/lang/reflect/Array.html) | Defines the identifiers for an array of clusters. | 

#### Return Value

This method returns a [`long`]({{ book.javase }}/api/java/lang/Long.html) instance.  It represents the number of records counted in the cluster or clusters.



