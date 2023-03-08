
# OSecurityRole - revoke()

Removes access to the given resource from the role.

## Revoking Access

OrientDB defines the resources that the role can access and what privileges they have on that resource using a set of rules.  Using this method, you can remove a rule from the set, effectively revoking the role's access to the resource.


### Syntax

```
OSecurityRole OSecurityRole().revoke(
	ORule.ResourceGeneric resourceGeneric,
	String resourceSpecific,
	int operation)
```

| Argument | Type | Description |
|---|---|---|
| **`resourceGeneric`** | [`ORule.ResourceGeneric`](../ORule.md) | Defines the generic resource to remove |
| **`resourceSpecific`** | `String` | Defines the specific resource to remove |
| **`operation`** | `int` | Defines the operation to revoke |

#### Return Value

This method returns the updated [`OSecurityRole`](../OSecurityRole.md) instance.  You may find this useful in chaining several operations together.


