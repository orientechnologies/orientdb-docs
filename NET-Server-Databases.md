---
search:
   keywords: ['.NET', 'C#', 'c sharp', 'OrientDB-NET', 'OServer', 'ODatabaseInfo']
---

# OrientDB-NET - `Databases()`

This method retrieves information on the current databases available on the OrientDB Server.  The return value is a dictionary of string keys and `ODatabaseInfo` objects.

## Retrieving Database Information

In certain situations you may need to operate on multiple databases on a given OrientDB Server, such as testing certain conditions on each database available.  When the given databases are arbitrary, (that is, the names are not fixed by variables within your application), you can retrieve all databases on the given [`OServer`](NET-Server.md) instance using this method. 

### Syntax

```
Dictionary<string, ODatabaseInfo> OServer.Databases()
```

This method takes no arguments.  The return value is a dictionary with string value keys and `ODatabaseInfo` object values.  Each `ODatabaseInfo` object has three variables:

| Variable | Type |Description |
|---|---|---|
| `DataBaseName` | `string` | The database name |
| `StorageType` | `OStorageType` | The storage type, (PLocal or Memory) |
| `Path` | `string` | The database URL |



### Examples

Consider the use case of a long running OrientDB Server that has be utilized by several applications, including yours.  You intend to move your operation onto a fresh host, but want to back up those databases that were not part of your application.

```csharp
using Orient.Client;
using System;
...

// CLEANUP SERVER
public void CleanServer(OServer server, string[] databaseNames, 
   string host, int, port, string user, string userPasswd, 
   string backupPath)
{
   // REPORT OPERATION
   Console.WriteLine("Cleaning OrientDB Server...");

   // FETCH DATABASE INFORMATION
   Dictionary<string, ODatabaseInfo> srvInfo = server.Databases();

   // LOOP OVER EACH DATABASE INSTANCE
   foreach(KeyValuePair<string, ODatabaseInfo> dbInfo in srvInfo)
   {
      string name = entry.Value.DataBaseName;

      // TEST IF DBNAME IN DATABASENAMES
      if(databaseNames.Contains(name))
      {
         // OPEN DATABASE
         ODatabase database = ODatabase(host, port, name,
            ODatabaseType.Graph, user, passwd);

         // FORMAT BACKUP COMMAND 
         string backupCommand = String.Format(
            "BACKUP DATABASE {0}/{1}.zip -compressionLevel=2",
            backupPath, name);
 
         // RUN COMMAND
         database.Command(backupCommand);

         // CLOSE DATABASE
         database.Close();
      }
   }
}
```
