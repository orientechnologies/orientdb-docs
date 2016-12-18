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
string GetClusterNameFor(short <cluster-id>)
```

- **`<cluster-id>`** Defines the Cluster ID you want to query.

### Example

