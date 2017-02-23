---
search:
   keywords: ['NET', '.NET', 'C#', 'c sharp', 'OrientDB-NET', 'cluster', 'get cluster id', 'GetClusterIdFor', 'ODatabase']
---

# OrientDB-NET - `GetClusterIdFor()`

This method retrieves the default Cluster ID for a given class.  The return value is a `short`.

## Retrieving Cluster ID's

While cluster names are easier for people to understand and keep track of, you may occasionally find it more efficient and performant to work with cluster ID's in these operations.  Using the `GetClusterIdFor()` method, you can retrieve the short ID for a given cluster.

It is comparable to the [`GetClusterNameFor()`](NET-Database-GetClusterNameFor.md) method.

### Syntax

```
short ODatabase.GetClusterIdFor(  string <name>)
```

- **`<name>`** Defines the class name.

### Example

For instance, if you prefer operating on clusters by their ID's rather than names, you may find it convenient to create a helper function to retrieve the Id's for a group of cluster names.

```csharp
using Orient.Client;
using System;
...

// FETCH CLUSTER ID'S
public List<short> fetchClusterIds(ODatabase database, string[] clusterNames)
{
   // LOG OPERATION
   Console.WriteLine("Retrieving ID's for clusters: {0}",
      String.Join(", ", clusterNames));

   // INITIALIZE RETURN VARIABLE
   List<short> clusterIDs;

   // LOOP OVER NAMES
   foreach(string name in clusterNames)
   {
      // FETCH CLUSTER ID
      short clusterID = database.GetClusterIdFor(name);

      // APPEND ID TO RETURN VALUE
      clusterIDs.Add(clusterID)
   }

   // RETURN CLUSTER ID'S
   return clusterIDs;
}
```
