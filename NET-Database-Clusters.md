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
OClusterQuery Clusters(params string[] <cluster-names>)

// CREATING CLUSTERS BY ID
OClusterQuery Clusters(parms short[] <cluster-id>)
```
- **`<cluster-names>`** Defines an array of strings providing the names of the clusters you want to create.
- **`<cluster-ids>`** Defines an array of shorts providing the ID's of the clusters you wannt to create.

### Examples

creating clusters by names

creating clusters by id
