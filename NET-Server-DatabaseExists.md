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
- **`<storage>`** Defines the storage type you want, such as PLocal or Memory.

The method returns a boolean value, indicating whether or not it found the requested database on the server.

### Example

Consider the example of a web application, where you have multiple instances of OrientDB Server and multiple clients attempting to connect to and operate on the databases.  You might have a line that checks whether a database exists on the server before attempting to create it.

```csharp
bool checkForDB = server.DatabaseExists(
   "microblog",
   OStorageType.PLocal);

// CREATE DB WHEN NEEDED
if (checkForDB == false)
{
   server.CreateDatabase(
      "microblog",
      ODatabaseType.Graph,
      OStorageType.PLocal);
}
```
