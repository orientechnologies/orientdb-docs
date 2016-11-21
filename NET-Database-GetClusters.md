---
search:
   keywords: ['.NET', 'NET', 'C#', 'c sharp', 'OrientDB-NET', 'ODatabase', 'cluster', 'get cluster', 'GetClusters']
---

# OrientDB-NET - `GetClusters()`

This method returns the clusters on the connected OrientDB database.  The return value is a list of `OCluster` objects.

## Retrieving Clusters

### Syntax

```
List<OCluster> GetClusters(bool <reload>)
```

- **`<reload>`** Defines whether you want to reload the `ODatabase` instance before retrieving the clusters.  Defaults to `false`.


### Examples

