---
search:
   keywords: ["PHP", "PhpOrient", "update record", "record update", "recordUpdate"]
---

# PhpOrient - `recordUpdate()`

This method updates records on the database.

## Updating Records

Your applications users may occasionally want to make changes to the database.  Using this method you can update existing records on the database.  In the event that you attempt to update a record that does not exist, this method creates it for you.

### Syntax

```
$client->recordUpdate(<record>)
```

- **`<record>`** Defines the record that you want to update, with relevant changes.  It is an instance of the `Record()` object.

### Example

For instance, consider the example of a web application that hosts blogs for multiple users.  While these users may generally post new blogs to the database, they may on occasion prefer to edit existing ones.

```php
// UPDATE OR CREATE RECORD 
function buildRecord($title, $text, $user){

	// LOG OPERATION
	echo "Posting Blog: $title, for $user";

	// BUILD RECORD CONTENT
	$recordContent = [
		"title":  $title,
		"author": $user,
		"text":   $text];

	// BUILD RECORD
	$record = (new Record() )->setOData($recordContent)->setOClass("Blog")->setRid(new ID(9));

	// FETCH GLOBAL CLIENT
	global $client;

	// UPDATE
	$client->recordUpdate($record);
}
```
