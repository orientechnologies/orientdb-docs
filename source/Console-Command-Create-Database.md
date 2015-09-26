# Console - CREATE DATABASE

Creates a new database.

## Syntax

```sql
CREATE DATABASE <database-url> [<user> <password> <storage-type> [<db-type>]]
```

Where:

- *database-url*   The url of the database to create in the format '<code>&lt;mode&gt;:&lt;path&gt;</code>'
- *user*           on remote database is the Server's administrator name
- *password*       on remote database is the Server's administrator password
- *storage-type*   The type of the storage between 'plocal' for disk-based database and 'memory' for in memory only database. Look at [Storage types](Concepts.md#storage).
- *db-type*        Optional, is the database type between "graph" (the default) and "document"

## See also
- [Console Command Drop Database](Console-Command-Drop-Database.md)
- [SQL Alter Database](SQL-Alter-Database.md)

## Example: create a local database

```
CREATE DATABASE plocal:/usr/local/orient/databases/demo/demo

Creating database [plocal:/usr/local/orient/databases/demo/demo]...
Connecting to database [plocal:/usr/local/orient/databases/demo/demo]...OK
Database created successfully.

Current database is: plocal:/usr/local/orient/databases/demo/demo
```


## Example: create a remote database

```sql
CREATE DATABASE remote:localhost/trick root E30DD873203AAA245952278B4306D94E423CF91D569881B7CAD7D0B6D1A20CE9 plocal

Creating database [remote:localhost/trick ]...
Connecting to database [remote:localhost/trick ]...OK
Database created successfully.

Current database is: remote:localhost/trick
```

## Create a static database into the server configuration

To create a static database to use it from the server look at: [Server pre-configured storages](DB-Server.md#storages).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
