
# OSecurityUser - hasRole()

Determines whether the user has the given role.

## Roles

OrientDB provides a convenient way of granting users access to multiple resources in the form of roles.  For instance, in developing a web application to serve blogs, authors would need write privileges on certain parts of the database.  Administrators need other kinds of privileges.  Developing a role for these users allows you to grant them all the required privileges in one command.

Using this method you can determine whether the user account has access to the given role.

### Syntax

```
boolean OSecurityUser().hasRole(
	String role,
	boolean includeInherted)
```

| Argument | Type | Description |
|---|---|---|
| **`role`** | `String` | Defines the logical name of the role |
| **`includeInherted`** | Defines whether to include roles that inherit from the given role |

#### Return Value

This method returns a `boolean` instance.  A value of `true` indicates that the user account has the given role.  A value of `false` indicates that it doesn't have the given role.

