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

While the default users and passwords are fine while you are setting your system up, it would be inadvisable to leave them in production.  To help restrict untrusted  users from accessing the OrientDB server, add a new user and change the passwords in the `config/orientdb-server-config.xml` server configuration file.  

To restrict unauthorized users from giving themselves privileges on the OrientDB server, disable write-access to the configuration file.  To help prevent them from viewing passwords, disable read-access as well.  Note that even if the passwords are hashed, there are many techniques available to crack the hash or otherwise guess the real password.


|   |   |
|---|---|
|![](images/warning.png)|It is strongly recommended that you allow read/write access to the entire `config` directory only to the user that starts the OrientDB server.|


## Managing Users

Beginning with version 2.2, the OrientDB console provides a series of commands for managing users:

- [`LIST SERVER USERS`](Console-Command-List-Server-Users.md): Displays all users.
- [`SET SERVER USER`](Console-Command-Set-Server-User.md): Creates or modifies a user.
- [`DROP SERVER USER`](Console-Command-Drop-Server-User.md): Drops a user.


## Server Resources

Each user can declare which resources have access.  The wildcard `*` grants access to any resource.  By default, the user `root` has all privileges, so it can access all the managed databases.


| Resources | Description |
|-----------|-------------|
|`server.info`|Retrieves server information and statistics.|
|`server.listDatabases`|Lists available databases on the server.|
|`database.create`|Creates a new database in the server|
|`database.drop`|Drops a database|
|`database.passthrough`|Allows access to all managed databases.|

For example,

```xml
<user name="replicator" password="repl" resources="database.passthrough"/>
```



## Securing Connections with SSL

Beginning with version 1.7, you can further improve security on your OrientDB server by securing connections with SSL.  For more information on implementing this, see [Using SSL](Using-SSL-with-OrientDB.md).


## Restoring the User admin 

In the event that something happens and you drop the class `OUser` or the user `admin`, you can use the following procedure to restore the user to your database.

1. Ensure that the database is in the OrientDB server database directory, `$ORIENTDB_HOME/database/ folder`.

1. Launch the console or studio and log into the database with the user `root`.

   <pre>
   $ <code class="lang-sh userinput"> $ORIENTDB_HOME/bin/console.sh</code>

   OrientDB console v.X.X.X (build 0) www.orientdb.com
   Type 'HELP' to display all the commands supported.
   Installing extensions for GREMLIN language v.X.X.X

   orientdb> <code class="lang-sql userinput">CONNECT remote:localhost/my_database root rootpassword</code>
   </pre>

1. Check that the class `OUser` exists:

   <pre>
   orientdb> <code class="lang-sql userinput">SELECT FROM OUser WHERE name = 'admin'</code>
   </pre>

   - In the event that this command fails because the class `OUser` doesn't exist, create it:

     <pre>
     orientdb> <code class="lang-sql userinput">CREATE CLASS OUser EXTENDS OIdentity</code>
     </pre>

   - In the event that this command fails because the class `OIdentity doesn't exist, create it first:

     <pre>
     orinetdb> <code class="lang-sql userinput">CREATE CLASS OIdentity</code>
     </pre>

     Then repeat the above command, creating the class `OUser`

1. Check that the class `ORole` exists.

   <pre>
   orientdb> <code class="lang-sql userinput">SELECT FROM ORole WHERE name = 'admin'</code>
   </pre>

   - In the event that the class `ORole` doesn't exist, create it:

     <pre>
     orientdb> <code class="lang-sql userinput">CREATE CLASS ORole EXTENDS OIdentity</code>
     </pre>

1. In the event that the user or role `admin` doesn't exist, run the following commands:

   - In the event that the role `admin` doesn't exist, create it:

     <pre>
     orientdb> <code class="lang-sql userinput">INSERT INTO ORole SET name = 'admin', mode = 1, 
               rules = { "database.bypassrestricted": 15 }</code>
     </pre>

   - In the event that the user `admin` doesn't exist, create it:

     <pre>
     orientdb> <code class="lang-sql userinput">INSERT INTO OUser SET name = 'admin', 
               password = 'my-admin_password', status = 'ACTIVE', 
               rules = ( SELECT FROM ORole WHERE name = 'admin' )</code>
     </pre>

The user `admin` is now active again on your database.

