# Console - DROP SERVER USER

Drops a server user. In order to drop the user the current system user that is running the console, must have the permissions to write the file `$ORIENTDB_HOME/config/orientdb-server-config.xml`. For more information look at [OrientDB Server security](Security.html#orientdb-server-security). Since v 2.2.

## Syntax

```
DROP SERVER USER <user-name>
```

## Example

```sql
orientdb> drop server user editor

Server user 'editor' dropped correctly
```

## See also

- [LIST SERVER USERS](Console-Command-List-Server-Users.md).
- [SET SERVER USER](Console-Command-Set-Server-User.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).

