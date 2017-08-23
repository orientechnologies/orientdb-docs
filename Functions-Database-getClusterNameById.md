---
search:
   keywords: ['functions', 'database', 'cluster', 'get cluster name by id', 'getClusterNameById']
---

# Functions - getClusterNameById()

This method returns the logical cluster name for the given Cluster ID.

## Retrieving Cluster Names

In OrientDB, each record on the database has a numerical identifier called a [Record ID](Concepts.md#record-id), for instance #5:32.  The first element in a Record ID is the Cluster ID, the second element is the record's position in the cluster.  The Cluster ID is an integer used to identify the cluster internally.

Using this method, you can take a given Cluster ID and pass it as an argument to retrieve the logical name for a cluster. You may find it useful when operating on clusters by Cluster ID, as it allows you to fetch a more human readable name for logs.

### Syntax

```
var name = db.getClusterNameById(<id>)
```

- **`<id>`** Defines the Cluster ID.
