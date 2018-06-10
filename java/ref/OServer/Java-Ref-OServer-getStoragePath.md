---
search:
   keywords: ['Java API', 'OServer', 'get storage path', 'getStoragePath']
---

# OServer - getStoragePath()

Retrieves the path to the storage-type used by the OrientDB Server.

## Retrieving Storage Path

In cases where you need the storage-path ussed by the OrientDB Server, such as to log it for debugging or as part of a larger operation, this method retrieves it for you.

### Syntax

```
public String OServer().getStoragePath(String iName)
```

| Argument | Type | Description |
|---|---|---|
| **`iName`** | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Defines the name of the storage-type. |

#### Return Value

This method returns a [`String`]({{ book.javase }}/api/java/lang/String.html) value.  It provides the path to OrientDB storages.


### Example

Consider a use case where you need to retrieve the storage path to pass it to some other method as part of a larger operation.  You might use a method like this in the class managing the OrientDB Server to retireve the storage path and log it for debugging purposes before returning the value. 


```java
/**
 * Retrieve and Log the Sotrage Path 
 */
public String fetchStoragePath(OServer oserver){

   // Log Operation
   logger.info("Retrieving Storage Path");

   // Fetch Storage Path 
   String path = oserver.getStoragePath();

   // Report Location for Debugging
   logger.debug("Storage Path" + path);

   // Return Sotrage Path 
   return path;
}
```

