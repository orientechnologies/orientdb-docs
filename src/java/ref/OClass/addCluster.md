
# OClass - addCluster()

This method adds a cluster to the database class.

## Adding Clusters

When OrientDB saves records, it stores then clusters, using either physical or in-memory storage.  With this method you can add a cluster to the class. 

### Syntax

```
OClass OClass().addCluster(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the cluster name |


#### Return Type

This method returns the updated [`OClass`](../OClass.md) instance.


### Examples

Consider the use case of a method that provisions a database for your application.  You might run this as part of the installation process or to set up a new database for a particular process.

```java
public ODatabaseDocument db;
private Logger logger;

// Provision Class with new Clusters
public void provisionClassClusters(OClass cls, List<String> clusters){

   // Log Operation
   logger.info("Adding clusters to class");

   // Iterator over List of Clusters
   for(String name : clusters){

      logger.debug(
	     String.format("Creating Cluster '%s' on class '%s'",
		    name,
			cls.getName());
      cls.addCluster(name);
   }
   logger.debug("Done");
}
```

This method takes an [`OClass`](../OClass.md) instance and a [`List`]({{ book.javase }}/java/util/List.html)[`<String>`]({{ book.javase }}/java/lang/String.html) instance, which contains a list of new cluster names.



