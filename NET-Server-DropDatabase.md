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

For instance, consider the example of a microblog service.  Consider the use case of a house keeping method.  In the event that your application encounters a critical issue you would like to remove the database entirely and start fresh from backups.

```csharp
public void CriticalRemoval(OServer server)
{
   server.DropDatabase(server, OStorageType.Memory);
   
}
```
