---
search:
   keywords: ['Java API', 'OServer', 'get database directory', 'getDatabaseDirectory']
---

# OServer - getDatabaseDirectory()

This method returns the root directory for databases handled by the OrientDB Server.

## Retrieving Database Directories

When using the PLocal storage-type, OrientDB writes persistent data to the file system, with one directory for each database.  This method returns the root directory that the given [`OServer`](../OServer.md) instance uses in storing databases.

### Syntax

```
public String OServer().getDatabaseDirectory()
```

#### Return Value

This method returns a [`String`]({{ book.javase }}/api/java/lang/String.html) value.  It provides the path to where the OrientDB Server stores its databases.

### Example

When OrientDB writes to PLocal storage, it writes the database to the file system in a particular directory.  Occasionally, you may need to operate on this directory or otherwise reference it elsewhere in your application.

```java
/**
 * Retrieve and Log the Database Directory
 */
public String fetchDbDir(OServer oserver){

   // Log Operation
   logger.info("Retrieving Database Directory");

   // Fetch Database Directory
   String path = oserver.getDatabaseDirectory();

   // Report Location for Debugging
   logger.debug("Database Directory: " + path);

   // Return Directory Path
   return path;
}
```
