---
search:
   keywords: ["PHP", "database", "PhpOrient", 'dbOpen', 'open database' ]
---

# PhpOrient - `dbOpen()`

This method opens a database on the client interface.  The return value is a [cluster map](PHP-ClusterMap.md).

## Opening Databases

When the database you want exists already on the OrientDB Server, you can open it on the client interface using this method with the appropriate name and login credentials.  Once you have it open, a series of additional methods become available through the client interface.  These allow you to insert, retrieve and modify records in the database.

### Syntax

```
$client->dbOpen('<database-name>', '<user>', '<password>')
```

- **`<database-name>`** Defines the database you want to open.
- **`<user>`** Defines the user you want to access the database.
- **`<password>`** Defines the password to use.


### Example
 
For instance, in the use case of web application, you might use something like this to connect to the database.

```php
// CONNECT TO DATABASE
$ClusterMap = $client->dbOpen('GratefulDeadConcerts', 'admin', 'admin_passwd');
```

## Working with Database

Once you have an open database on the client interface, a series of additional methods become available to you.  These methods handle common operations on the database, in terms of inserting and fetching records as well as manipulating clusters on the database.

| Method | Description |
|---|---|
| [**`command()`**](PHP-Command.md) | Executes a command on the database. |
| [**`dataClusterAdd()`**](PHP-dataClusterAdd.md) | Adds a cluster to the database. |
| [**`dataClusterCount()`**](PHP-dataClusterCount.md) | Counts records in a cluster or clusters. |
| [**`dataClusterDrop()`**](PHP-dataClusterDrop.md) | Removes a cluster from the database. |
| [**`dataClusterDataRange()`**](PHP-dataClusterDataRange.md) | retrieves a range of Record ID's for the given cluster. |
| [**`dbCountRecords()`**](PHP-dbCountRecords.md) | Counts records on a database. |
| [**`dbReload()`**](PHP-dbReload.md) | Reloads the database on the client interface. |
| [**`dbSize()`**](PHP-dbSize.md) | Returns the size of the database. |
| [**`getTransactionStatement()`**](PHP-Tx.md) | Instantiates a transaction interface. |
| [**`query()`**](PHP-Query.md) | Queries the database. |
| [**`queryAsync()`**](PHP-queryAsync.md) | Queries the database with support for callback functions and Fetching Strategies. |
| [**`recordCreate()`**](PHP-recordCreate.md) | Creates a record on database. |
| [**`recordLoad()`**](PHP-recordLoad.md) | Loads a record from the database. |
| [**`recordUpdate()`**](PHP-recordUpdate.md) | Updates a record on the database. |
| [**`sqlBatch()`**](PHP-sqlBatch.md) | Executes an SQL batch command. |


