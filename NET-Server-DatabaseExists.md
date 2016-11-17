---
search:
   keywords: ['.NET', 'C#', 'c sharp', 'OServer', 'database exists']
---

# OrientDB-NET - `DatabaseExists()`

This method determines whether or not a database exists already on the OrientDB Server.  It returns a boolean value indicating what it finds.

## Checking Databases

In order to check that databases exist on the server, you first need to create an [`OServer`](NET-Server.md) instance.  Once you have it, you can call the [`DatabaseExists()`](#) method on it.

### Syntax

```
bool OServer.DatabaseExists(
   string <name>,
   OStorageType <storage>)
```

- **`<name>`** Defines the name of the database you want.
- **`<storage>`** Defnes the storage type you want, such as PLocal or Memory.

The method returns a boolean value, indicating whether or not it found the requested database on the server.

### Example

Consider the example of the microblog service.  You might combine this method with the [`CreateDatabase()`](NET-Server-CreateDatabase.md) method in a check.  That is, determine whether a database exists and create it if it doesn't exist. 




