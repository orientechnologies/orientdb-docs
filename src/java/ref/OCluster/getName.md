
# OCluster - getName()

Retrieves the logical name of the cluster.

## Retrieving the Cluster Name

When you create a cluster on a database, OrientDB uses two reference values to identify it later: an integer that represents the Cluster ID and a string that provides its logical name.  Using this method you can retrieve the logical name for the cluster. 

### Syntax

```
String OCluster().getName()
```

#### Return Value

This method returns a `String` value that provides the logical name for the cluster.


