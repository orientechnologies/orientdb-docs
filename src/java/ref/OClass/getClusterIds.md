
# OClass - getClusterIds()

This method retrieves the ID's for all clusters registered with the class.

## Retrieving Cluster ID's

When OrientDB stores records it assigns each a Record ID, (for instance #5:24).  The first element of a Record ID provides the Cluster ID, the second the position of the record in the cluster. Using this method you can retrieve the ID's for all clusters registered with the [`OClass`](../OClass.md) instance. 

### Syntax

```
int[] OClass().getClusterIds()
```

#### Return Value

This method returns an [`Array`]({{ book.javase }}/api/java/util/Array.html) of [`int`]({{ book.javase }}/api/java/lang/Integer.html) values.  Each integer provides the ID for a cluster registered to this [`OClass`](../OClass.md) instance.


