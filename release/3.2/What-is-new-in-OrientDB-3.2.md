
## What's new in OrientDB 3.2?

### TODO

- Security enhancements (e.g. no default passwords)
- Distributed stabilization
- 3D-spatial support

## Security

In OrientDB 3.2 it is possible in the multimodel API to provide an admin user with password, instead of using a default admin user.
```
OrientDB orientdb = ...;

orientdb.execute("create database test plocal users ( admin identified by 'adminpwd' role admin)");
ODatabaseSession session = orientdb.open("test","admin", "adminpwd");
```
the roles `admin`, `writer`, `reader` are still created by default.

> It is highly recommended to take a stronger password than `adminpwd` in our example.

If the creation of default users is enabled and you try to create a user called `admin`, the creation of that user will fail.
The creation of default users can be disabled setting `CREATE_DEFAULT_USERS` to `false` as in:
```
new OrientDB(
            "...",
            OrientDBConfig.builder()
                .addConfig(OGlobalConfiguration.CREATE_DEFAULT_USERS, false)
                .build());
```

The creation of multiple admin users like `admin`, `reader`, and `writer` can be done by comma-separating
```
OrientDB orientdb = ...;

orientdb.execute("create database test plocal users ( 
            admin identified by 'adminpwd' role admin, 
            reader identified by by 'adminpwd' role reader, 
            writer identified by by 'adminpwd' role writer)");
ODatabaseSession session = orientdb.open("test","admin", "adminpwd");
```

> Deprecated APIs like `ODatabaseDocumentTx` are not affected from that change.
