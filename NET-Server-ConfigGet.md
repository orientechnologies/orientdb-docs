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
string OServer.ConfigGet(string <key>)
```

- **`<key>`** Defines the configuration variable that you want to check.

### Example
