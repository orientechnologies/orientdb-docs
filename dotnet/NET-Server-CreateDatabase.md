---
search:
   keywords: ['.NET', 'C#', 'C sharp', 'OServer', 'create database', 'create']
---

# OrientDB-NET - `CreateDatabase()`

This method creates a database on the connected OrientDB Server.  It then returns a boolean value to indicate that the operation was successful.

## Creating Databases

When you initialize your C#/.NET application, you may find it useful to provision an OrientDB database as part of the installation process.  This ensures that you'll have a database ready when you first run the application.  You can create databases on the OrientDB Server by calling the `CreateDatabase()` method on the [`OServer`](NET-Server.md) interface.


### Syntax

```
bool OServer.CreateDatabase(
   string name,
   ODatabaseType type,
   OStorageType storage)
```

- **`name`** Defines the name of the database.
- **`type`** Defines the type of database you want to create, that is a Graph, Document or Object Database.
- **`storage`** Defines the type of storage you want to use. That is, physical or in-memory.

When the operation is complete, the method returns a boolean value indicated that the new database now exists.

### Examples

For instance, imagine an application that utilizes a series of in-memory databases for various services that you want to provide.  You might construction a method such as this to use when provisioning new servers:


```c-sharp
using Orient.Client;
using System;
...

// PROVISION ORIENTDB SERVER
public void InitServer(OServer server, string[] names)
{
   // LOG OPERATION 
   Console.WriteLine("Creating Databases:");

   // LOOP OVER DATABASE NAMES
   foreach(string name in names)
   {
      // CREATE DATABASE
      bool dbCheck = server.CreateDatabase(name,
         ODatabaseType.Graph,
         OStorageType.Memory);

      // REPORT CREATION 
      if(dbCheck) 
      {
         Console.WriteLine(" - SUCCESS: {0}", name);
      }
      else
      {
         Console.WriteLine(" - FAILURE: {0}", name);
      }
   }
}
```
