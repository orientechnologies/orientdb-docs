
# OServer - getInstance()

This method retrieves the given instance of an OrientDB Server by its Server ID.

## Retrieving `OServer` Instances

In addition to starting an embedded instance of the OrientDB Server, you can also retrieve a particular [`OServer`](../OServer.md) instance, as identified by its Server ID.  If you want to retrieve the server instance by its path, see the [`getInstaceByPath()`](getInstanceByPath.md) method.

### Syntax

```
public static OServer OServer().getInstance(String iServerId)
```

| Argument | Type | Description |
|---|---|---|
| **`iServerId`** | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Defines the Server ID you want to retrieve. |

#### Return Value

This method returns an [`OServer`](../OServer.md) instance.

### Example

Imagine you have OrientDB running in a distributed deployment and have an operation that you need to run on several servers in sequence.  You might use a method such as this to convert a list of Server ID's into one of active [`OServer`](../OServer.md) instances.

```java
/**
 * Retrieve OServer Instances by ID
 */
public List<OServer> fetchOServers(OServer oserver, List<String> ids){

   // Log Operation
   logger.info("Fetching OrientDB Servers");

   // Initialize Variables
   List<OServer> oservers;

   // Loop Over Server ID's
   for (int i = 0; i < ids.size(); i++){

      // Retrieve ID
      String id = ids.get(i);

	  // Retrieve OServer
	  oservers.add(oserver.getInstance(id));

   }

   // Return OServer List
   return oservers;

}
```
