
## What's new in OrientDB 3.2?

### TODO

- Security enhancements (e.g. no default passwords)
- Distributed stabilization
- 3D-spatial support

## Security

In OrientDB 3.2 it is mandatory to create an admin user with a password.

```
OrientDB orientdb = ...

orientdb.execute("create database test plocal users ( admin identified by 'adminpwd' role admin)");
ODatabaseSession session = orientdb.open("test","admin", "adminpwd");
```

> it is highly recommended to take a stronger password than `adminpwd` in our example.
