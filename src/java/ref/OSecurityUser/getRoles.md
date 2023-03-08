
# OSecurityUser - getRoles()

Returns the set of roles assigned to this user.

## User Roles

OrientDB provides a convenient way of granting users access to multiple resources in the form of roles.  For instance, in developing a web application to serve blogs, authors would need write privileges on certain parts of the database.  Administrators need other kinds of privileges.  Developing a role for these users allows you to grant them all the required privileges in one command.

Using this method, you can retrieve all the roles assigned to the user account.

### Syntax

```
Set<? extends OSecurityRole> OSecurityUser().getRoles()
```

#### Return Value

This method returns a `Set` instance.  The set contains the roles assigned to the user.  Each role is a class that extends the [`OSecurityRole`](../OSecurityRole.md) class.


