# Server Security

Individual OrientDB servers can manage multiple databases at a time and each database can have its own set of users.  When using OrientDB through the HTTP protocol, the OrientDB server uses one realm per database.

|   |   |
|---|---|
|![](images/warning.png)| While OrientDB can function as a regular Web Server, it is not recommended that you expose it directly to the internet or to public networks.  Instead, always hide the OrientDB server within a private network.|

Server users are stored in the `config/orientdb-server-config.xml` configuration file, in the `<users>` element.

```xml
    <users>
        <user name="root" password="{SHA-256}55F95B91628EF3E679628ACB23AE" resources="*" />
        <user name="guest" password="guest" resources="connect,server.listDatabases,server.dblist" />
    </users>
```

When the OrientDB server starts for the first time, it creates the user `root` automatically, by asking you to give the password in the terminal.  In the event that you do not specify a password, OrientDB generates a random password.  Beginning with version 2.2, OrientDB hashes the passwords using [SHA-256](https://en.wikipedia.org/wiki/SHA-2) algorithm.

For more information on security in Orientdb, see:
- [Database security](Database-Security.md)
- [Database Encryption](Database-Encryption.md)
- [Secure SSL connections](Using-SSL-with-OrientDB.md)

## Configuration

To restrict untrusted users from gaining access to the OrientDB server, add a new user or change the password in the server configuration file.  Protect the file `config/orientdb-server-config.xml` by disabling write access.  

Additionally, it is advisable that you also disable read access on the configuration file, to prevent users from viewing the passwords.  Even if passwords are hashed, there are many techniques available to crack the hash or otherwise guess the real password.  


|   |   |
|---|---|
|![](images/warning.png)|It is strongly recommended that you allow read/write access to the entire `config` directory only to the user that starts the OrientDB server.|


## Managing Users

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

1. If the user `admin` doesn't exist, create it by executing the following command:

  ```sql
  INSERT INTO OUser SET name = 'admin', password = 'admin', status = 'ACTIVE',
                      roles = (select from ORole where name = 'admin')
  ```

Now your `admin` user is active again.
