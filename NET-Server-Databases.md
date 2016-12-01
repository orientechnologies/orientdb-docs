---
search:
   keywords: ['.NET', 'C#', 'c sharp', 'OrientDB-NET', 'OServer', 'ODatabaseInfo']
---

# OrientDB-NET - `Databases()`

This method retrieves information on the current databases available on the OrientDB Server.  The return value is a dictionary of string keys and `ODatabaseInfo` objects.

## Retrieving Database Information

When your application connects to the OrientDB Server, 

### Syntax

```
Dictionary<string, ODatabaseInfo> Databases()
```

This method takes no arguments.  The return value is a dictionary with string value keys and `ODatabaseInfo` object values.  This object has three variables:

| Variable | Type |Description |
|---|---|---|
| `DataBaseName` | `string` | The database name |
| `StorageType` | `OStorageType` | The storage type, (PLocal or Memory) |
| `Path` | `string` | The database URL |


### Examples

For instance, you might want to occasionally check the health of a server, performing routine checks on each database in the server.  Rather than calling them individually, you can use this method to retrieve information on all databases to then iterate over with your tests.

```csharp
// FETCH DB DICTIONARY
Dictionary<string, ODatabaseInfo> dbDict = server.Databases();
```
