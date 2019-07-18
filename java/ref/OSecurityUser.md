---
search:
   keywords: ['java', 'osecurityuser']
---

# OSecurityUser

Provides an interface for working with or operating on particular users of the OrientDB Server or databases.

## Working with Users

OrientDB maintains an internal set of users with various privileges assigned to these users, granting them access to the Server itself or to particular databases on the Server.  Using this class you can work with or operate on an individual user.

To use the `OSecurityUser` interface in your code, you need to import it.

```java
import com.orientechnologies.orient.core.metadata.security.OSecurityUser;
```

### Methods

| Method | Return Type | Description |
|---|---|---|
| [**`addRole()`**](OSecurityUser/addRole.md) | `OSecurityUser` | Adds a role to the user |
| [**`checkPassword()`**](OSecurityUser/checkPassword.md) | `OSecurityUser` | Authenticates user password |
| [**`getAccountStatus()`**](OSecurityUser/getAccountStatus.md) | `OSecurityUser.STATUSES` | Retrieves the status of the user account | 
| [**`getName()`**](OSecurityUser/getName.md) | `String` | Retrieves the logical name for the user |
| [**`getPasword()`**](OSecurityUser/getPassword.md) | `String` | Retrieves the user password |
| [**`getRoles`**](OSecurityUser/getRoles.md) | [`Set<? extends OSecurityRole>`](OSecurityRole.md) | Retrieves the roles assigned to this user |
| [**`hasRole()`**](OSecurityUser/hasRole.md) | `boolean` | Determines whether the user has the given role |
| [**`removeRole()`**](OSecurityUser/removeRole.md) | `boolean` | Removes the given role from the user |
| [**`setAccountStatus()`**](OSecurityUser/setAccountStatus.md) | `void` | Defines the status for the user account |
| [**`setName()`**](OSecurityUser/setName.md) | `OSecurityUser` | Defines the logical name for the user |
| [**`setPassword()`**](OSecurityUser/setPassword.md) | `OSecurityUser` | Defines the user password |



