# Console - LIST SERVER USERS

Displays all the configured server users. In order to display the users, the current system user that is running the console, must have the permissions to read the file `$ORIENTDB_HOME/config/orientdb-server-config.xml`. For more information look at [OrientDB Server security](Security.html#orientdb-server-security). Since v 2.2.

## Syntax

```
LIST SERVER USERS
```

## Example

```sql
orientdb> list server users

SERVER USERS

- 'root', permissions: *
- 'guest', permissions: connect,server.listDatabases,server.dblist
```

## See also

- [SET SERVER USER](Console-Command-Set-Server-User.md).
- [DROP SERVER USER](Console-Command-Drop-Server-User.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).

