---
search:
   keywords: ['Java API', 'OServer', 'embed']
---

# Java API - OServer

This class allows you to embed and manage a server instance within your application.  Once you start the server, you can interact with it and manage data the same as you would standard instances of the OrientDB Server.

>For more information, see [Embedding the Server](Embedding-Server.md).  For the complete `OServer` documentation, see the [Javadocs]({{ book.javadoc }}/com/orientechnologies/orient/server/OServer.html).

## Working with `OServer` 

In order to operate on an OrientDB database, you first need to establish a connection with the server.  You have two options in this: you can connect to a running OrientDB Server using [`OrientDB`](Java-Ref-OrientDB.md) or you can embed the server within your application using this class.  It can be found at `com.orientechnologies.orient.server`. For instance,


```java
/* Import OrientDB Classes */
import com.orientechnologies.orient.server.OServer;
```

Once you've imported the class to your application, you can use one of the constructors to build a particular instance in your code.


### Constructors

This class provides two constructors to create instances of `OServer` in your application. The first takes no arguments and the second takes a single boolean argument, which defines whether you want to shut the server down on exit.

```
// CONSTRUCTOR 1
OServer()

// CONSTRUCTOR 2
OServer(boolean shutdownEngineOnExit)
```

### Exception

This class throws the following exceptions.

- [`ClassNotFoundException`]({{ book.javase }}/api/java/lang/ClassNotFoundException.html)
- [`MalformedObjectNameException`]({{ book.javase }}/api/javax/management/MalformedObjectNameException.html)
- [`NullPointerException`]({{ book.javase }}/api/java/lang/NullPointerException.html)
- [`InstanceAlreadyExistsException`]({{ book.javase }}/api/javax/management/InstanceAlreadyExistsException.html)
- [`MBeanRegistrationException`]({{ book.javase }}/api/javax/maangement/MBeanRegistrationException.html)
- [`NotCompliantMBeanException`]({{ book.javase }}/api/javax/management/NotCompliantMBeanException.html)

### Methods

Once you've initialized the class in your application, you can call the following methods on your instance.

#### Managing Server Instances

| Method | Return Type | Description | 
|---|---|---|
| [**`getInstance()`**](Java-Ref-OServer-getInstance.md) | [`OServer`](Java-Ref-OServer.md) | Retrieves a server instance by ID. |
| [**`getInstanceByPath()`**](Java-Ref-OServer-getInstanceByPath.md) | [`OServer`](Java-Ref-OServer.md) | Retrieve a server instance by its path. |
| [**`isActive()`**](Java-Ref-OServer-isActive.md) | [`boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Checks whether server is active. |
| [**`restart()`**](Java-Ref-OServer-restart.md) | [`void`]({{ book.javase }}/api/java/lang/Void.html) | Restarts the server. |
| [**`shutdown()`**](Java-Ref-OServer-shutdown.md) | [`boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Shuts down the server. |
| [**`startup()`**](Java-Ref-OServer-startup.md) | [`OServer`](Java-Ref-OServer.md) | Starts the server. |

<!--
# Managing Server
serverLogin - 
registerServerInstance
registerLifecycleListener
unregisterLifecycleListener
setServerRootDirectory
getSecurity
-->

#### Managing Databases

| Method | Return Type | Description |
|---|---|---|
| [**`getDatabaseDirectory()`**](Java-Ref-OServer-getDatabaseDirectory.md) | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Retrieves the root database directory. |
| [**`openDatabase()`**](Java-Ref-OServer-openDatabase.md) | `ODatabase<T>` | Opens the given database. | 

<!-- Methods
getSystemDatabase
openDatabaseBypassingSecurity
getDatabasePoolFactory
-->

#### Managing Storage

| Method | Return Type | Description |
|---|---|---|
| [**`existsStoragePath()`**](Java-Ref-OServer-existsStoragePath.md) | [`boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Determines whether storage path exists. |
| [**`getAvailableStorageNames()`**](Java-Ref-OServer-getAvailableStorageNames.md) | [`Map`]({{ book.javase }}/api/java/util/Map.html)[`<String,`]({{ book.javase }}/api/java/lang/String.html)[` String>`]({{ book.javase }}/api/java/lang.String.html) | Retrieves a map of available storage types. |
| [**`getStoragePath()`**](Java-Ref-OServer-getStoragePath.md) | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Retrieves the storage path. |


#### User Management

| Method | Return Type | Description |
|---|---|---|
| [**`addTemporaryUser()`**](Java-Ref-OServer-addTemporaryUser.md) | [`void`]({{ book.javase }}/api/java/lang/Void.html) | Adds a temporary user to the server. |
| [**`addUser()`**](Java-Ref-OServer-addUser.md) | [`void`]({{ book.javase }}/api/java/lang/Void.html) | Adds a user to the server. |
| [**`authenticate()`**](Java-Ref-OServer-authenticate.md) | [`boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Authenticates a user on the server. |
| [**`dropUser()`**](Java-Ref-OServer-dropUser.md) | [`void`]({{ book.javase }}/api/java/lang/Void.html) | Removes user from the server. |
| [**`isAllowed()`**](Java-Ref-OServer-isAllowed.md) | [`boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Checks whether user can access a given resource. |


<!--

# User Management
getUser
-->

#### Configuration

| Method | Return Type | Description |
|---|---|---|
| [**`getConfiguration()`**](Java-Ref-OServer-getConfiguration.md) | `OServerConfiguration` | Retrieves the server configuration. |
| [**`saveConfiguration()`**](Java-Ref-OServer-saveConfiguration.md) | [`void`]({{ book.javase }}/api/java/lang/Void.html) | Saves the server configuration to disk. |

<!--

# Configuration
getContextConfiguration
-->





<!--

# Class Loader
setExtensionClassLoader
getExtensionClassLoader


# Network
getClientConnectionManager
getNetworkProtocols
getNetworkListeners

# Plugins
getPlugins
getPluginByClass
getPluginManager

# Other
getServerThreadGroup
getVariable
setVariable
getDistributedManager
getTokenHandler

-->
