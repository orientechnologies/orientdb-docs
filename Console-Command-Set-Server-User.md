# Console - `SET SERVER USER`

Creates a server user.  If the server user already exists, it updates the password and permissions.

In order to create or modify the user, the current system user must have write permissions on the `$ORIENTDB_HOME/config/orientdb-server-config.xml` configuration file.


**Syntax**

```
SET SERVER USER <user-name> <user-password> <user-permissions> 
```

- **`<user-name>`** Defines the server username.
- **`<user-password>`** Defines the password for the server user.
- **`<user-permissions>`** Defines the permissions for the server user.


>For more information on security, see [OrientDB Server Security](Security.md#orientdb-server-security).  Feature introduced in version 2.2.

**Example**

- Create the server user `editor`, give it all permissions:

  <pre>
  orientdb> <code class='lang-sql userinput'>SET SERVER USER editor my_password *</code>

  Server user 'editor' set correctly
  </pre>


>To display all server users, see the [`LIST SERVER USERS`](Console-Command-List-Server-Users.md) command.  To remove a server user, see [`DROP SERVER USER`](Console-Command-Drop-Server-User.md) command.
>
>For more information on other commands, see [Console Commands](Console-Commands.md).

