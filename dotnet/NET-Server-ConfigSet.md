---
search:
   keywords: ['.NET', 'C#', 'c sharp', 'OrientDB-NET', 'set configuration', 'ConfigSet', 'OServer']
---

# OrientDB-NET - `ConfigSet()`

This method changes the value of the given configuration variable on the OrientDB Server.  It returns a boolean value indicating whether the change was successful.

## Setting Configuration Variables

You may find that you want to change the values on various configuration variables for the OrientDB Server from within your application.  With this method you can do so through the [`OServer`](NET-Server.md) instance.

### Syntax

```
bool OServer.ConfigSet(
   string key,
   string value)
```

- **`key`** Defines the configuration variable you want to change.
- **`value`** Defines the value you want to set on the variable.

This method returns a boolean value, indicating whether OrientDB applied your change.

### Example

For instance, say that you have multiple OrientDB servers running in a distributed deployment.  You notice certain performance issues relating to network connectivity and decide to begin optimizing the `network.retry` parameter by changing its current setting to 6.

```csharp
// UPDATE network.retry PARAMETER
bool IsUpdated = server.ConfigSet("network.retry", 6);
Assert.IsTrue(IsUpdated);
```
