---
search:
   keywords: ['.NET', 'NET', 'C#', 'c sharp', 'OrientDB-NET', 'ODatabase', 'cluster', 'get cluster', 'GetClusters']
---

# OrientDB-NET - `GetClusters()`

This method returns the clusters on the connected OrientDB database.  The return value is a list of `OCluster` objects.

## Retrieving Clusters

In cases where you need to operate on many, most or all clusters in a database, you may find it more efficient to retrieve all `OCluster` objects in a single call.  You can do so using the `GetClusters()` method.

### Syntax

```
List<OCluster> GetClusters(bool <reload>)
```

- **`<reload>`** Defines whether you want to reload the `ODatabase` instance before retrieving the clusters.  Defaults to `false`.


### Examples

