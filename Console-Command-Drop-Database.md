# Console - `DROP DATABASE`

Removes a database completely.  If the database is open and a database name not given, it removes the current database.

**Syntax**

```sql
DROP DATABASE [<database-name> <server-username> <server-user-password>]
```

- **`<database-name`** Defines the database you want to drop.  By default it uses the current database, if it's open.
- **`<server-username>`** Defines the server user.  This user must have the privileges to drop the database.
- **`<server-user-password>`** Defines the password for the server user.

>**NOTE**: When you drop a database, it deletes the database and all records, caches and schema information it contains.  Unless you have made backups, there is no way to restore the database after you drop it.

**Examples**

- Remove the current local database:

  <pre>
  orientdb> <code class="lang-sql userinput">DROP DATABASE</code>
  </pre>

- Remove the database `demo` at localhost:

  <pre>
  orientdb> <code class="lang-sql userinput">DROP DATABASE REMOTE:localhost/demo root root_password</code>
  </pre>


>You can create a new database using the [`CREATE DATABASE`](Console-Command-Create-Database.md) command.  To make changes to an existing database, use the [`ALTER DATABASE`](SQL-Alter-Database.md) command.

>For more information on other commands, see [SQL](SQL.md) and [Console](Console-Commands.md) commands.
