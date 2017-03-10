---
search:
   keywords: ['PHP', 'PhpOrient', 'cluster', 'cluster drop', 'drop cluster', 'dataClusterDrop']
---

# PhpOrient - `dataClusterDrop()`

This method drops the given cluster.

## Dropping Clusters

In certain situations, you may find it useful to programmatically remove clusters from the database.  For instance, in the case of a maintenance script that frees up space when the given cluster is no longer needed.  This method allows you to remove clusters by their Cluster ID, which is the first number in a Record ID.

### Syntax

```
$client->dataClusterDrop(<cluster-id>)
```

- **`<cluster-id>`** Defines the Cluster ID to remove.


### Example

Consider the example of a web application that uses multiple in-memory clusters for short term needs.  For this purpose, you might want a function to quickly remove these clusters when you're finished using them.

```php
// REMOVE CLUSTER
function removeCluster($clusterId){

	// Log Operation
	echo "Removing Cluster: $clusterId";

	// Fetch Global Client
	global $client;

	// Remove Cluster
	$client->dataClusterDrop($clusterId);
}
```
