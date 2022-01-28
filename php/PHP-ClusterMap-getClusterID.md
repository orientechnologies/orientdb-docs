---
search:
   keywords: ['PHP', 'PhpOrient', 'get cluster id', 'getClusterID']
---

# PhpOrient - `getClusterID()`

This method returns the Cluster ID for the given name.

## Retrieving Cluster ID's

In cases where you need or would like to operate on a cluster by its Cluster ID, you can retrieve it from the Cluster Map by passing the cluster name as an argument to this method.


### Syntax

```
$clusterMap->getClusterID(<cluster-name>)
```

- **`<cluster-name>`** Defines the name of the cluster.

### Example

For instance, say you want to retrieve records for clusters by cluster name, you might use this method in conjunction with [`dataClusterDataRange()`](PHP-dataClusterDataRange.md).

```php
// FETCH RECORDS
function fetchRecords($clusterName){

	// Log Operation
	echo "Retrieving Records on Cluster: $clusterName";

	// Fetch Globals
	global $client;
	global $clusterMap;

	// Find Cluster ID
	$clusterId = $clusterMap->getClusterID($clusterName);

	// Return Records
	return $client->dataClusterDataRange($clusterId);
}
```
