
# OSecurityUser - setName()

Defines the logical name for the user.

## Logical User Names

Where your Java application interacts with users through the [`OSecurityUser`](../OSecurityUser.md) interface, in OrientDB SQL the users are identified by their logical names.  Using this method, you can set the logical name for the user.

### Syntax

```
OSecurityUser OSecurityUser().setName(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | `String` | Defines the logical name for the user |

#### Return Value

This method returns the updated [`OSecurityUser`](../OSecurityUser.md) instance, which you can then use in chaining several operations together.

