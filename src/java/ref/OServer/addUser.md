
# OServer - addUser()

This method adds a user to the OrientDB Server.

## Adding Users

OrientDB differentiates between users with access to the server and users with access to the database.  This method relates to adding users to the server.

### Syntax

```
public void OServer().addUser(String user, 
		String passwd,
		String permission)
```

| Argument | Type | Description |
|---|---|---|
| **`user`** | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Defines the user name. |
| **`passwd`** | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Defines the password for the new user. |
| **`permission`** | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Defines the permission-level for the new user. |

#### Exception

This method throws the following exception,

- [`IOException`]({{ book.javase }}/api/java/io/IOException.html)


### Example

Imagine you have a web application running on a distributed deployment.  You may want a method in the class that manages your OrientDB Server instances to use in creating server users.

```java

/**
 * Create New User
 */
public Boolean createUser(OServer oserver, 
      String user, String passwd, String permission){ 
    
   // Log Operation
   logger.info("Creating New User: " + user);

   try {
      // Create User 
      oserver.addUser(user, passwd, permission);
	  return true;

   } catch(IOException err){
      logger.warn("Error Creating User: " +
	     err.getMessage());
      return false;

   }
}
```
