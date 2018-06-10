---
search:
   keywords: ['java', 'OrientDB', 'open database', 'open']
---

# OrientDB - open()

This method opens the given database on the OrientDB Server.

## Openning Databases

The [`OrientDB`](../OrientDB.md) class allows you to operate on an OrientDB Server, but eventually you're going to want to start working with an actual database.  This method allows you to open a Document database on the server.

### Syntax

There are two methods available to use in opening databases:

```
// METHOD 1
public ODatabaseDocument OrientDB().open(String name, String user, 
   String passwd)

// METHOD 2
public ODatabaseDocument OrientDB().open(String name, String user,
   String passwd, OrientDBConfig config)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the database name |
| **`user`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the database user |
| **`passwd`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the user password |

#### Return Value 

Both methods return an [`ODatabaseDocument`](../ODatabaseDocument.md) instance.

### Example

Imagine the use case of an application to operates on several databases that share common login credentials.  You might create a management class to streamline database access within your code.

```java
// INITIALIZE VARIABLES
private String rootUser;
private String rootPasswd;
private String baseUser;
private String basePasswd;
private OrientDB orientdb;
...

// OPEN DATABASE
public ODatabaseDocument openDb(String name, Boolean asRoot){

   // Log Operation
   logger.info("Opening Database: " + name);

   // Initialize Variables
   String user;
   String passwd;

   if (asRoot){
      user = rootUser;
	  passwd = rootPasswd;

   } else { 
      user = baseUser;
	  passwd = basePasswd;
   }

   // Open and Return Database
   return orientdb.open(name, user, passwd);

}
```


