---
search:
   keywords: ['java', 'odatabasedocument', 'cluster name', 'getclusternamebyid']
---

# ODatabaseDocument - getClusterNameById()

Retrieves the cluster name for the given ID. 

## Retrieving Cluster ID's

OrientDB uses two systems to identify clusters.  The first is the Cluster ID, which is represented by the first set of digits in a Record ID.  The second is the logical cluster name.  Using this method, you can retrieve the name for the given ID.  In the event that you have the cluster name and need the ID, use the [`getClusterIdByName()`](getClusterIdByName.md) method.

### Syntax

```
String ODatabaseDocument().getClusterNameById(int id)
```

| Argument | Type | Description |
|---|---|---|
| **`id`** | `int` | Defines the Cluster ID |


#### Return Value

This method returns a `String` value that corresponds to the logical name of the cluster.
