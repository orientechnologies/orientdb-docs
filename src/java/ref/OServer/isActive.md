
# OServer - isActive()

This method tests whether the server instance is currently active.

## Checking Server Active

You may find occasions where your application receives an [`OServer`](../OServer.md) instance as a return value from other operations or threads.  This method provides you with a simple check to determine whether the server instance is currently active using the boolean return value.

### Syntax

```
public boolean OServer().isActive()
```

#### Return Value

This method returns a [`boolean`]({{ book.javase }}/api/java/lang/Boolean.html) value.  If the return value is `true`, it indicates that the OrientDB Server instance is active.

### Example

Imagine you that you have created a basic handler in your application that takes an [`OServer`](../OServer.md) instance as a constructor argument.  When it receives the server instance, it checks whether it is active and activates it in the event that it is not.

```java
// IMPORTS
import com.orientechnologies.orient.server.OServer;
import java.util.logging.Logger;
/*
 * Handler class for OrientDB Databases
 * @author: Some Dev <some.dev@example.com>
 * @version: 10.4
 * @since: 1.0
 */
class DatabaseHandler {

	// INIT LOGGER
	private static final Logger logger = Logger.getLogger(
		DatabaseHandler.class.getName());

	/*
	 * Constructor Method
	 * @param server: OServer instance
	 */
	public void DatabaseHandler(OServer server) {

		// CHECK THAT SERVER IS ACTIVE
		if !(server.isActive()) {
			logger.info("Server inactive, activating");
		
			// ACTIVATE SERVER
			server.activate();

		}
	
	}
}
```
