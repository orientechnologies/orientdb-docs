---
search:
   keywords: ['.NET', 'C#', 'c sharp', 'OrientDB-NET', 'configuration dictionary', 'dictionary']
---

# OrientDB-NET - `ConfigList()`

This method returns a the current configuration of the OrientDB Server as a dictionary of key/value pairs.

## Retrieving Server Configuration

In situations where you need to check multiple configuration variables on a server, you may find it beneficial to retrieve the entire server configuration set in one call rather than making multiple individual requests.

### Syntax

```
Dictionary<string, string> ConfigList()
```

The return value is a Dictionary of configuration variables and their current values.

### Example

Consider the use-case where you are working with OrientDB in a distributed cluster with dozens of servers running in-memory.  Whenever you add servers to your infrastructure, you need to evaluate several configuration variables before moving it to production.

```csharp
Dictionary<string, string> svrConfig = server.ConfigList();
```

Here, rather than multiple calls to [`ConfigGet()`](NET-Server-ConfigGet.md), which can prove time-consuming and wasteful in terms of network and resource usage, you can retrieve the entire server configuration in one call, then test it in full from within C#.




