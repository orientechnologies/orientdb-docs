---
search:
   keywords: ['java', 'osecurityrole', 'allow']
---

# OSecurityRole - allow()

Determines whether the role is allowed to access the given resource.

## Checking Access

OrientDB defines resources and the user or role's access to the resource defined using [`ORule`](../ORule.md) instances.   Using this method, you can determine whether the given role is allowed to access the given resource. 

### Syntax

```
boolean OSecurityRole().allow(
	ORule.ResourceGeneric resourceGeneric,
	String resourceSpecific,
	int operation)
```

| Argument | Type | Description |
|---|---|---|
| **`resourceGeneric`** | [`ORule.ResourceGeneric`](../ORule.md) | Defines the generic resource |
| **`resourceSpecific`** | `String` | Defines the specific resource |
| **`operation`** | `int` | Defines the operation you want to check |

#### Return Value

This method returns a `boolean` instance.  A value of `true` indicates that the role does have permission to operate on the resource.




