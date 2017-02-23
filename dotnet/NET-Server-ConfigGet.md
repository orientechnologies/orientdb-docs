---
search:
   keywords: ['.NET', 'C#', 'c sharp', 'OrientDB-NET', 'configuration', 'config get', 'ConfigGet']
---

# OrientDB-NET - `ConfigGet()`

This method retrieves the value of the given configuration variable from the server.  It returns the value as a string.

## Retrieving Configuration Values

In certain situations you may want to retrieve values from various configuration variables from the OrientDB Server.  You might find this useful when checking various settings to determine whether the server is ready for use by your application.

### Syntax

```
string OServer.ConfigGet(string key)
```

- **`key`** Defines the configuration variable that you want to check.

This method returns a string of the current setting.

### Example

For instance, say that you are developing a basic unit test to evaluate whether the file-type is properly set for the transaction log.  You want the file-type set to classic-mode, but are worried that some databases in your distributed cluster may have the wrong configuration.

```csharp
// FETCH TX.LOG FILETYPE
string txFileType = server.ConfigGet("tx.log.fileType"); 

Assert.AreEqual("classic", txFileType);
```
