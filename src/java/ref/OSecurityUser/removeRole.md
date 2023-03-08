---
search:
   keywords: ['java', 'osecurityuser', 'removerole']
---

# OSecurityUser - removeRole()

Removes the given role from the user account.

## Roles

OrientDB provides a convenient way of granting users access to multiple resources in the form of roles.  For instance, in developing a web application to serve blogs, authors would need write privileges on certain parts of the database.  Administrators need other kinds of privileges.  Developing a role for these users allows you to grant them all the required privileges in one command.

Using this method you can remove the given role from the user account.

### Syntax

```
boolaen OSecurityUser().removeRole(String role)
```

| Argument | Type | Description |
|---|---|---|
| **`role`** | `String` | Defines the logical name for the role |

#### Return Value

This method returns a `boolean` instance.  A value of `true` indicates whether the role was successfully removed.

