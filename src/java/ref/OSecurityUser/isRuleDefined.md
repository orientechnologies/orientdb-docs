
# OSecurityUser - isRuleDefined()

Determines whether the given rule is defined for the user.

## Rules

OrientDB defines a user's access to various resources through a set of rules, defined as [`ORule`](../ORule.md) instances.  Using this method, you can determine if a rule has been defined for a specific resource for this user.

### Syntax

```
boolean OSecurityUser().isRuleDefined(
   ORule.ResourceGeneric resourceGeneric,
   String resourceSpecific)
```

| Argument | Type | Description |
|---|---|---|
| **`resourceGeneric`** | [`ORule.ResourceGeneric`](../ORule.md) | Defines the generic resource for the rule |
| **`resourceSpecific`** | `String` | Defines the specific resource to check |

#### Return Value

This method returns a `boolean` instance.  A value of `true`, indicates that the user does have a rule to access the given resource.


