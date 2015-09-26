# Console - SET SERVER USER

Creates or updates a server user. If the user already exists, password and permissions are modified. If not exists, a new user is created. In order to create or modify the user, the current system user that is running the console, must have the permissions to write the file `$ORIENTDB_HOME/config/orientdb-server-config.xml`. For more information look at [OrientDB Server security](Security.html#orientdb-server-security). Since v 2.2.

## Syntax

```
SET SERVER USER <user-name> <user-password> <user-permissions> 
```

## Example

```sql
orientdb> set server user editor fancypassword *

Server user 'editor' set correctly
```

## See also

- [LIST SERVER USERS](Console-Command-List-Server-Users.md).
- [DROP SERVER USER](Console-Command-Drop-Server-User.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).

