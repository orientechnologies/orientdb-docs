
# OServer - getInstanceByPath()

This method retrieves the given instance of an OrientDB Server by its path.

## Retrieving `OServer` Instances

In addition to starting an embedded instance of the OrientDB Server, you can also retrieve a particular [`OServer`](../OServer.md) instance, as identified by its path.  If you want to retrieve the server instance by its ID, see the [`getInstance()`](getInstance.md) method.

### Syntax 

```
public static OServer OServer().getInstanceByPath(String iPath)
```

| Argument | Type | Description |
|---|---|---|
| **`iPath`** | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Defines the sever path you want to retrieve. | 

#### Return Value

This method returns an [`OServer`](../OServer.md) value.  It provides you with an instance of the OrientDB Server running on the given path.


### Example

Imagine you have OrientDB running in a distributed deployment and have an operation that you need to run on several servers in sequence.  You might use a method such as this to convert a list of server paths into one of active [`OServer`](../OServer.md) instances.

```java
/**
 * Retrieve OServer Instances by Path 
 */
public List<OServer> fetchOServers(OServer oserver, List<String> paths){

   // Log Operation
   logger.info("Fetching OrientDB Servers");

   // Initialize Variables
   List<OServer> oservers;

   // Loop Over Server ID's
   for (int i = 0; i < paths.size(); i++){

      // Retrieve ID
      String path = path.get(i);

	  // Retrieve OServer
	  oservers.add(oserver.getInstanceByPath(path));

   }

   // Return OServer List
   return oservers;

}
```
