---
search:
   keywords: ['java', 'osecurityuser', 'checkpassword']
---

# OSecurityUser - checkPassword()

Authenticates the given password.

## Passwords

OrientDB allows you to secure users through the use of passwords.  Using this method, you can authenticate the password given for this user.

### Syntax

```
boolean OSecurityUser().checkPassword(String password)
```

| Argument | Type | Description |
|---|---|---|
| **`password`** | `String` | Provides password for the user |

#### Return Value

This method returns a `boolean` instance.  A value of `true` indicates that the password is authentic.  A value of `false` indicates that the password is wrong.



