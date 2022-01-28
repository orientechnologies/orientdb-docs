---
search:
   keywords: ["PHP", "PhpOrient", "drop database", "dbDrop"]
---

# PhpOrient - `dbDrop()`

Remove the given database from OrientDB.


## Dropping Databases

In certain situations, you may want to remove a full database from the OrientDB Server.  For instance, if you create a temporary database in memory for certain operations or if you want to provide the user with the ability to uninstall the database from within the application, without removing OrientDB itself.

### Syntax

```
$client->dbDrop(
	<database-name>,
	<storage-type>)
```

- **`<database-name>`** Defines the database name.
- **`<storage-type>`** Defines the storage type.  This is an optional variable, defaults to PLocal.
  - *`PhpOrinet::STORAGE_TYPE_PLOCAL`* Sets the PLocal storage type.
  - *`PhpOrient::STORAGE_TYPE_MEMORY`* Sets in-memory storage type.


### Example

For instance, in the event that your application encounters a catastrophic failure in the database, you might want a function that allows you to reset it to a clean state.

```php
// RESET DATABASE
function resetDatabase($client, $dbname){

	// REMOVE DATABASE
	$client->dbDrop($dbname, PhpOrient::STORAGE_TYPE_MEMORY);

	// CREATE DATABASE
	$client->dbCreate($dbname, PhpOrient::STORAGE_TYPE_MEMORY);
}
```

This function removes the given database, then uses the [`dbCreate()`](PHP-dbCreate.md) method to create a new one with the same name and storage type.
