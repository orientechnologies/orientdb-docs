---
search:
   keywords: ['java', 'osecurityrole', 'grant']
---

# OSecurityRole - grant()

Grants privileges to users with this role.

## Granting Privileges

Privileges in OrientDB are defined as a series of rules set on the user or role.  Using this method, you can add privileges to the role. 

### Syntax

```
OSecurityRole OSecurityRole().grant(
	ORule.ResourceGeneric resourceGeneric,
	String resourceSpecific,
	int operation)
```

| Argument | Type | Description |
|---|---|---|
| **`resourceGeneric`** | [`ORule.ResourceGeneric`](../ORule.md) | Defines the generic resource |
| **`resourceSpecific`** | `String` | Defines the specific resource |
| **`operation`** | `int` | Defines the operation you want to enable |

#### Return Value

This method returns the updated [`OSecurityRole`](../OSecurityRole.md) instance.  You may find this useful when chaining several operations together.

