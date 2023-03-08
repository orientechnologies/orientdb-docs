
# OServer - dropUser()

This method removes a user from the OrientDB Server.

## Removing Users

OrientDB differentiates between users with access to the server and users with access to the database.  Occasionally, you may need to manage users on your server instances.  This method allows you to remove them.

### Syntax

```
public void OServer().dropUser(String iUser)
```

| Argument | Type | Description |
|---|---|---|
| **`iUser`** | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Defines the user you want to remove |

#### Exceptions

This method throws the following exception:

- [`IOException`]({{ book.javase }}/api/java/io/IOException.html)

### Example

Consider the use case of a web application.  You may want to provide administrators and scripts access to manage server users, such as remove credentials when an administrator leaves the company.

In the class that manages your [`OServer`](../OServer.md) instances, you might want a method to streamline this process and log the event for you.

```java
/**
 * Remove OServer User
 */
public Boolean removeUser(OServer oserver, String user){

   // Log Operation
   logger.info("Removing User: " + user);

   try {

      // Remove USer
      oserver.dropUser(user);
	  return true;

   } catch(IOException err){

      // Report Exception
      logger.warn("Unable to Remove User: " +
	     err.getMessage());
      return false;
   }
}
```
