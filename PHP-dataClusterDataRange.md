---
search:
   keywords: ['PHP', 'PhpOrient', 'cluster', 'data range', 'dataClusterDataRange']
---

# PhpOrient - `dataClusterDataRange()`

This method fetches a range of Record ID's by cluster.

## Retrieving Ranges of Records

In some cases, you may want to retrieve all records in a given cluster.  This method uses the Cluster ID to identify the records you want to access.

### Syntax

```
$client->dataClusterDataRange(<cluster-id>)
```

- **`<cluster-id>`** Defines the Cluster ID for records you want to retrieve records from.

### Example

Consider the example of a web application where you need to periodically retrieve and operate on large bodies of records by cluster.  Rather than manually retrieving clusters by ID, you might set up global map to keep the references human readable.

```php
// Clusters
$clusters = array(
	"BlogsUS" => array(3, 4, 5),
	"BlogsEU" => array(1, 2, 6, 9),
	"BlogsME" => array(7, 8)
);

// Fetch Record ID's
function fetchRIds($regionName){

	// Log Operation
	echo "Fetching Records: $regionName";
	
	// Initialize Global Variables 
	global $clusters;
	global $client;

	// Initialize Local Variables 
	$returnArray = array();
	$region = $clusters[$regionName];

	// Loop Over Cluster ID's in Region
	foreach($region as $clusterId){

		// Append Record ID's to Return Array
		$returnArray[] = $client->dataClusterDataRange($clusterId);
	}

	// Return Record ID's
	return $returnArray;
}
```


