---
search:
   keywords: ['.NET', 'C#', 'C Sharp', 'OServer']
---

# OrientDB-NET - `OServer`

This class provides an interface and methods for when you need to operate on the OrientDB Server from within your C#/.NET application.

Use this interface in cases where you need to retrieve or modify server configuration, create or remove databases or fetch information about those databases available on the server.  If you want to operate on a specific database, use the [`ODatabase`](NET-Database.md) interface.


## Initializing OServer

When you enable the `Orient.Client` namespace through the `using` directive, you can create a server interface for your application by instantiating the `OServer` class.

### Syntax

```
OServer(    string hostName, 
            int port, 
            string userName, 
            string userPasswd)
```

- **`hostname`** Defines the host that you want to connect to, such as `localhost` or the IP address on which OrientDB is running.
- **`port`** Defines the port you want to connect to, such as 2424.
- **`userName`** Defines the Server user name.
- **`userPasswd`** Defines the Server user password.

Once you have an instance of this class, you can begin to call methods on it to operate on the OrientDB Server.

### Example

In the interest of abstraction, you might create a class with methods to handle common OrientDB Server operations.  For instance, say you want a method that creates and returns a new `OServer` instance,


```csharp
public static class Server
{
   private static string _hostname  = "localhost";
   private static int _port         = 2424;
   private static string _user      = "root";
   private static string _passwd    = "root_passwd";

   public static OServer Connect()
   {
      server = new OServer(_hostname, _port, 
            _root, _root_passwd);
      return server;
   }

}
```

With this `Server` class, you can use the `Connect()` method to retrieve a new instance of `OServer`.  You can then use this instance in various database operations.


## Using OServer

Once you have created an instance of `OServer` within your application, you can use its methods in performing various operations on databases, including,

| Method | Return Value | Description |
|---|---|---|
| [**`ConfigGet()`**](NET-Server-ConfigGet.md) | `string` | Retrieves a configuration value for the given variable.|
| [**`ConfigList()`**](NET-Server-ConfigList.md) | `Dictionary<string, string>` | Retrieves the complete server configuration. |
| [**`ConfigSet()`**](NET-Server-ConfigSet.md) | `bool` | Modifies the given configuration variable. |
| [**`CreateDatabase()`**](NET-Server-CreateDatabase.md) | `bool` | Creates a database on the server. |
| [**`Close()`**](#closing-oserver) | `void` | Disposes of the OServer connection. |
| [**`DatabaseExists()`**](NET-Server-DatabaseExists.md) | `bool` | Checks that database exists on server. |
| [**`Databases()`**](NET-Server-Databases.md) | `Dictionary<string, ODatabaseInfo>` | Returns information on all databases on server.|
| [**`Dispose()`**](#closing-oserver) | `void` | Disposes of the OServer connection. |
| [**`DropDatabase()`**](NET-Server-DropDatabase.md) | `void` | Removes the given database. |


### Closing OServer

When you are finished using an instance server interface, you can close it to free up system resources.  The `OServer` class provides two methods to close a server connection.

- **`Close()`**
- **`Dispose()`**

Given one is an alias, you can use whichever you find most familiar.  For instance, say that you have creating an `OServer` instance in your application and set it on the `server` object.  To dispose of this instance, call one of the above methods on that object.

```csharp
// Close Server
server.Close();
```
