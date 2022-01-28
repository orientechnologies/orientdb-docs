---
search:
   keywords: ['PHP', 'PhpOrient', 'get cluster id', 'getIdList']
---

# PhpOrient - `[etIdList()`

This method returns a list of Cluster ID's on the database.

## Retrieving Cluster ID's

Occasionally, you may want to work with a series of clusters in a given operation.  Using this method, you can retrieve a list of Cluster ID's available on the database.  You can then pass these ID's to other methods in performing further operations.

### Syntax

```
$clusterMap->getIdList()
```

### Example

In cases where you find yourself making frequent calls to all clusters on the database, you may find it convenient to write a simple function to fetch it and log the operation for you.

```php
// FETCH CLUSTER ID'S
function fetchClusterIDs(){

	// Fetch Global Cluster Map
	global $clusterMap;

	// Fetch ID's
	$idList = $clusterMap->getIdList();	
	$idCount = count($idList);

	// Log Operation
	echo "Retrieving $idCount Cluster ID's";

	// Return ID's
	return $idList;
}
```
