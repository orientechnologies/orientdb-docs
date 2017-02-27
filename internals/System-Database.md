# OrientDB System Database #

Introduced in 2.2, OrientDB now uses a "system database" to provide additional capabilities.

The system database, currently named *OSystem*, is created when the OrientDB server starts, if the database does not exist.

## Features
Here's a list of some of the features that the system database may support:
- A new class of user called the *system user*
- A centralized location for configuration files
- Logging of per-database and global auditing events
- Recording performance metrics about the server and its databases

### System Users
A third type of user now exists, called a *system user*.  A *system user* is similar in concept to a *server user* but resides in the system database as an *OUser* record.  See [System Users](../System-Users.md).

### Accessing The System Database via Studio
By default, the OrientDB system database will not be displayed in the *Studio* drop-down list of databases.  To enable this, add a "server.listDatabases.system" resource to the "guest" server user.

Here's an example from *orientdb-server-config.xml*:
```
<user resources="connect,server.listDatabases,server.listDatabases.system" password="*****" name="guest"/>
```

### Schema
Currently, the system database has no specialized class schema, but this will changes as more features are added that utilize the private database.