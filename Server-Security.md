# Server Security

|   |   |
|---|---|
|![](images/warning.png)|Even thought OrientDB Server is a regular Web Server, it is not recommended to expose it directly on the Internet or public networks. We suggest to always hide OrientDB server in a private network.|

A single OrientDB server can manage multiple databases at a time, each one with its own users. The HTTP protocol is handled by using different realms. This is the reason why each OrientDB Server instance has its own users to handle the server instance itself.

When the OrientDB Server starts it checks to see if there is already a `root` user configured. If not, it creates the `root` user and inserts it into the `config/orientdb-server-config.xml` file with an automatically generated very long password. Feel free to change the password, but restart the server to pick up the change.

The `root` user is in a section that looks like this:

```xml
<users>
  <user name="root"
        password="{SHA-256}FAFF343DD54DKFJFKDA95F05A"
        resources="*" />
</users>
```

Since the password is not encrypted, whoever is installing OrientDB must protect the entire directory (not only config folder) to avoid access by unauthorized users.

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
