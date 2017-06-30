---
search:
   keywords: ['Java API', 'OClass', 'truncate cluster', 'remove cluster data', 'truncateCluster']
---

# OClass - truncateCluster()

This method removes all data from the given cluster.

## Truncating Clusters

Classes can have several clusters that they use to store records.  When your application has been running for a while, you may encounter issues that require basic or drastic housekeeping on class clusters.  Use this method when you need to remove all data from a cluster, such as when the records are obsolete or no longer necessary.

Note that after you call this method, OrientDB needs to rebuild indexes on the class.

### Syntax

```
OClass OClass().truncateCluster(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the cluster you want to truncate |

#### Return Value

This method returns an updated [`OClass`](Java-Ref-OClass.md) instance.



