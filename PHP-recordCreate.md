---
search:
   keywords: ['PHP', 'PhpOrient', 'create record', 'recordCreate']
---

# PhpOrient - `recordCreate()`

This method creates a record on the database.

## Creating Records

Eventually, you'll want your application to programmatically add records to OrientDB.  Using this method you can create a new record and insert it into the database.

### Syntax

```
$client->recordCreate(<record>)
```

- **`<record>`** Defines the record to create, it is an instance of [`Record()`](PHP-Record.md).


### Example

For instance, say that you are developing a web application to manage blogs for multiple users.  When the user is ready to publish a blog entry to the site, you might use a function such as this to handle creating the new record on the database.

```php
// POST FUNCTION
function postBlog($title, $text, $user){

	// LOG OPERATION
	echo "Posting Blog: $title, for $user\n";

	// FETCH GLOBAL PHPORIENT CLIENT
	global $client;

	// BUILD RECORD CONTENT
	$recordContent = [
		'title': $title,
		'author': $user,
		'text': $text];

	// BUILD RECORD
	$record = (new Record() )->setOData($recordContent)->setOClass("Blog")->setRid(new ID(9));

	// CREATE RECORD
	$client->recordCreate($record);
}
```

>Note, when creating new `Record()` objects, you only set the Cluster ID component of the Record ID.  This helps avoid unexpected results when the record is created on the database in the next line.

