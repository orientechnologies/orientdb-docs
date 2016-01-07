<!-- proofread 2015-01-07 SAM -->

# Console - LIST SERVER USERS

>This feature was introduced in OrientDB version 2.2.

Displays all configured users on the server. In order to display the users, the current system user that is running the console must have permissions to read the `$ORINETDB_HOME/config/orientdb-server-config.xml` configuration file. For more information, see [OrientDB Server Security](Security.md#orientdb-server-security).

**Syntax:**

```
LIST SERVER USERS
```

**Example:**

- List configured users on a server:

  <pre>
  orientdb> <code class="lang-sql userinput">LIST SERVER USERS</code>

  SERVER USERS
  - 'root', permissions: *
  - 'guest', permissions: connect,server.listDatabases,server.dblist
  </pre>

>For more information, see
>
>- [`SET SERVER USER`](Console-Command-Set-Server-User.md)
>- [`DROP SERVER USER`](Console-Command-Drop-Server-User.md)
>
> For more information on other console commands, see [Console Commands](Console-Commands.md).

