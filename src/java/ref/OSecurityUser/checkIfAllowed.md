
# OSecurityUser - checkIfAllowed()

Determines whether the user account has the necessary privileges perform the given operation.

## Checking Access

OrientDB defines the degree of access and permitted operations with a set of rules defined for the given user account or role.  Using this method, you can check whether the user is allowed to perform the given operation.

### Syntax

```
OSecurityRole OSecurityUser().checkIfAllowed(
	ORule.ReosurceGeneric resourceGeneric,
	String resourceSpecific,
	int operation)
```

| Argument | Type | Description |
|---|---|---|
| **`resourceGeneric`** | [`ORule.ResourceGeneric`](../ORule.md) | Defines the generic resource to check |
| **`resourceSpecific`** | `String` | Defines the specific resource to check |
| **`operation`** | `int` | Defines the operation to check |


