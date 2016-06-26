# PyOrient Client

The base module in PyOrient provides a Python wrapper for the OrientDB [Binary Protocol](Network-Binary-Protocol.md).  Using this wrapper, you can initialize a client instance within your application, then operate on the OrientDB Server through this instance.

In order to use the PyOrient Client, you need to import the base module into your application.  

```py
import pyorient
```

## Initializing the Client

In order to use the PyOrient Client, you need to initialize a client instance in your application.  By convention, this instance is called `client`, but you can use any object name you prefer.

To use the client, first initialize a the client object, then connect to the OrientDB Server:

```py
client = pyorient.OrientDB("localhost", 2424)
session_id = client.connect("admin", "admin_passwd")
```

Here, you initialize the `client` object to connect to OrientDB through the localhost interface on port 2424.  Then, you establish a connection with the Server, using the username `admin` and the password `admin_passwd`.


### Server Shutdown

From within your application, you can shut down the OrientDB Server.  The user that initiates the shutdown must have shutdown permissions in the `orientdb-server-config.xml` configuration file, (for instance, the `root` user on the OrientDB Server).

```py
client.shutdown('root', 'root_passwd')
```

## Working with the Client

Within your application, once you have initialized the PyOrient Client this object provides you with an interface in working databases on the OrientDB Server.

- [**Session Tokens**](PyOrient-Client-Tokens.md) Provides a guide to retrieving session tokens from the client and how you can use them to reconnect to later existing sessions.

