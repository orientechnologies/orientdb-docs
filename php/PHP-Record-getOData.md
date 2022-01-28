---
search:
   keywords: ['PHP', 'PhpOrient', 'get data', 'getOData']
---

# PhpOrient - `getOData()`

This method retrieves data from the record.

## Retrieving Data

In cases where you want to operate on record data, this method allows you to retrieve the data from the `Record()` instance.  It returns a mapped array of properties and values on the record.

### Syntax

```
$record->getOData()
```


### Example

Consider the use case of a web application that serves blogs.  You might want to create a blog roll, which displays data on the most recent posts.  You might want to create a function that standardizes the data retrieval process.

```php
function blogRoll($limit){

	// Log Operation
	echo "Retrieving Blog Entries";

	// Retrieve Blogs
	$blogs = $client->query("SELECT FROM BlogEntry LIMIT $limit");

	$div = '<div id="blog-roll"><h3>Latest Posts</h3><ul>'

	foreach($blogs as $record){

		// Fetch Data
		$data = $record->getOData();
		$title = $data['title'];
		$link = $data['link'];

		$div = '$div <li><a src="$link">$title</a></li>';
	}
	$div = '$div</div>';

	// Return Blog Roll
	return $div;
}
```
