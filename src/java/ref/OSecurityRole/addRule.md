
# OSecurityRole - addRule()

Grants access to the given resource to the role.

## Adding Rules

OrientDB defines resources and the user or role's access to the resource defined using [`ORule`](../ORule.md) instances.  Using this method, you can add a rule to the role.

### Syntax

```
OSecurityRole OSecurityRole().addRule(
	ORule.ResourceGeneric resourceGeneric,
	String resourceSpecific,
	int operation)
```

| Argument | Type | Description |
|---|---|---|
| **`resourceGeneric`** | [`ORule.ResourceGeneric`](../ORule.md) | Defines the generic resource |
| **`resourceSpecific`** | `String` | Defines the specific resource |
| **`operation`** | `int` | Defines the allowed operation |

#### Return Value

This method returns an [`OSecurityRule`](../OSecurityRole.md) instance.  You may find this useful in chaining several operations together.


