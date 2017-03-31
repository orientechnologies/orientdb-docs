---
search:
   keywords: ['PHP', 'PhpOrient', 'record', 'Record ID', 'set Record ID', 'setRid']
---

# PhpOrient - `setRid()`

This method sets the Record ID for the [`Record()`](PHP-Record.md) object.

## Setting Record ID's

When instatitating a [`Record()`](PHP-Record.md) object in your application, you may need to set the specific Record ID on the object before syncing it with OrientDB.  You can also partially define the record, by setting the Cluster ID for the cluste you want to create it in.  Once the [`ID()`](PHP-ID.md) instance is ready, you can pass it to this method to set the Record ID on the ojbect.

### Syntax

```
$record->setRid(<id>)
```

- **`<id>`** Defines the Record ID you want to set on the record.  It is an instance of [`ID()`](PHP-ID.md). 

### Example

When creating new records in your application, you can use this method to define the Record ID or the Cluster ID for the new record before syncing it with the database.  In cases where you do this often, you may want to use a dedicated function to ensure consistency with common values.

```php
function addEntry($data){

	// Log Operation
	echo "Creating Record";

	// Build Record
	$record = new Record()
		->setOData($data)
		->setRid(
			new ID(5))
		->setOClass("BlogEntry");

	// Create Record
	global $client;
	$client->recordCreate($record);
}
```
