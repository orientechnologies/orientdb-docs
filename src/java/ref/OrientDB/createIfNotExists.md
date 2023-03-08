
# OrientDB - createIfNotExists()

This method creates a new database on the OrientDB Server.  If the database already exists on the server, it does nothing.

## Creating Databases

On occasion you may have several processes operating on a given OrientDB Server and not know for certain whether the given database exists already on the server.  This method allows you to ensure that a given database exists before you attempt further operations. 

### Syntax

There are two methods available in performing this operation:

```
// METHOD 1
public boolean OrientDB().createIfNotExists(
      String name, ODatabaseType type)

// METHOD 2
public boolean OrientDB().createIfNotExists(
      String name, ODatabaseType type,
	  OrientDBConfig config)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Defines the database name |
| **`type`** | `ODatabaseType` | Defines the database type, (PLocal or in-memory) |
| **`config`** | `OrientDBConfig` | defines the database configuration |

#### Return Value

This method returns a [`boolean`]({{ book.javase }}/api/java/lang/Boolean.html) value.  If the return value is `true`, it indicates that it has created a new database.  If the return value is `false`, it indicates that a database of that name already exists on the server.


### Example

In the event that you need to create a database before attempting further operations, you might want to use this method to avoid conflict in the event that the database already exists on your OrientDB Server.  Then, in the event that the database does already exist, you can log the finding for debugging purposes later.

```java
// INITIALIZE VARIABLES 
private static final Logger logger = Logger.getLogger(App.class.getName());
private OrientDB orientdb;

// CREATE DATABASE METHOD
public void createDatabase(String name){

	// Log Operation
	logger.info("Creating Database: " + name);

	// Create Database
	Boolean dbExists = orientdb.createIfNotExists(name, ODatabaseType.PLOCAL);

	if (dbExists) { 
		logger.debug("Database Created");
	} else {
	    logger.debug("Database Already Exists");
	}
}
```

