---
search:
   keywords: ['.NET', 'C#', 'c sharp', 'OrientDB-NET', 'configuration dictionary', 'dictionary']
---

# OrientDB-NET - `ConfigList()`

This method returns a the current configuration of the OrientDB Server as a dictionary of key/value pairs.

## Retrieving Server Configuration

On occasion you may need to retrieve the entire configuration table for the OrientDB Server.  For instance, say you need to check multiple configuration variables when your application connects to the server.  You may find it more efficient to retrieve the server configuration in on call to OrientDB, then sort out the information you need in C# rather than making multiple calls to the server.

### Syntax

```
Dictionary<string, string> ConfigList()
```

The return value is a Dictionary of configuration variables and their current values.

### Example


