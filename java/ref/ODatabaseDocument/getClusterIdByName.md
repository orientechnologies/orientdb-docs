---
search:
   keywords: ['java', 'odatabasedocument', 'cluster id', 'getclusteridbyname']
---

# ODatabaseDocument - getClusterIdByName()

Retrieves the Cluster ID for the given cluster.

## Retrieving Cluster ID's

OrientDB uses two systems to identify clusters.  The first is the Cluster ID, which is represented by the first set of digits in a Record ID.  The second is the logical cluster name.  Using this method, you can retrieve the Cluster ID for the given cluster name.

### Syntax

```
int ODatabaseDocument().getClusterIdByName(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | `String` | Defines the cluster name |


#### Return Value

This method returns an `int` value, which corresponds to the Cluster ID of the given cluster.
