---
search:
   keywords: ['functions', 'database', 'cluster']
---

# Functions - browseCluster()

This method returns all records in the given cluster.

## Browsing Clusters

In OrientDB, a cluster defines where the database stores records.  When using a single instance of OrientDB Server, this is whether it's storing the records in memory or where the database looks on your file system.  In distributed deployments, it relates to which server instance has the records you want.

Using this method, you can retrieve all records of a given cluster.  You may find it useful in situations where you use some logical organizational structure for your data.  For instance, if you have an `Account` class for your customers, you might organize clusters by the regions in which you do business.  In a function you might take a zip code as an argument and use some logic to determine which cluster for the `Account` class handles the region in which the user is located, then return all accounts for that region. 

### Syntax

```
var records = db.browseCluster(<name>)
```

- **`<name>`** Defines the cluster name.
