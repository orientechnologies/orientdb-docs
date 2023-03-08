---
search:
   keywords: ['Java API', 'OServer', 'start', 'startup']
---

# OServer - startup()

This method starts the given server instance. 

## Starting the Server

When you initialize an instance of [`OServer`](../OServer.md), it prepares the server within your application, but does not start it until you tell it you're ready to start.

### Syntax

There are several methods available in starting the embedded OrientDB server instance, which you use depends on what information you have available.  Bear in mind, that these methods do not all throw the same exceptions.

```
public OServer OServer().startup()

public OServer OServer().startup(File iConfigurationFile)

public OServer OServer().startup(String iConfiguration)

public OServer OServer().startup(InputStream iInputStream)
```

| Argument | Type | Description |
|---|---|---|
| **`iConfigurationFile`** | [`java.io.File`]({{ book.javase }}/api/java/io/File.html) | Defines the server configuration file, as a file instance. |
| **`iConfiguration`** | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Defines the server configuration, as a string. |
| **`iInputStream`** | [`java.io.InputStream`]({{ book.javase }}/api/java/io/InputStream.html) | Defines the server configuration, as an input stream. |

#### Return Value

This method returns an [`OServer`](../OServer.md) instance, which provides the started OrientDB embedded server.


#### Exceptions

This method throws a number of exceptions.  The common exceptions to all methods are,

- [`InstantiationException`]({{ book.javase }}/api/java/lang/InstantiationException.html)
- [`IllegalAccessException`]({{ book.javase }}/api/java/lang/IllegalAccessException.html)
- [`ClassNotFoundException`]({{ book.javase }}/api/java/lang/ClassNotFoundException.html)
- [`IllegalArgumentException`]({{ book.javase }}/api/java/lang/IllegalArgumentException.html)
- [`SecurityException`]({{ book.javase }}/api/java/lang/SecurityException.html)
- [`InvocationTargetException`]({{ book.javase }}/api/java/lang/reflect/InvocationTargetException.html)
- [`NoSuchMethodException`]({{ book.javase }}/api/java/lang/NoSuchMethodException.html)

Additionally, when you pass the server configuration as a string or input stream, the following exception can be thrown.

- [`IOException`]({{ book.javase }}/api/java/io/IOException.html)

### Example

Imagine your application has its own configuration file, which among other things contains a parameter in which the user can define the path to the OrientDB Server configuration they want to use.  Rather than accepting this value without issue, you may want to catch `IOException` exceptions, starting the server with its default configuration in the event that the given argument fails.  This ensures that the OrientDB Server always starts.

```java
// IMPORTS
import com.orientechnologies.orient.server.OServer;
import java.util.logging.Logger;
import java.io.IOException;

/*
 * Handler Class for OrientDB Database 
 * @author: Some Dev <some.dev@example.com>
 * @version: 10.4
 * @since: 1.0
 */
class DatabaseHandler {

	// INIT LOGGER
	private static final Logger logger = Logger.getLogger(
		DatabaseHandler.class.getName());

	/* 
	 * Constructor
	 * @param server: OServer instance
	 * @param myConfig: Path to configuration file for OrientDB Server
	 */
	public void DatabaseHandler(OServer server, String myConfig) {

		// Log Operation
		logger.info("Initializing DatabaseHandler class");

		try {
			// TRY GIVEN CONFIG
			server.startup(myConfig);
		} catch IOEexception {
			logger.warning(
				"Unable to start with given configuration, loading default");

			// START WITH DEFAULT CONFIG
			server.startup();
		
		}
	}
}
```
