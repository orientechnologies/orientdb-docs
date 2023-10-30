
# ODatabaseDocument - addCluster()

This method creates a new cluster for the database. 

## Adding Clusters

When you create a class, OrientDB automatically generates a cluster in which to store the data for that class.  While this may be sufficient for many purposes, there is some benefit in creating additional clusters to better organize the data for the class.  For instance, in a class used to manage accounts, you might separate clusters by region.  Using this method you can create new cluster on the database.

### Syntax

```
int ODatabaseDocument().addCluster(String clusterName, Object... parameters);
```

| Argument | Type | Description |
|--|---|
| **`clusterName`** | [`String`]({{ book.javase }}/java/lang/String.html) | Defines the logical name of the cluster |
| **`parameters`** | [`Object`]({{ book.javase }}/java/lang/Object.html) | Defines cluster creation options |

#### Return Type

This method returns a [`int`]({{ book.javase }}/java/lang/Integer.html) instance, which represents the created cluster's Cluster ID.  That is, the numeric identifier that occurs in the first value of a Record ID.

