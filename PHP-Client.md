---
search:
   keywords: ["PHP", "PhpOrient", "client"]
---

# PhpOrient - Client Connections

Operations on OrientDB servers and databases are handled through a client interface within your application.  By convention, this interface is called `$client`, but you can use any variable name you prefer.  Once you have initialized this connection, you can begin to call additional methods to perform whatever operations your application requires.


## Initializing Client Connections

In order to initialize a client connection within your application, you need to create a new instance of `PhpOrient()`.  Once you have instantiating the class, you need to define variables within the class to configure its connection.

```php
require "vendor/autoload.php";
use PhpOrient\PhpOrient;

// INITIALIZE CLIENT CONNECTION
$client =  new PhpOrient('localhost', 2424);

// SET CREDENTIALS
$client->username = 'admin';
$client->password = 'admin_passwd';
```


### Alternative Methods

In addition to the method shown above, there are two alternative methods available in configuring the client connection. The first of these is to manually set all of the configuration variables. 

```php
// INITIALIZE CLIENT
$client = new PhpOrient();

// CONFIGURE CLIENT
$client->hostname	= 'localhost';
$client->port		= 2424;
$client->username	= 'root';
$client->password	= 'root_passwd';
```

Alternatively, you can set the variables through the `configure()` method.

```php
// INITIALIZE CLIENT
$client = new PhpOrient();

// CONFIGURE CLIENT
$client->configure(
	array(
		'username'	=> 'root',
		'password'	=> 'root_passwd',
		'hostname'	=> 'localhost',
		'port'		=> 2424));
```


