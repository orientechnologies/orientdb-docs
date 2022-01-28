---
search:
   keywords: ["PHP", "PhpOrient", "add cluster", "dataClusterAdd"]
---

# PhpOrient - `dataClusterAdd()`

This method creates a new cluster on the database.

## Adding Clusters

In cases where you want to create clusters programmatically, such as in an initialization script that prepares OrientDB for your application, this method allows you to add new physical and in-memory clusters to the databases.

### Syntax

```
$client->dataClusterAdd(
	"<name>",
	<cluster-type>)
```

- **`<name>`** Defines the cluster name.  By convention, this is generally lowercase.
- **`<cluster-type>`** Defines the cluster type.  Supported types are:
  - *`PhpOrient::CLUSTER_TYPE_PHYSICAL`* Sets the method to create a physical cluster, which is the default. 
  - *`PhpOrient::CLUSTER_TYPE_MEMORY`* Sets the method to create an in-memory cluster.

### Example

For instance, imagine you have an application that stores volatile data in-memory.  You might want a function to create a series of in-memory clusters as need.

```php
// CREATE AD-HOC MEMORY CLUSTERS
function createMemClusters($names){

	// LOG OPERATION
	echo "Creating Clusters";

	// FETCH GLOBAL CLIENT
	global $client;

	// CREATE CLUSTERS
	foreach($names as $name){

		// CREATE IN-MEMORY CLUSTER
		$client->dataClusterAdd($name,
			PhpOrient::CLUSTER_TYPE_MEMORY);
	}
}
```
