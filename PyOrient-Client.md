# PyOrient Client

The base module in PyOrient provides a Python wrapper for the OrientDB [Binary Protocol](Network-Binary-Protocol.md).  Using this wrapper, you can initialize a client instance within your application, then operate on the OrientDB Server through this instance.

In order to use the PyOrient Client, you need to import the base module into your application.  To do so, add the following line:

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


### Using Tokens

Beginning in version 27, PyOrient provides support for token-based sessions.  You can use this to reattach to old sessions



Beginning in version 27, PyOrient provides support for token-based sessions.  The functionality for this is enabled in the `orientdb-server-config.xml`configuration file.

