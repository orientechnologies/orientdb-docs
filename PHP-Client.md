---
search:
   keywords: ["PHP", "PhpOrient", "client"]
---

# PhpOrient - Client Connections

Within your PHP application, performing operations on OrientDB servers and databases requires a client interface.  By convention, this interface is called `$client` within these docs, but you can use any variable name you prefer.  Once you have initialized this connection, you can begin to call additional methods to operate on [servers](PHP-Server.md) and [databases](PHP-Database.md). 


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

### Persistent Connections

Beginning in version 27, PhpOrient provides support for persistent client connections.  This allows you to set a session token, then connect, disconnect and reconnect to the given session as suits the needs of your application. 

When using persistent connections, use the `setSessionToken()` method with a boolean value to enable the feature.  Then use the `getSessionToken()` method to retrieve a token for the given session.

```php

// INITIALIZE CLIENT
$client = new PhpOrient('localhost', 2424);

// ENABLE PERSISTENT CONNECTIONS
$client->setSessionToken(true);

// RETRIEVE SESSION TOKEN
$sessionToken = $client->getSessionToken();
```

Once you have the session token, you can reattach to an existing session using it.  For instance, elsewhere in your code, you might want a function to handle the reconnection:

```php
// CREATE CLIENT
function getClient($sessionToken){

	// Instantiate Client
	$client = new PhpOrient("localhost", 2424);

	// Open Session
	$client->setSessionToken($sessionToken);

	return $client;
}
```

In cases where you call `getSessionToken()` before enabling persistent connections on the client, the method returns an empty string.  You can use this behavior to perform basic checks to ensure everything is working properly.  For instance,

```php
function getToken(){

	// Log Operation
	echo "Retrieving Session Token";

	// Fetch Globals
	global $client;
	global $sessionToken;

	// Set Session Token
	$sessionToken = $client->getSessionToken();

	if ($sessionToken == ''){

		// Enable Session Token
		$client->setSessionToken(true);

		// Fetch New Token
		$sessionToken = $client->getSessionToken();
	}

}
```
