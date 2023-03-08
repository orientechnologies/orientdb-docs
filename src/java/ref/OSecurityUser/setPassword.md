
# OSecurityUser - setPassword()

Defines the password for the user account.

## Setting Passwords

Users in OrientDB have passwords, allowing you to authenticate their access to the Server.  Using this method you can set the password for the user account. 

### Syntax

```
OSecurityUser OSecurityUser().setPassword(String password)
```

| Argument | Type | Description |
|---|---|---|
| **`password`** | `String` | Defines the new password |

#### Return Value

This method returns the updated [`OSecurityUser`](../OSecurityUser.md) instance. You may find this useful in chaining several user operations together.

