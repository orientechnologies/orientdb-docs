
# ODatabaseDocument - getUser()

Retrieves the current user.

## Getting Current User

In order to connect to a database on OrientDB you need to provide specific user credentials.  Using this method, you can retrieve the user that's currently logged into the database.  You can then further operate on this instance to modify its privileges.

### Syntax

```
OSecurityUser ODatabaseDocument().getUser()
```

#### Return Value

This method returns an [`OSecurityUser`](../OSecurityUser.md) instance that corresponds to the current user.


