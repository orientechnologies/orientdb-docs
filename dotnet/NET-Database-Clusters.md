---
search:
   keywords: ['NET', 'C#', 'ODatabase', 'cluster']
---

# OrientDB-NET - `Clusters()`

This method adds clusters to the OrientDB database.  The return value is an `OClusterQuery` object.

## Creating Clusters

To create clusters on the database, you need to call the `Clusters()` method on the `ODatabase` interface.  In order to do so, you need to pass it an array of cluster names or ID's that you want to add to the database.

### Syntax

```
// CREATING CLUSTERS BY NAME
OClusterQuery ODatabase.Clusters(params string[] clusterNames)

// CREATING CLUSTERS BY ID
OClusterQuery ODatabase.Clusters(params short[] clusterId)
```
- **`cluster-names`** Defines a series of strings (`params string[]`) indicating the names of the clusters you want to create.

- **`cluster-ids`** Defines a series of numbers (`params short[]`) indicating the ID's of the clusters you want to create.

#### Additional Methods

When you use this method, the return value is an `OClusterQuery` object, which provides additional methods that you may find useful:

- `Count()` This method returns a long value of the created clusters.
- `Range()` This method returns an `ODocument` object of the created clusters.


### Examples

For instance, you might use this method in building a wrapper function to add clusters to the database.  Using the wrapper you can extend the method with additional logic to log information to the console or perform further operations on the newly created clusters.

```csharp
using Orient.Client;
using System;
...

public void createCluster(ODatabase database, 
      params string[] clusters)
{
   // LOG TO CONSOLE
   Console.Write("Creating Clusters: {0}",
      String.Join(", ", clusters));

   // CREATE CLUSTERS
   OClusterQuery clusterQuery = database.Clusters(clusters);

   // FETCH COUNT
   long count = clusterQuery.Count();

   // LOG TO CONSOLE
   Console.Write("Created {0} clusters", count);
}
```

Similarly, you might want to create an arbitrary range of clusters by passing a `param` of short values to the same method.


```csharp
// INITIALIZE CLUSTER ID's
params short[] clusterIds = [1, 2, 3, 4, 5]

// CREATE CLUSTERS
OClusterQuery query = database.Clusters(clusterIds);
```
