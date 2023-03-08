
# OServer - restart()

This method restarts the OrientDB Server instance.

## Restarting the Server

When you have an instance of [`OServer`](../OServer.md) that's already running, calling this method lets you stop the server and restart it.

### Syntax

```
public void OServer().restart()
```

#### Exceptions

This method throws the following exceptions:

- [`ClassNotFoundException`]({{ book.javase }}/api/java/lang/ClassNotFoundException.html)
- [`InvocationTargetException`]({{ book.javase }}/api/java/lang/reflect/InvocationTargetException.html)
- [`InstantiationException`]({{ book.javase }}/api/java/lang/InstantiationException.html)
- [`NoSuchMethodException`]({{ book.javase }}/api/java/lang/NoSuchMethodException.html)
- [`IllegalAccessException`]({{ book.javase }}/api/java/lang/IllegalAccessException.html)
- [`IOException`]({{ book.javase }}/api/java/io/IOException.html)


### Example

Imagine you have a handler class for the [`OServer`](../OServer.md) instances that you use in managing common operations with the OrientDB Server.  You might want to pass additional information to your logs when restarting the server, like the user or process calling for the restart.

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
	 * Command to restart the OrientDB Server
	 * @param user: Defines the user requesting the restart
	 */
	public void restart(String user){

		// LOG OPERATION
		logger.info("OrientDB Server restart, (requested by ", user, ")");

		// RESTART ORIENTDB SERVER
		oserver.restart()
	
	}
}
```
