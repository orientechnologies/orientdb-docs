---
search:
   keywords: ['functions', 'database', 'clusters', 'cluster id', 'get cluster id by name', 'getClusterIdByName']
---

# Functions - getClusterIdByName()

This method retrieves the Cluster ID for the given cluster name.

## Retrieving Cluster ID's

In OrientDB, each record on the database has a numerical identifier called a [Record ID](Concepts.md#record-id), for instance #5:32.  The first element in a Record ID is the Cluster ID, the second element is the record's position in the cluster.  The Cluster ID is an integer used to identify the cluster internally.

Using this method, you can pass a cluster's name as a string and retrieve the integer for the Cluster ID.  You may find this useful in any operation where you need the Cluster ID as an argument.

### Syntax

```
var clusterId = db.getClusterIdByName(<name>)
```

- **`<name>`** Defines the cluster name.
