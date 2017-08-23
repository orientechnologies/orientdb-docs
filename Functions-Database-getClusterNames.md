---
search:
   keywords: ['functions', 'database', 'get cluster names', 'getClusterNmaes']
---

# Functions - getClusterNames()

This method retrieves the names of all clusters in the database.

## Retrieving Cluster Names

In OrientDB, a cluster defines where the database stores records.  When using a single instance of OrientDB Server, this is whether it's storing the records in memory or where the database looks on your file system.  In distributed deployments, it relates to which server instance has the records you want.

Using this method you can retrieve the names of all clusters configured on your database.  You may find this useful in functions where you need to operate over several clusters at a time or check for several in particular.

### Syntax

```
var names = db.getClusterNames()
```
