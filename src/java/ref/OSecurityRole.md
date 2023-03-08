
# OSecurityRole

Provides an interface for working with and operating on roles.

## Using Roles

In OrientDB, roles allow you to assign privileges to a user in bulk rather than individually.  For instance, an account that needs to manage a blog would need read and write permissions on certain classes.  Roles allow you to give a new account the privileges it needs to function in one command, rather than through a series of individual grants.

To operate on roles in your application, import the class:

```java
import com.orientechnologies.orient.core.metadata.security.OSecurityRole;
```

### Methods

| Method | Return Type | Description |
|---|---|---|
| [**`addRule()`**](OSecurityRole/addRule.md) | `OSecurityRole` | Grants privilege on the given resource |
| [**`allow()`**](OSecurityRole/allow.md) | `boolean` | Determines whether role can perform the given operation on the given resource |
| [**`getDocument()`**](OSecurityRole/getDocument.md) | `ODocument` | Retrieves the internal document of the role |
| [**`getName()`**](OSecurityRole/getName.md) | `String` | Retrieves the logical name of the role |
| [**`getParentRole()`**](OSecurityRole/getParentRole.md) | `OSecurityRole` | Retrieves the parent role |
| [**`getRuleSet`**](OSecurityRole/getRuleSet.md) | [`Set<ORule>`](ORule.md) | Retrieves the rules assigned to the role |
| [**`grant()`**](OSecurityRole/grant.md) | `OSecurityRole` | Grants privileges on the given resource |
| [**`hasRule()`**](OSecurityRole/hasRule.md) | `boolean` | Determines whether the role can access the given resource |
| [**`revoke()`**](OSecurityRole/revoke.md) | `OSecurityRole` | Revokes access to the given resource |
| [**`setParentRole()`**](OSecurityRole/setParentRole.md) | `OSecurityRole` | Sets the parent role |
