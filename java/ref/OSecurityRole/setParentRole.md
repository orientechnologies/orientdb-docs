---
search:
   keywords: ['java', 'osecurityrole', 'setparentrole']
---

# OSecurityRole - setParentRole()

Defines the parent of this role.

## Roles

Rather than creating a new role and assigning to it each and every privilege needed, you can instead assign it a parent role with all the privileges that come with it.  Using this method, you can set the parent [`OSecurityRole`](../OSecurityRole.md) instance.

### Syntax

```
OSecurityRole OSecurityRole().setParentRole(
	OSecurityRole parentRole)
```

| Argument | Type | Description |
|---|---|---|
| **`parentRole`** | [`OSecurityRole`](../OSecurityRole.md) | Defines the parent role to set |

#### Return Value

This method returns the updated role, an [`OSecurityRole`](../OSecurityRole.md) instance.  You may find this useful when chaining several operations together.





