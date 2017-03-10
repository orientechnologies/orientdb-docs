---
search:
   keywords: ['PHP', 'PhpOrient', 'record', 'set class', 'setOClass']
---

# PhpOrient - `setOClass()`

This method sets the class on the [`Record()`](PHP-Record.md) object.

## Setting Classes

When building records within your application this method allows you to define the class to which the record belongs in OrientDB.

### Syntax

```
$record->setOClass(<class>)
```

- **`<class>`** Defines the class name.

### Example

For instance, when creating a new [`Record()`](PHP-Record.md) instance within your application, use this method to set the class.

```php
function addEntry($data){

	// Log Operation
	echo "Creating Record";

	// Build Record
	$record = new Record()
		->setOData($data)
		->setRid(
			new ID(5))
		->setOClass("entry");

	// Create Record
	global $client;
	$client->recordCreate($record);
}
```
