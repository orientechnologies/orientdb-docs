---
search:
   keywords: ['Java', 'OrientDB', 'exists']
---

# OrientDB - exists()

This method determines whether a database exists on the OrientDB Server.

## Checking Databases

In situations where your application is one of several connecting to a given OrientDB Server, you may find it useful to check whether a database exists before attempting to open or operate on it.  This method checks if the OrientDB Server has a database of the given name available. 

### Syntax

```
pblic boolean OrientDB().exists(String name)
```

| Argument | Type | Description
|---|---|---|
| **`name`** | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Defines the database name |

### Example

Consider the use case of an application that uses multiple in-memory databases for short-term operations.  Whenever you call the method to create the database, you want a new database.  If the OrientDB Server already contains a database of that name, you want to increment the name and start fresh.

```java
private OrientDB orientdb;

// Create New In-Memory Database
public ODatabaseDocumentTx createDatabase(String name){

   // Check If Database Exists
   if (orientdb.exists(name){
      name = name + "1";
   }

   // Create Database
   orientdb.create(name, ODatabaseType.MEMORY);

   // Return Opened Database
   return orientdb.open(name, "admin", "admin");

}
```

