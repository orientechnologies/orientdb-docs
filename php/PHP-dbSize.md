---
search:
   keywords: ['PHP', 'PhpOrient', 'size', 'database size', 'dbSize']
---

# PhpOrient - `dbSize()`

This method returns the size of the database.

## Sizing Databases

There are three methods available to you in counting or sizing databases.  This method returns the size of the database, [`dbCountRecords()`](PHP-dbCountRecords.md) returns the number of records in the database, and [`dataClusterCount()`](PHP-dataClusterCount.md) the number of records in a cluster.

### Syntax

```
$client->dbSize()
```

### Example

For instance, you might use this method in conjunction with unit testing, especially after performing a restore operation on a new server.  That is, a quick way to determine whether the restore process properly executed is to check whether the database contains records.

```php
// TEST DATABASE RESTORE
function testRestore($client, $user, $password, $databaseName){

	// LOG OPERATION
	echo "Checking Database: $databaseName";

	// TEST DATABASE EXISTENCE
	assert($client->dbExists($databaseName));

	// TEST THAT DATABASE CONTAINS RECORDS
	$client->dbOpen($databaseName, $user, $password);
	assert($client->dbSize() > 0);
}
```
