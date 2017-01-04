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

For instance, consider the use case of a business application that records data on various accounts, where the accounts are organized by region, with one cluster for each region.  In cases where you want to operate on each region cluster in the database individually, you might use something like this to retrieve them:

```csharp
List<OCluster> clusters;

clusters = database.GetClusters(true);
```

From here you can loop over the `OCluster` objects to perform whatever operations you have in mind.

