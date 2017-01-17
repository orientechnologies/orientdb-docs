---
search:
   keywords: ['NET', 'C#', 'c sharp', 'OrientDB-NET', 'ODatabase']
---

# OrientDB-NET - `ODatabase`

This class provides an interface and methods for when you need to operate on OrientDB databases from within your C#/.NET application.

Use this interface in cases where you need to retrieve or manage clusters, operate on records or issue scripts, queries and commands to the database.  If you want to operate on the OrientDB Server as a whole or create or delete databases on the server, use the [`OServer`](NET-Server.md) interface.


## Initializing the Database

When you enable the `Orient.Client` namespace through the `using` directive, you can create a database interface for your application by instantiating the `ODatabase` class.

### Syntax

```
// INITIALIZE DATABASE
ODatabase(  string host, 
            int port,
            string name,
            ODatabaseType type,
            string user,
            string passwd)

// INITIALIZE DATABASE USING CONNECTION POOL
ODatabase(  string host,
            int port,
            string name,
            ODatabaseType type,
            string user,
            string passwd,
            string poolAlias)
```

- **`host`** Defines the hostname or IP address of the OrientDB Server.
- **`port`** Defines the port to use in connecting to the server.
- **`name`** Defines the database name.
- **`type`** Defines the database type, that is PLocal or Memory.
- **`user`** Defines the user name.
- **`passwd`** Defines the user password.
- **`poolAlias`** Defines the alias to use for the connection pool.


### Example

In the interest of abstraction, you might create a method to handle common OrientDB database operations for your application.

```csharp
using Orient.Client;
using System;
...

// OPEN DATABASE
public ODatabase openDatabase(string _host, int _port,
       string _dbName, string _user, string _passwd)
{

   // CONSOLE LOG
   Console.WriteLine("Opening Database: {0}", _dbname);

   // OPEN DATABASE
   ODatabase database = ODatabase(_host, _port, _dbName, 
       ODatabaseType.Graph, _user, _passwd);

   // RETURN ODATABASE INSTANCE
   return database;
}
```


#### Using a Connection Pool

Normally, OrientDB-NET clients operate through a single network connection.  When working with web applications or any situation where network bottlenecks are a concern, it is common to pool these connections to ensure better performance.

To use a connection pool pass a pool alias when you create the `ODatabase` interface.

```csharp
ODatabase database = ODatabase("localhost", 2424,
   "microblog", ODatabaseType.PLocal, 
   "guestUser", "guest_passwd",
   "pool123");
```

#### Using Connection Options

In addition to configuring the database interface through arguments passed to the `ODatabase` class, you can also create a configuration object independent of the class, through the `ConnectionOptions` class.  You may find this useful when you need to initialize several database instances with similar configuration.

The `ConnectionOptions` class has seven parameters:

| Parameter | Type | Description |
|---|---|---|
| `HostName` | `string` | Defines the hostname or IP address of the server hosting OrientDB |
| `UserName` | `string` | Defines the name of the database user |
| `Password` | `string` | Defines the password for database user |
| `Port` | `int` | Defines the port number for the connection |
| `DatabaseName` | `string` | Defines the name of the database to use |
| `DatabaseType` | `ODatabaseType` | Defnes the type of database, PLocal or Memory |
| `PoolAlias` | `string` | Defines the connection pool to use. |

If you initialize this object without defining the connection pool, it sets it to `Default`.

```csharp
// INITIALIZE CONNECTION OPTIONS
ConnectionOptions opts = ConnectionOptions();

opts.HostName = "localhost";
opts.UserName = "admin";
opts.Password = "admin_passwd";
opts.Port = 2727;
opts.DatabaseName = "microblog";
opts.DatabaseType = ODatabaseType.PLocal

// Initialize Database
ODatabase database = ODatabase(opts);
```


## Using ODatabase

Once you have instantiated the `ODatabase` class, you can begin to operate on a particular database from within your C#/.NET application.  OrientDB-NET supports a number of database-level operations that you can call through this interface. Additionally, you can issue queries, commands and scripts to the database for those operations that it does not support. 

| Method | Return Value | Description |
|---|---|---|
| [**`Close()`**](#closing-databases) | `void` | Disposes of the database instance. |
| [**`Clusters()`**](NET-Database-Clusters.md) | `OClusterQuery` | Creates clusters. |
| [**`Command()`**](NET-Database-Command.md) | `OCommandResult` | Issues commands. |
| [**`CountRecords`**](#size-variables) | `long` | Counts records on database. |
| [**`Dispose()`**](#closing-databases) | `void` | Disposes of the database instance. |
| [**`GetClusterIdFor()`**](NET-Database-GetClusterIdFor.md) | `short` | Retrieves ID for the given cluster name.|
| [**`GetClusterNameFor()`**](NET-Database-GetClusterNameFor.md) | `string` | Retrieves the name for the given Cluster ID. |
| [**`GetClusters()`**](NET-Database-GetClusters.md) | `List<OCluster>` | Retrieves clusters from database. |
| [**`Gremlin()`**](NET-Database-Gremlin.md) | `OCommandResult` | Executes Gremlin commands. |
| [**`Insert()`**](NET-Database-Insert.md) | `IOInsert` | Prepares insertion operations. |
| [**`JavaScript()`**](NET-Database-JS.md) | `OCommamndQuery` | Prepares JavaScript commands. |
| [**`Query()`**](NET-Database-Query.md) | `List<ODocument>` | Queries the database using SQL. |
| [**`Select()`**](NET-Database-Select.md) | `OSqlSelect` | Prepares queries to execute. |
| [**`Size`**](#size-variables) | `long` | Retrieves the size of the database. |
| [**`SqlBatch()`**](NET-Database-SqlBatch.md) | `OCommandQuery` | Executes batch queries. |
| [**`Update()`**](NET-Database-Update.md) | `OSqlUpdate` | Prepares update statements. |

### Size Variables

In addition to the various methods, the `ODatabase` object also supports sizing variables, which you can use to determine the size of the database or the number of records it contains.

- To retrieve the size of the database, use the `Size` variable:

  ```csharp
  long databaseSize = database.Size;
  ```

- To count the number of records on the database, use the `CountRecords` variable:

  ```csharp
  long numberOfRecords = database.CountRecords;
  ```


### Closing Databases

When you are finished using the database instance, you can close it to free up system resources.  The `ODatabase` object provides two methods for closing databases: `Close()` and `Dispose()`.  Given that one is an alias to the other, you can use whichever is more famiiliar to you.

```csharp
// CLOSE DATABSE
database.Close()
```


### Transactions

OrientDB provides support for transactions.  The Insert(), Update() and Query() methods all provide support so that you can execute them as part of a transaction rather than on the database outright.  For more information, see [`OTransaction`](NET-Transactions.md).
