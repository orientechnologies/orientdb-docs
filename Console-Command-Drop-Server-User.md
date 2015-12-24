# Console - `DROP SERVER USER`

Removes a user from the server.  In order to do so, the current system user running the Console, must have permissions to write to the `$ORIENTDB_HOME/config/orientdb-server-config.xmL` configuration file.

**Syntax**

```sql
DROP SERVER USER <user-name>
```

- **`<user-name>`** Defines the user you want to drop.

>**NOTE**: For more information on server users, see [OrientDB Server Security](Security.md#orientdb-server-security).

>This feature was introduced in version 2.2.


**Example**

- Remove the user `editor` from the Server:

  <pre>
  orientdb> <code class="lang-sql userinput">DROP SERVER USER editor</code>

  Server user 'editor' dropped correctly
  </pre>


>To view the current server users, see the [`LIST SERVER USERS`](Console-Command-List-Server-Users.md) command.  To create or update a server user, see the [`SET SERVER USER`](Console-Command-Set-Server-User.md) command.

>For more information on other commands, see [Console Commands](Console-Commands.md).

