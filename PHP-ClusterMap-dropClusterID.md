---
search:
   keywords: ['PHP', 'PhpOrient', 'drop cluster', 'dropClusterID']
---

# PhpOrient - `dropClusterID()`

This method removes the given cluster from the database using its Cluster ID.

## Removing Clusters

In certain situations, you may find it useful to programmatically remove clusters from the database. For instance, in the case of a maintenance script that frees up space when the given cluster is no longer needed.  This method allows you to remove clusters by their Cluster ID, which is the first numeral in the Record ID.

### Syntax

```
$clusterMap->dropClusterID(<cluster-id>)
```

- **`<cluster-id>`** Defines the Cluster ID you want to remove.

### Example

Consider the example of a web application that uses multiple in-memory clusters for short-term needs.  For this purpose, you might want to create a function to quickly remove these clusters when you're finished using them.

```php
// REMOVE CLUSTER
function removeCluster($clusterID){

	// Log Operation
	echo "Removing Cluster: $clusterID";

	// Fetch Global Cluster Map
	global $clusterMap;

	// Remove the Cluster
	$clusterMap->dropClusterID($clusterID);
}
```
