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
List<OCluster> ODatabase.GetClusters(bool reload)
```

- **`reload`** Defines whether you want to reload the `ODatabase` instance before retrieving the clusters.  Defaults to `false`.


### Examples

For instance, as part of a logging operation, you might build a helper function to retrieve the available clusters from the database and to print their names to the console, before returning them for further operations.

```csharp
using Orient.Client;
using System;

public List<OCluster> FetchClusters(ODatabase database,
    bool reload = false)
{
  // FETCH CLUSTERS
  List<OCluster> clusters = database.GetClusters(reload);

  // INITIALIZE CLUSTER NAMES LIST
  List<string> clusterNames;
  foreach(OCluster cluster in clusters)
  {
     // ADD CLUSTER NAME
     clusterNames.Add(cluster.Name);
  }

  // LOG TO CONSOLE
  Console.WriteLine("Retrieved Clusters: {0}",
    String.Join(', ', clusterNames));

  // RETURN CLUSTERS
  return clusters;
}
```
