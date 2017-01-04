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
OClusterQuery database.Clusters(params string[] <cluster-names>)

// CREATING CLUSTERS BY ID
OClusterQuery database.Clusters(<cluster-id>)
```
- **`<cluster-names>`** Defines a series of strings (`params string[]`) indicating the names of the clusters you want to create.

- **`<cluster-ids>`** Defines a series of numbers (`params short[]`) indicating the ID's of the clusters you want to create.

#### Additional Methods

When you use this method, the return value is an `OClusterQuery` object, which provides additional methods that you may find useful:

- `Count()` This method returns a long value of the created clusters.
- `Range()` This method returns an `ODocument` object of the created clusters.


### Examples

Consider the use case of a business application that stores account information on various clients.  In OrientDB, you have an `Account` class to hold this information, but you would like to use several clusters for different regions.  To initialize OrientDB, your C#/.NET application might use an operation like this:

```csharp
// REGIONS
params string[] regions = ["USEast", "USWest", "USSouth", 
   "EuropeWest", "AsiaEast", "AsiaSouth"];

// CREATE CLUSTERS
long count = database
   .Clusters(regions)
   .Count();
```
Similarly, you might want to create an arbitrary range of clusters by passing a `param` of short values to the same method.

```csharp
// CREATE CLUSTERS
OClusterQuery query = database
   .Clusters(1, 2, 3, 4, 5);
```
