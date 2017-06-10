---
search:
   keywords: ['Java API', 'OServer', 'authenticate server user', 'authenticate']
---

# OServer - authenticate()

This method authenticates a user on the OrientDB Server.

## Authenticating Users

OrientDB differentiates between users that operate on the server and users that operate on the database.  This method allows you to authenticate the given user for server operations.

### Syntax

```
public boolean OServer().authenticate(String user, String passwd, String resource)
```

| Argument | Type | Description |
|---|---|---|
| **`user`** | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Defines the user to authenticate. |
| **`passwd`** | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Defines the password for the user. |
| **`resource`** | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Defines the resource to authenticate on. |


### Example

Imagine you have a web application running on a distributed deployment.  You may want a method in the class that manages your OrientDB Server instances to use in authenticating server users.

```java

/**
 * Authenticate User
 */
public Boolean authUser(OServer oserver, 
      String user, String passwd, String resource){ 
    
   // Log Operation
   logger.info("Authenticating User: " + user);

   return oserver.authenticate(ser, passwd, resorce);
}
```
