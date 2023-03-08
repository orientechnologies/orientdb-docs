
# OClass - setDefaultClusterId()

This method configures the default cluster for the class.

## Setting the Default Cluster ID

When OrientDB stores records it assigns each a Record ID, (for instance #5:24).  The first element of a Record ID provides the Cluster ID, the second the position of the record in the cluster.  Every class has a default cluster, which it uses to store records whenever the target cluster is left unspecified.  This method allows you to configure which cluster you want to use as the default for the class. 

### Syntax

```
void OClass().setDefaultClusterId(int clusterId)
```

| Argument | Type | Description |
|---|---|---|
| **`clusterId`** | [`int`]({{ book.javase }}/api/java/lang/Integer.html) | Defines the Cluster ID to set |

