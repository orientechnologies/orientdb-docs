
## What's new in OrientDB 3.2?


## Security


With the OrientDB 3.2 multimodel API some important changes were implemented on Database creation.
The most important one is that basic database users (admin, reader, writer) are no longer created by default.
This is the consequence of some considerations about Security: having default passwords (eg. admin/admin) is a bad practice
and exposes OrientDB installations to possible attacks.

Of course it's possible to explicitly trigger user creation and to provide a custom password, instead of using a default admin user.
```java
final OrientDB orientdb = ...;

orientdb.execute("create database test plocal users ( admin identified by 'adminpwd' role admin)");
final ODatabaseSession session = orientdb.open("test","admin", "adminpwd");
```
the roles `admin`, `writer`, `reader` are still created by default.

> It is highly recommended to take a stronger password than `adminpwd` in our example.

If the creation of default users is enabled and you try to create a user called `admin`, the creation of that user will fail.
The creation of default users can be disabled setting `CREATE_DEFAULT_USERS` to `false` as in:
```java
new OrientDB("...",
             OrientDBConfig.builder()
                .addConfig(OGlobalConfiguration.CREATE_DEFAULT_USERS, false)
                .build());
```

The creation of multiple admin users like `admin`, `reader`, and `writer` can be done by comma-separating
```java
final OrientDB orientdb = ...;

orientdb.execute("create database test plocal users ( 
            admin identified by 'adminpwd' role admin, 
            reader identified by by 'adminpwd' role reader, 
            writer identified by by 'adminpwd' role writer)");
final ODatabaseSession session = orientdb.open("test","admin", "adminpwd");
```

From Studio, there is a new option that allows you to define the default admin password on the Database Create dialog.

The old defaults can be restored (for backward compatibility) by setting `-Dsecurity.createDefaultUsers=true` at startup

> Deprecated APIs like `ODatabaseDocumentTx` are not affected from that change.
> 

## Server-Level Commands

TODO

## Distributed enhancements and stabilization

- fixes
- unique index by quorum

TODO

## GraalVM support

TODO




