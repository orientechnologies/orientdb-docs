---
search:
   keywords: ['.NET', 'C#', 'c sharp', 'OrientDB-NET', 'configuration dictionary', 'dictionary']
---

# OrientDB-NET - `ConfigList()`

This method returns the current configuration of the OrientDB Server as a dictionary of key/value pairs.

## Retrieving Server Configuration

In situations where you need to check multiple configuration variables on a server, you may find it beneficial to retrieve the entire server configuration set in one call rather than making multiple individual requests.

### Syntax

```
Dictionary<string, string> OServer.ConfigList()
```

The return value is a dictionary of configuration variables and their current values.

### Example

When debugging your application, you may sometimes find it useful to consult the OrientDB Server configuration, to help in checking whether the server was set up properly for your usage.


Consider the use-case where you are working with OrientDB in a distributed cluster with dozens of servers running in-memory.  Whenever you add servers to your infrastructure, you need to evaluate several configuration variables before moving it to production.

```csharp
using Orient.Client;
using System;
...

// WRITE SERVER CONFIGURATION TO CONSOLE
public Dictionary<string, string> ReportConfig(OServer server)
{
   // FETCH SERVER CONFIGURATION
   Dictionary<string, string> srvConfig = server.ConfigList();

   // WRITE HEADER
   Console.WriteLine("OrientDB Server Configuration");

   // LOOP OVER EACH CONFIG ENTRY
   foreach(KeyValuePair<string, string> entry in srvConfig)
   {

      // WRITE TO CONSOLE
      Console.WriteLine(" - {0}: {1}",
         entry.Key,
         entry.Value);
   }

   // RETURN CONFIGURATION FOR ADDITIONAL TESTING
   return srvConfig; 
}
```

Here, the function receives an [`OServer`](NET-Server.md) interface as an argument.  Using this interface, it retrieves the current server configuration and loops over it, printing each variable and value to the console.  When it's done it returns the configuration dictionary, which you can then use to perform additional tests instead of making multiple calls to [`ConfigGet()`](NET-Server-ConfigGet.md).
