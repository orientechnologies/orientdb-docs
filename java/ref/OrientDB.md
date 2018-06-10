---
search:
   keywords: ['Java', 'OrientDB', 'environment']
---

# Java API - OrientDB

This class provides a management environment between your application and the OrientDB Server.


## Managing Servers 

In order to operate on an OrientDB database, you first need to establish a connection with the server.  You have two options in this: you can embed the server within your application using the [`OServer`](Java-Ref-OServer.md) class or you can connect to a running server using this class.  It can be found at `com.orientechnologies.orient.core.db`.  For instance,

```java
import com.orientechnologies.orient.core.db.OrientDB;
```

Once you've imported the class to your application, you can use one of the constructors to build a particular instance in your code.

### Constructors

This class provides two constructors to create instances of `OrientDB` in your application.

```
// CONSTRUCTOR 1
OrientDB(String url, OrientDBConfig config)

// CONSTRUCTOR 2
OrientDB(String url, String serverUser, 
      String serverPasswd, OrientDBConfig config)
```

- **`url`** Defines the database URL, as a string.  It supports embedded and remote URL's.
- **`config`** Defines the database config, as an `OrientDBConfig` instance.
- **`serverUser`** Defines the user name.
- **`serverPasswd`** Defines the user password.

### Example

Using this class you can create a new OrientdDB instance in your application, which you can then use to operate on multiple databases on the connected server.  This class supports two types of connections: embedded and remote.  With embedded connections, you're connecting to an instance running on your current machine.  With remote connections, you're using the remote port to connect to a server either running on localhost or a remote IP address.

For instance, creating a database on a remote host:

```java
OrientDB orientdb = new OrientDB("remote:191.168.1.100", "root", "root_passwd");
orientdb.create("musicdb", ODatabaseType.PLOCAL);
ODatabaseDocument session = orientdb.open("musicdb", "admin", "admin");
...

session.close();
orientdb.close();
```

Alternatively, you could connect to an embedded host:

```java
OrientDB orientdb = new OrientDB("embedded:./databases/", null, null);
orientdb.create("musicdb", ODatabaseType.MEMORY);
ODatabaseDocument session = orientdb.open("musicdb", "admin", "admin");
...

session.close();
orientdb.close();
```


## Methods

Once you've instantiated the class in your application, you can call the following methods on it to perform further operations.

| Method | Return Type | Description |
|---|---|---|
| [**`close()`**](#closing-databases) | [`void`]({{ book.javase }}/api/java/lang/Void.html) | Closes the current context with all related databases and pools. |
| [**`create()`**](Java-Ref-OrientDB-create.md) | [`void`]({{ book.javase }}/api/java/lang/Void.html) |  Creates a new database. |
| [**`createIfNotExists()`**](Java-Ref-OrientDB-createIfNotExists.md) | [`boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Creates a new database if it doesn't exist. |
| [**`drop()`**](Java-Ref-OrientDB-drop.md) | [`void`]({{ book.javase }}/api/java/lang/Void.html) | Removes a database from the server. |
| [**`exists()`**](Java-Ref-OrientDB-exists.md) | [`boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Checks whether database exists. |
| [**`list()`**](Java-Ref-OrientDB-list.md) | [`List<`]({{ book.javase }}/api/java/util/List.html) [`String>`]({{ book.javase }}/api/java/lang/String.html) | Returns a list of databases on the server |
| [**`open()`**](Java-Ref-OrientDB-open.md) | `ODatabaseDocument` | Opens and returns a Document database. |

#### Closing Databases

When you've finished operating on a database or server, you can close the current context with all related databases and pools using the `close()` method.  For instance,

```java
// OPEN DOCUMENT DATABASE
OrientDB orientdb =  new OrientDB("embedded:/tmp/", OrientDBConfig.defaultConfig());

try(ODatabaseDocumentTx db = orientdb.open("test", "admin", "admin");) {

	// Enter your code here
	...

} finally { 

   // CLOSE DATABASE
   orientdb.close();
}
```
