# Console - DROP DATABASE

The **Drop Database** command definitely deletes a database. If a database is open and no database name is used, then the current database will be deleted. *NOTE: Unless you've made backups there is no way to restore a deleted database.*

## Syntax

For database opened using "local" protocol:
```sql
DROP DATABASE
```

To remove a database hosted in a remote OrientDB Server you need the credential to do it at the target OrientDB server:

```sql
DROP DATABASE <database-name> <server-username> <server-userpassword>
```

Where:
- **database-name** is the name of database. If not specified means the current database if it's opened
- **server-username** is the name of the server's user with privileges to drop the database
- **server-userpassword** is the password of the server's user

## See also
- [Console Command Create Database](Console-Command-Create-Database.md)
- [SQL Alter Database](SQL-Alter-Database.md)

## Examples

Delete the current local database:

```java
DROP DATABASE
```

Delete the remote database "demo" hosted on localhost:

```sql
DROP DATABASE remote:localhost/demo root 5B1A917B20C78ECAA219E37CFDDA6598D4D62CE68DD82E5B05D4949758A66828
```

To create a new database use the [Create Database](Console-Command-Create-Database.md) command.

To know more about other SQL commands look at [SQL commands](SQL.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
