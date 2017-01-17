---
search:
   keywords: [ 'NET', '.NET', 'OrientDB-NET', 'C#', 'c sharp', 'ODatabase', 'cluster', 'get cluster name', 'GetClusterNameFor']
---

# OrientDB-NET - `GetClusterNameFor()`

This method retrieves the name of a cluster for the given Cluster ID.  The return value is a string.

## Retrieving Cluster Names

While Cluster ID's may prove easier and more performant for your application to operate on, their meaning and purpose is not always clear for the programmer or when writing to logs.  To retrieve the cluster name from an ID, use the `GetClusterNameFor()` method on the `ODatabase` interface.

It is comparable to the [`GetClusterIdFor()`](NET-Database-GetClusterIdFor.md) method.

### Syntax

```
string ODatabase.GetClusterNameFor(short <cluster-id>)
```

- **`<cluster-id>`** Defines the Cluster ID you want to query.

### Example

For instance, if you prefer operating on clusters by their ID's rather than names, you may find it convenient to create a helper function to retrieve cluster names from a list of cluster ID's.

```csharp
using Orient.Client;
using System;
...

// FETCH CLUSTER NMAES
public List<string> fetchClusterNames(ODatabase database, short[] clusterIDs)
{
   // LOG OPERATION
   Console.WriteLine("Retrieve Names for Clusters: {0}",
      String.Join(", ", clusterIDs));

  // INITIALIZE RETRUN VALUE
  List<string> clusterNames;

  // LOOP OVER ID'S
  foreach(short clusterID in clusterIDs)
  {
    // FETCH CLUSTER NAME
    string clusterName = database.GetClusterNameFor(clusterID);

    // APPEND NAME TO RETURN VALUE
    clusterNames.Add(clusterName);
  }

  // RETURN CLUSTER NAMES
  return clusterNames;
}
```
