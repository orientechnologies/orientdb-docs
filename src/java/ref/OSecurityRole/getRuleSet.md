
# OSecurityRole - getRuleSet()

Retrieves the rules assigned to this role.

## Rule Sets

OrientDB defines the role's access to resources using a series of [`ORule`](../ORule.md) instances.  Using this method, you can retrieve a set of all rules assigned to this account.

### Syntax

```
Set<ORule> OSecurityRole().getRuleSet()
```

#### Return Value

This method returns a `Set` instance containing all of the [`ORule`](../ORule.md) instances connected to this role.

