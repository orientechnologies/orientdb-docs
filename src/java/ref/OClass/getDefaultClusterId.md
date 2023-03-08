
# OClass - getDefaultClusterId()

This method retrieves the default Cluster ID for the class.

## Retrieving the Default Cluster ID

When OrientDB stores records it assigns each a Record ID, (for instance #5:24).  The first element of a Record ID provides the Cluster ID, the second the position of the record in the cluster.  Every class has a default cluster, which it uses to store records whenever the target cluster is left unspecified.  Using this method, you can retrieve the Cluster ID for the default cluster.

### Syntax

```
int OClass().getDefaultClusterId()
```

#### Return Value

This method returns an [`int`]({{ book.javase }}/api/java/lang/Integer.html) instance.  It provides the identification number of the default cluster for the class.


