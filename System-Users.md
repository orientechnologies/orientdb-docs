# System Users #

Traditionally, in OrientDB, there have been two types of users: a *server user* and a *database user*.

A *server user* is specified in the `<users>` section of the *orientdb-server-config.xml* file or as a user object in the ODefaultPasswordAuthenticator section of *security.json*.  A *server user* typically has a name, a password, and a list of permitted resources to server-related activities that are not specific to a single database.  An example is "server.info" which permits returning such things as the currently active client connections, the databases on the server, and a list of global properties.  

A *database user* resides in each database as an *OUser* record, and its associated roles and permissions apply only to that database.

A third type of user now exists, called a *system user*.  A *system user* is similar in concept to a *server user* but resides in the [system database](System-Database.md) as an *OUser* record.  Like a *database user*, a *system user* is assigned roles that are comprised of resources and permissions.  See [Database Security](http://orientdb.com/docs/last/Database-Security.html).  What's unique about a *system user* is that its roles may be specified per-database or against the server, depending on the chosen resource. 

## Authenticator
To support the *system users* a new authenticator has been added, called *OSystemUserAuthenticator*.  It is enabled, by default, in the *security.json* configuration file, and has been added in the chain of authenticators.  See [New Security Features](Security-OrientDB-New-Security-Features.md).

## Users and Roles
To create new *System users*, they are added to the system database, and the procedure is identical to adding a user as outlined in [Database Security](http://orientdb.com/docs/last/Database-Security.html).

The main difference between a *system user* and a *database user* comes with roles.  A role can be created that allows a *system user* to have access to a specific database, multiple databases, or all databases while still supporting the standard database resources (such as *database*, *database.class*, *database.cluster*, *database.command*).

The way this is achieved is by adding a property to the ORole record, called *dbFilter*.  As an example, say we have an OrientDB class called *Car*, and we want to create a role to allow a user to modify all the *Car* records.  For a regular *database user*, we'd do something like this:
```
INSERT INTO ORole SET name = "carAdmin", mode = 0
UPDATE ORole PUT rules = "database.class.Car", 15 WHERE name = "carAdmin"
```

These commands will create a new role called *carAdmin* with a mode of "deny all but", and will add a rule to the role granting all permissions (create, read, update, delete) to modify the *Car* class.

To make this work for a *system user*, we make a small change by adding a *dbFilter* property to the role.  Here's an example allowing a role to access the *MyCarDB* database:
```
UPDATE ORole SET dbFilter = ["MyCarDB"] WHERE name = "carAdmin"
```

The *dbFilter* property is a list of strings indicating which databases a role is allowed to access.  A wildcard ("*") may be specified to permit access to all databases.

## Server Resources
What's unique about a *system user* is that it's essentially a hybrid of a *server user* and a *database user*.  A *server user* has access to a finite number of server-related resources (such as *server.info*, *server.listDatabases*, and *db.copy*).  A *system user* also has access to the same server resources as a *server user* has, but the resource name is added as a rule of a role.

Here's an example of adding the resource *server.info* to a role called *sysinfo*. 
```
UPDATE ORole PUT rules = "server.info", 16 WHERE name = "sysinfo"
```

Notice that a new permission (16 - execute) has been specified for the *server.info* rule.  Server resources typically have execute-only permission.

The previously mentioned, database-specific property, *dbFilter*, is not set on the role since *server.info* is specific to the server and not an individual database.
