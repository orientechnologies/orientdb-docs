---
search:
   keywords: ['Java API', 'OServer', 'get configuration', 'getConfiguration']
---

# [Server - getConfiguration()

This method retrieves the OrientDB Server configuration.

## Retrieving Server Configuration

On occasion you may need to review or otherwise operation on configuration values of a given [`OServer`](Java-Ref-OServer.md) instance.  This method allows you to retrieve the current configuration as an `OServerConfiguration` instance.

### Syntax

```
public OServerConfiguration OServer().getConfiguration()
```

### Example

In cases where you need to operate on an instance of the `OServerConfiguration` class, you can retrieve the current configuration from the OrientDB Server.  You might use a method such as this in the class that manages your [`OServer`](Java-Ref-OServer.md) instance.

```java
/**
 * Retrieve OrientDB Server Configuration
 */
public OServerConfiguration fetchConfig(OServer oserver){

   // Log Operation
   logger.info("Retrieving OServer Configuration");

   return oserver.getConfiguration();
}
```
