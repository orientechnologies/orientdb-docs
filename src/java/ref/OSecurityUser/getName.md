
# OSecurityUser - getName()

Retrieves the logical name of the user.

## Logical Names 

Where your Java application interacts with users through the [`OSecurityUser`](../OSecurityUser.md) interface, in OrientDB SQL the users are identified by their logical names.  Using this method, you can retrieve the logical name for the user, which you may find useful for logging and authentication purposes.

### Syntax

```
String OSecurityUser().getName()
```

#### Return Value

This method returns a `String` value, which provides the logical name of the user.



