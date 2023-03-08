---
search:
   keywords: ['Java API', 'OServer', 'shutdown']
---

# OServer - shutdown()

This method shuts down the OrientDB Server instance.

## Shutting Down the Server

When you finish working with the given [`OServer`](../OServer.md) instance, you need to shut it down in order to free up resources.  This method lets you shutdown an embedded server from within your application.

### Syntax

```
public boolean OServer().shutdown()
```

#### Return Value

This method returns a [`boolean`]({{ book.javase }}/api/java/lang/Boolean.html) value. If the value is `true`, it indicates that the server was successfully shut down.


### Example

Imagine you have a handler class for the [`OServer`](../OServer.md) instances that you use in managing common operations with the OrientDB Server.  You might want to pass additional information to your logs when shutting down the server, like the user or process calling for the restart.


```java
// IMPORTS 
import com.orientechnologies.orient.server.OServer;
import java.util.logging.Logger;

/*
 * Handler Class for OrientDB Database 
 * @author: Some Dev <some.dev@example.com>
 * @version: 10.4
 * @since: 1.0
 */
class DatabaseHandler {

	// INIT LOGGER
	private static final Logger logger = Logger.getLogger(
		DatabaseHandler.class.getname());

	// CLASS VARIABLES
	private static OServer oserver;
	...

	/*
	 * Command to shut down the OrientDB Server
	 * @param user: Defines the user requesting the restart
	 */
	public void shutdown(String user){

		// LOG OPERATION
		logger.info("OrientDB Server shutting down, (requested by ", user, ")");

		// SHUTDOWN ORIENTDB SERVER
		oserver.shutdown()
	
	}
}
```


