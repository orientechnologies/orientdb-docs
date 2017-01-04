---
search:
   keywords: ['.NET', 'C#', 'c sharp', 'OrientDB-NET', 'drop database', 'DropDatabase']
---

# OrientDB-NET - `DropDatabase()`

This method removes a database from the OrientDB Server.  It returns no value.

## Removing Databases

To remove a database from the server, you need to call the `DropDatabase()` method on the [`OServer`](NET-Server.md) instance.

### Syntax

```
void OServer.DropDatabase(
   string <name>,
   OStorageType <storage>)
```

- **`<name>`** Defines the name of the database you want to remove.
- **`<storage>`** Defines the storage type of the database.

### Example

Consider the use case of an application where you encounter a critical flaw in the database and need to remove it and restore its content from backups.

```csharp
if (check == true)
{
   void server.DropDatabase(
      "microblog",
      OStorageType.PLocal);
}
```
