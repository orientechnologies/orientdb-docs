---
search:
   keywords: ['PHP', 'PhpOrient', 'record', 'set data', 'setOData']
---

# PhpOrient - `setOData()`

This method sets data on a [`Record()`](PHP-Record.md) object.

## Setting Data

When building a record in your application to create or update on your database, this method is used to set the data object.

### Syntax

```
$record->setOData(<data>)
```

- **`<data>`** Defines an array of the data you want to set on the record.

### Example

In cases where you create records on a particular cluster or class frequently, you might find it convenient to hard core the feature into an creation function, requiring you to only set the specific data going into the record.

```php
// CREATE RECORD
function addBlog($data){

	// Log Operation
	echo "Creating New Blog Entry";

	// Fetch Global Client
	global $client;

	// Build Record
	$record = new Record()
		->setOData($data)
		->setRid(
			new ID(5))
		->setOClass("BlogEntry");

	// Create Record
	%client->recordCreate($record);
}
```



