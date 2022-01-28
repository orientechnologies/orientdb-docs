---
search:
   keywords: ["PHP", "PhpOrient", "database exists", "dbExists"]
---

# PhpOrient - `dbExists()`

This method determines whether a database exists on the server.

## Checking Existence

There are two methods available in determining whether a database exists on the OrientDB Server.  You can use the [`dbList()`](PHP-dbList.md) method to retrieve a list of the databases on the server and check them individually within your PHP code or you can individually check database names against this method.

### Syntax

```
$client->dbExists(
	<database-name>,
	<database-type>)
```

- **`<database-name>`** Defines the database name.
- **`<database-type>`** Defines the storage type.  The default type is a Graph database.  Valid types:
  - *`PhpOrient::DATABASE_TYPE_GRAPH`* Sets to Graph database.
  - *`PhpOrient::DATABASE_TYPE_DOCUMENT`* Sets to Document database.

### Example

Consider the use case of a web application.  Rather than just assuming that OrientDB is ready to serve data to your application, you might want to start by checking whether a database exists and is ready for your use and in the event that it doesn't exist, have your application create it for you.  For instance, 

```php
// OPEN OR CREATE DATABASE
function dbOpenCreate($client, $dbname, $user, $passwd){

	// CHECK IF EXISTS
	if !($client->dbExists($dbname)){
		// CREATE DATABASE
		$client->dbCreate($dbname,
			PhpOrient::STORAGE_TYPE_PLOCAL,
			PhpOrient::DATABASE_TYPE_GRAPH);
	}
	return $client->dbOpen($dbname, $user, $passwd);
}
```

This function takes the client interface, database name and login credentials as arguments.  It uses this method to check whether the given database exists.  If it does not exist, it creates it with [`dbCreate()`](PHP-dbCreate.md).  Then, it opens the given database, returning the cluster map.
