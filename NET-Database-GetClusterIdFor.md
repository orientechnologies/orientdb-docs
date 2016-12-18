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
short GetClusterIdFor(  string <name>)
```

- **`<name>`** Defines the class name.

### Example



