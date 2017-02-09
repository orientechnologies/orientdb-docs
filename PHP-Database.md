---
search:
   keywords: ["PHP", "database", "PhpOrient", 'dbOpen', 'open database' ]
---

# PhpOrient - `dbOpen()`

This method opens a database on the OrientDB Server.  It returns a cluster map object. It returns a cluster map object. 

## Opening Databases

When you have the name of the database that you want to open, as well as valid login credentials.  It returns a cluster map object.  Once you have opened a database on the client, you can begin to operate on the database.

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
