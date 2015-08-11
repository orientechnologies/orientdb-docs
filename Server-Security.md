# Server Security

|   |   |
|---|---|
|![](images/warning.png)|Even thought OrientDB Server is a regular Web Server, it is not recommended to expose it directly on the Internet or public networks. We suggest to always hide OrientDB server in a private network.|

A single OrientDB server can manage multiple databases at a time, each one with its own users. When used through the HTTP protocol, OrientDB server uses one realm pe database.

Server users are stored in `config/orientdb-server-config.xml` file under the tag `<users>`. Example:
```xml
    <users>
        <user name="root" password="{SHA-256}55F95B91628EF3E679628ACB23AE" resources="*" />
        <user name="guest" password="guest" resources="connect,server.listDatabases,server.dblist" />
    </users>
```

When the OrientDB Server starts the first time, it creates the `root` user automatically by asking the password in console. If no password is specified, an random passwod is generated. Starting from OrientDB 2.2, passwords are hashed using [SHA-256](https://en.wikipedia.org/wiki/SHA-2) algorithm.

## Configuration
To avoid untrusted users add a new user or change the password on server configuration, protect the file `config/orientdb-server-config.xml` by disabling `write` access. It's good rule also disabling `read` access to avoid any user can read the hashed password. In facts, even i the password is hashed, there are many techniques to guess the real password. These techniques could be more or less complicated and time consuming.

|   |   |
|---|---|
|![](images/warning.png)|It's strongly suggested to allow the read/write access to the entire OrientDB `config` directory only to the user that will start OrientDB server.|

## Manage users
Starting from OrientDB 2.2, the console is able to manage server users thanks to the following commands:
- [`list server users`](Console-Command-List-Server-Users.md), to display all the users
- [`set server user`](Console-Command-Set-Server-User.md), to create or modify a user
- [`drop server user`](Console-Command-Drop-Server-User.md), to drop a user

## Server's resources

This section contains all the available server's resources. Each user can declare which resources have access. The wildcard `*` means any resources.  The `root`server user, by default, has all the privileges, so it can access all the managed databases.

| Resources | Description |
|-----------|-------------|
|`server.info`|Retrieves the server information and statistics|
|`server.listDatabases`|Lists the available databases on the server|
|`database.create`|Creates a new database in the server|
|`database.drop`|Drops a database|
|`database.passthrough`|Starting from 1.0rc7 the server's user can access all the managed databases if it has the resource `database.passthrough` defined. Example:`<user name="replicator" password="repl" resources="database.passthrough" />`|


## SSL Secure connections

Starting from v1.7, OrientDB supports [secure SSL connections](Using-SSL-with-OrientDB.md).

## Restore admin user

If the class `OUser` has been dropped or the `admin` user has been deleted, you can follow this procedure to restore your database:

1. Ensure the database is under the OrientDB Server's databases directory (`$ORIENTDB_HOME/databases/ folder`)

1. Open the Console or Studio and login into the database using `root` and the password contained in the file `$ORIENTDB_HOME/config/orientdb-server-config.xml`

1. Execute this query:

  ```sql
  SELECT FROM OUser WHERE name = 'admin'
  ```

1. If the class OUser doesn't exist, create it by executing:

  ```sql
  CREATE CLASS OUser EXTENDS OIdentity
  ```

1. If the class `OIdentity` doesn't exist, create it by executing:

  ```sql
  CREATE CLASS OIdentity
  ```
  And then retry to create the class `OUser` (5)

1. Now execute:

  ```sql
  SELECT FROM ORole WHERE name = 'admin'
  ```

1. If the class `ORole` doesn't exist, create it by executing:

  ```sql
  CREATE CLASS ORole EXTENDS OIdentity
  ```

1. If the role `admin` doesn't exist, create it by executing the following command:

  ```sql
  INSERT INTO ORole SET name = 'admin', mode = 1, rules = {"database.bypassrestricted":15}
  ```

1. If the user "admin" doesn't exist, create it by executing the following command:

  ```sql
  INSERT INTO OUser SET name = 'admin', password = 'admin', status = 'ACTIVE',
                      roles = (select from ORole where name = 'admin')
  ```

Now your `admin` user is active again.
