---
search:
   keywords: ["PHP", "PhpOrient", "create database", "dbCreate"]
---

# PhpOrient - `dbCreate()`

Creates a database on the connected OrientDB Server.

## Creating Databases

In the event that a database does not already exist on the server, you can create one from within your application, using the `dbCreate()` method.  This method requires one argument, the database name, and can take two additional arguments defining the storage and database types.  It returns the default cluster ID.

### Syntax

```
$new_cluster_id = $client->dbCreate(
	<database>, 
	<storage-type>,
    <database-type>)
```

- **`<database>`** Defines the database name.
- **`<storage-type>`** Defines the storage type to use.  Valid storage types:
  - *`PhpOrient::STORAGE_TYPE_PLOCAL`* Sets PLocal storage.  This is the default option.
  - *`PhpOrient::STORAGE_TYPE_MEMORY`* Sets in-memory storage.
- **`<database-type>`** Defines the database type to create.  Valid database types:
  - *`PhpOrient::DATABASE_TYPE_GRAPH`* Sets the method to create a graph database.  This is the default option.
  - *`PhpOrient:DATABASE_TYPE_DOCUMENT`* Sets the method to create a document database. 

### Example

Consider the use case of a web application.  Rather than just assuming that OrientDB is ready to serve data to your application, you might want to start by checking whether a database exists and is ready for your use and in the event that it doesn't exist, have your application create it for you.  For instance, 

```php
// OPEN OR CREATE DATABASE
function dbOpenCreate($dbname, $user, $passwd){

	// RETRIEVE GLOBAL CLIENT
	global $client;

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

This function takes the database name and database login credentials as arguments.  Using [`dbExists()`](PHP-dbExists.md) it determines whether the database exists on the database and creates it if it doesn't exist.  Then it opens the given database, returning the cluster map.
