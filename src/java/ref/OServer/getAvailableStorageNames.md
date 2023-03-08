
# OServer - getAvailableStorageNames()

This method returns a map of storage types available on the OrientDB Server.

## Retrieving Storage Names

OrientDB supports two storage types: in-memory and PLocal.  In the event that you want to check for others that might become available or otherwise test the feature, this method allows you to retrieve a map of those available.

### Syntax

```
public Map<String, String> OServer().getAvailableStorageNames()
```

### Example

In the event that you want to pull the available storage names to operate on in some other method, you might use something like the following:

```java
/**
 * Report Available Storage to Stdout
 */
public void reportStorage(OServer oserver){

   // Log Operation
   logger.info("Reporting Storage");

   // Initialize Variables
   private Map<String, String> storage;
   private Iterator it;

   // Prepare Iterator 
   storage = oserver.getAvailableStorage();
   it = storage.entrySet().iterator();

   // Loop Over Storage
   System.out.println("OServer Storage:");
   while (it.hasNext()){
      Map.Entry pair = (Map.Entry)it.next();
	  System.out.println(pair.getKey() + ": " + pair.getValue());
	  it.remove();
   }
}
```
