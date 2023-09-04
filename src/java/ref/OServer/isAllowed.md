
# OServer - isAllowed()

This method determines whether a user is allowed to operate the given resource.

## Checking Users

Different users have different levels of access to the OrientDB Server.  When a user attempts an operation that exceeds their access, it raises an exception.  Rather than providing all options and letting the user fail, you can use this method to perform a basic check, determining what they can do before giving the option.

### Syntax

```
public boolean OServer().isAllowed(String user, String resource)
```

| Argument | Type | Description |
|---|---|---|
| **`user`** | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Defines the user you want to check. |
| **`resource`** | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Defines the resource you want to check. |

#### Return Value

This method returns a [`boolean`]({{ book.javase }}/api/java/lang/Boolean.html) value.  If the return value is `true`, it indicates that the user has permission to access the given resource.

### Example

Consider the use case of an application that needs to perform several operations on various OrientDB Servers.  In the class that manages the server, you might want to create a method to streamline these operations into a basic check that can be called wherever you need it in the class.

```java
private OServer oserver;
private String currentUser;
private String currentResource;
...

/**
 * Check Permission
 */
public Boolean checkResource(){
   return oserver.isAllowed(currentUser, currentResource);
}
```
