---
search:
   keywords: ["PHP", "PhpOrient", "list databases", "dbList"]
---

# PhpOrient - `dbList()`

Retrieves a list of databases on the server.

## Listing Databases

In certain situations, you may want to list all databases available on the OrientDB Server.  You might find this useful when operating on multiple databases or when logging.

### Syntax

```
$client->dbList()
```

### Example

For instance, when developing a web application that servers multiple sites each with its own database, you might want to list the database names in your logs when the application starts.

```php
// LOOP OVER DATABASES AND ECHO NAMES
foreach ($client->dbList() as $db){
	echo "Database: $db";
}
```
