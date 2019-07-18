---
search:
   keywords: ['java', 'osecurityrole', 'hasrule']
---

# OSecurityRole - hasRule()

Determines whether the role can access the given resources.

## Rules

OrientDB stores the privileges granted to a given user account or role as a set of rules, granting access to various resources.  Using this method, you can determine whether a role can access the given resource.

### Syntax

```
boolean OSecurityRole().hasRule(
	ORule.ResourceGeneric resourceGeneric,
	String resourceSpecific)
```

| Argument | Type | Description |
|---|---|---|
| **`resourceGeneric`** | [`ORule.ResourceGeneric`](../ORule.md) | Defines the generic resource to check |
| **`resourceSpecific`** | `String` | Defines the specific resource to check |

#### Return Value

This method returns a `boolean` instance.  A value of `true` indicates that the role can access the given resource.


