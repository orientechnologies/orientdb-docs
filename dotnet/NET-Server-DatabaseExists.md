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

For instance, say that you have a complex application that utilizes several databases in-memory on an OrientDB Server.  The in-memory storage type is volatile and is lost in the event that the server shuts down or the host crashes.  As such, you may want to create a basic test function to determine whether a series of databases exist on the server before you attempt operations.  If the database doesn't exist, you'll need to create it.

```csharp
using Orient.Client;
using System;
...

// CHECK THAT DATABASES EXIST
public void checkDatabases(OServer server, string[] databases)
{
   Console.WriteLine("Checking that databases exists...");

   // LOOP OVER EACH REQUIRED DATABASE
   foreach(string database in databases)
   {
      // DETERMINE IF DATABASE EXISTS
      bool dbExists = server.DatabaseExists(database,
         OStorageType.Memory);

      // CREATE DATABASE 
      if(dbExists == false)
      {
         Console.WriteLine("Database {0} doesn't exist, creating...",
            database);
         // CREATE NONEXISTENT DATABASE
         server.CreateDatabase(database,
            ODatabaseType.Graph,
            OStorageType.Memory);
      }

      // REPORT IF DATABASE EXISTS
      else
      {
          Console.WriteLine("Database {0} exists already",
             database);
      }
   }   
}
```
