---
search:
   keywords: ['java', 'osecurityuser', 'addrole']
---

# OSecurityUser - addRole()

Adds the given role to the user account.

## Roles

Rather than creating a series of users and apply permissions to those users individually, OrientDB allows you to define roles for the user.   A role provides a series of permissions, granting the user access to whatever resources they may require to perform the given action on the database.  Using this method, you can add a role to the user account.

### Syntax

```
OSecurityUser OSecurityUser().addRole(OSecurityRole role)
```

| Argument | Type | Description |
|---|---|---|
| **`role`** | [`OSecurityRole`](../OSecurityRole.md) | Defines the role you want to add |


#### Return Value

This method returns the updated [`OSecurityUser`](../OSecurityUser.md) instance.  You can then use the return value to chain several operations together in preparing a user to operate on the database.

