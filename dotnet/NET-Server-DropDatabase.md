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

For instance, say you have an application that requires you to periodically reset databases, removing all records then initializing a new instance.

```csharp
public void cleanDatabases(OServer server, string[] databaseNames)
{
   // LOOP OVER DATABASE NAMES ARRAY
   foreach(string name in databaseNames)
   {
      // REMOVE EXISTING DATABASE
      server.DropDatabase(name, OStorageType.Memory);

      // CREATE NEW DATABASE
      bool createdDb = server.CreateDatabase(name,
         ODatabaseType.Graph, OStorageType.Memory);

      // TEST
      Assert.IsTrue(createDb);
   }
}
```
