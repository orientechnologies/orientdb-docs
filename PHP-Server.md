---
search:
   keywords: ["PHP", "PhpOrient", "server"]
---

# PhpOrient - Server Operations

Once you have the client interface ready in your application, you can begin to operate on OrientDB servers and databases.  In order to administer the server, you first need to connect to it. 

## Connecting to the Server

When you need to perform server operations, instantiate the client interface using credentials that can access your OrientDB Server, then issue the `connect()` method to establish a connection to the server.

```php
require "vendor/autoload.php";
use PhpOrient\PhpOrient;

// INITIALIZE CLIENT
$client = new PhpOrient('localhost' 2424);

// CONFIGURE CONNECTION
$client->username = 'root';
$client->password = 'root_passwd';

// CONNECT
$client->connect();
```

When your application gets to this point, the `$client` variable is now connected to the OrientDB Server and able to perform various operations.

>**NOTE**: There are several methods available to you in initializing a client connection.  For more information on the available methods, see [Client Connections](PHP-Client.md#alternative-methods).

## Operating on the Server

The client interface provides a number of methods for database and server operations.  The table below provides a list of methods for server operations, specifically in creating, opening, listing and removing databases on the server.

| Method | Description |
|---|---|
| [`dbCreate()`](PHP-dbCreate.md) | Creates a database |
| [`dbDrop()`](PHP-dbDrop.md) | Removes a database |
| [`dbExists()`](PHP-dbExists.md) | Checks that database exists |
| [`dbList()`](PHP-dbList.md) | Lists databases on server |
| [`dbOpen()`](PHP-Database.md) | Opens an existing database |
