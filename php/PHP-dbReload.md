---
search:
   keywords: ['PHP', 'PhpOrient', 'reload', 'database reload', 'dbReload']
---

# PhpOrient - `dbReload()`

This method updates the client cluster map.


## Reloading the Database

When you create or remove a new class or cluster on the database, it updates OrientDB but not the client interface you have created within your application.  The client interface also does update when changes are made to OrientDB apart from your application.  In these cases, you can use this method to retrieve an updated cluster map from OrientDB.

### Syntax

```
$client->dbReload()
```

### Example

For instance, rather than calling this method manually after creating a class on the database, you might develop your own function to save yourself the trouble of remembering to make the call elsewhere.

```php
// ADD CLUSTER FUNCTION
function addCluster($client, $clusterName){

	// LOG OPERATION
	echo "Adding Cluster $clusterName";

	// ADD CLUSTER TO DATABASE
	$client->dataClusterAdd($clusterName, PhpOrient::CLUSTER_TYPE_PHYSICAL);

	// RELOAD DATABASE
	$reloaded_list = $client->dbReload;

	// RETURN NEW LIST
	return $reloaded_list;
}
```
