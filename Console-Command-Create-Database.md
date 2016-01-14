<!-- proofread 2015-01-07 SAM -->

# Console - `CREATE DATABASE`

Creates and connects to a new database.

**Syntax**

```sql
CREATE DATABASE <database-url> [<user> <password> <storage-type> [<db-type>]]
```

- **`<database-url>`** Defines the URL of the database you want to connect to. It uses the format `<mode>:<path>`
  - *`<mode>`* Defines the mode you want to use in connecting to the database.  It can be `PLOCAL` or `REMOTE`.
  - *`<path>`* Defines the path to the database.  
- **`<user>`** Defines the user you want to connect to the database with.
- **`<password>`** Defines the password needed to connect to the database, with the defined user.
- **`<storage-type>`** Defines the storage type that you want to use.  You can choose between `PLOCAL` and `MEMORY`.
- **`<db-type>`** Defines the database type.  You can choose between `GRAPH` and `DOCUMENT`.  The default is `GRAPH`.

**Examples**

- Create a local database `demo`:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE DATABASE PLOCAL:/usr/local/orientdb/databases/demo</code>

  Creating database [plocal:/usr/local/orientdb/databases/demo]...
  Connecting to database [plocal:/usr/local/orientdb/databases/demo]...OK
  Database created successfully.

  Current database is: plocal:/usr/local/orientdb/databases/demo

  orientdb {db=demo}>
  </pre>

- Create a remote database `trick`:

  <pre>
  orientdb> <code class='lang-sql userinput'>CREATE DATABASE REMOTE:192.168.1.1/trick root 
            E30DD873203AAA245952278B4306D94E423CF91D569881B7CAD7D0B6D1A20CE9 PLOCAL</code>

  Creating database [remote:192.168.1.1/trick ]...
  Connecting to database [remote:192.168.1.1/trick ]...OK
  Database created successfully.

  Current database is: remote:192.168.1.1/trick

  orientdb {db=trick}>
  </pre>


>To create a static database to use from the server, see [`Server pre-configured storage types`](DB-Server.md#storages).
>
>To remove a database, see [`DROP DATABASE`](Console-Command-Drop-Database.md).  To change database configurations after creation, see [`ALTER DATABASE`](SQL-Alter-Database.md).
>
>For more information on other commands, see [Console Commands](Console-Commands.md).
