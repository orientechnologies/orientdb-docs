---
search:
   keywords: ['.NET', 'C#', 'C sharp', 'OServer', 'create database', 'create']
---

# OrientDB-NET - `CreateDatabase()`

This method creates a database on the connected OrientDB Server.  It then returns a boolean value to indicate that the operation was successful.

## Creating Databases

In order to create a database using this method, you first need to create an [`OServer`](NET-Server.md) instance.

### Syntax

```
bool OServer.CreateDatabase(
   string <name>,
   ODatabaseType <type>,
   OStorageType <storage>)
```

- **`<name>`** Defines the name of the database.
- **`<type>`** Defines the type of database you want to create, that is a Graph, Document or Object Database.
- **`<storage>`** Defines the type of storage you want to use. That is, physical or in-memory.

When the operation is complete, the method returns a boolean value indicated that the new database now exists.

### Examples

Consider the use case of a microblog service that runs on bare metal servers in Docker containers.  In provisioning server, you might create an instance of `OServer` then use it to create an in-memory database on OrientDB.  For instance,

```c-sharp
// Create Database
server.CreateDatabase(
   "microblog",
   ODatabaseType.Graph,
   OStorageType.Memory);
```
