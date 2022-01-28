---
search:
   keywords: ['PHP', 'PhpOrient', 'count records', 'dbCountRecords']
---

# PhpOrient - `dbCountRecords()`

This method returns the number of records in the database.

## Counting Records

There are three methods available to you in counting or sizing databases.  This method returns the number of records in the database.  You can also retrieve the size of the database with [`dbSize()`](PHP-dbSize.md) and the number of records in a cluster with [`dataClusterCount()`](PHP-dataClusterCount.md).

### Syntax

```
$client->dbCountRecords()
```

### Example

As an example, you might use this method in conjunction with unit testing, especially after performing a restore operation on a new server.  That is, a quick way to determine whether the restore process properly executed is to check whether the database contains records.

```php
// TEST DATABASE RESTORE
function testRestore($client, $user, $password, $databaseName){
    // LOG OPERATION
	echo "Checking Database: $databaseName";

	// TEST WHETHER DATABASE EXISTS
	assert($client->dbExists($databaseName));
	
	// TEST THAT DATABASE CONTAINS RECORDS
	$client->dbOpen($databaseName, $user, $password);
	assert($client->dbCountRecords() > 0);
}
```
