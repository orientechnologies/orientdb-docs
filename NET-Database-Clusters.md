---
search:
   keywords: ['NET', 'C#', 'ODatabase', 'cluster']
---

# OrientDB-NET - `Clusters()`

This method adds clusters to the OrientDB database.  The return value is an `OClusterQuery` object.

## Creating Clusters

### Syntax

```
// CREATING CLUSTERS BY NAME
OClusterQuery Clusters(params string[] <cluster-names>)

// CREATING CLUSTERS BY ID
OClusterQuery Clusters(parms short[] <cluster-id>)
```
- **`<cluster-names>`** Defines an array of strings providing the names of the clusters you want to create.
- **`<cluster-ids>`** Defines an array of shorts providing the ID's of the clusters you wannt to create.
