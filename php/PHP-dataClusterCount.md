---
search:
   keywords: ["PHP", "PhpOrient", "cluster", "count records", "dataClusterCount"]
---

# PhpOrient - `dataClusterCount()`

This method returns a count of records in the given cluster.

## Counting Records

In certain situations you may find it useful to check how many records a given cluster contains, for instance as part of logging or debugging, or to check cluster size before running a backup script.

### Syntax

```
$client->dataClusterCount(<clusters>)
```

- **`<clusters>`** Defines the cluster or clusters you want to count on.

### Example

Picture a web application where you want to count records in a given cluster.  For instance, on a blog site you might want a basic count to show the number of entries you host on the site across several entries.

```php
function countBlogs(){

	// Fetch Global Client
	global $client;

	// Return Record Count
	return $client->dataClusterCount(
		$client->getTransport()->getClusterMap()->getIdList());
}
```




