---
search:
   keywords: ['java', 'osecurityrole', 'getparentrole']
---

# OSecurityRole - getParentRole()

Retrieves the parent of this role.

## Roles

Rather than creating a new role and assigning to it each and every privilege needed, you can instead assign it a parent role with all the privileges that come with it.  Using this method, you can retrieve the parent [`OSecurityRole`](../OSecurityRole.md) instance.

### Syntax

```
OSecurityRole OSecurityRole().getParentRole()
```

#### Return Value

This method returns the parent role, an [`OSecurityRole`](../OSecurityRole.md) instance.





