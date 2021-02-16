
## What's new in OrientDB 3.2?

### TODO

- Security enhancements (e.g. no default passwords)
- Distributed stabilization
- 3D-spatial support

## Security

In OrientDB 3.2 it is possible to provide an admin user with password, instead of using a default admin user.
```
OrientDB orientdb = ...;

orientdb.execute("create database test plocal users ( admin identified by 'adminpwd' role admin)");
ODatabaseSession session = orientdb.open("test","admin", "adminpwd");
```
the roles `admin`, `writer`, `reader` are still created by default.

> it is highly recommended to take a stronger password than `adminpwd` in our example.

If the creation of default users is enabled and you try to create a user called `admin`, the creation of that user will fail.
The creation of default users can be disabled setting `CREATE_DEFAULT_USERS` to `false` as in:
```
new OrientDB(
            "...",
            OrientDBConfig.builder()
                .addConfig(OGlobalConfiguration.CREATE_DEFAULT_USERS, false)
                .build());
```
