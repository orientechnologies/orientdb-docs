# PyOrient Client - `get_session_token()`

In certain use cases, you may want to maintain a client connection across several sessions.  For instance, in a web application you might set an identifier for a shopping cart or use sessions to maintain a local history of the user's interactions with the site.

Beginning in version 27, PyOrient provides support for token-based sessions.  Using the `set_session_token()` method, your client can tokens and, using one, reattach to an existing session.

## Setting Session Tokens

There are two operations possible with this method.  It determines which by the type of the value you pass it as an argument.

**Syntax**

```
client.set_session_token(<enable|session-id>)
```

- **`<enable>`** When the method receives a boolean value, it enables or disables token-based authentication in OrientDB.
- **`<session-id>`** When the method receives the identifier for an existing session, it reattaches to that session.

In practice, you need to use both in your application.  First to enable token-based authentication and then to reattach to an existing session.  When this feature is enabled, you can fetch the current session token using the [`get_session_token()`](PyOrient-Client-Get-Session-Token.md) method.



### Enabling Session Tokens

Working with session tokens requires that you configure the OrientDB Server to use them.  You can manage this through the `set_session_token()`.  When you pass this parameter a token it reattaches to that session.  When you pass it a boolean value, it enables or disables the feature.

```py
# Initialize the Client
client = pyorient.OrientDB("localhost", 2424)

# Enable Token-based Authentication
client.set_session_token(True)
```

Once you have enabled this feature, you can fetch a token for the current session and set it to the variable, using the [`get_session_token()`](PyOrient-Client-Get-Session-Token.md) method.

```py
# Fetch Session Token
sessionToken = client.get_session_token()
```

With the session token fetched and stored on the variable, `sessionToken`, you now have it available to use later in reattaching to this session.


### Setting Session Tokens

With session tokens enabled and one fetched and set to a variable using the [`get_session_token()`](PyOrient-Client-Get-Session-Token.md) method, you can use the token to reattach to an existing session.

```py
# Reattach to Session
if sessionToken != '':
   client.set_session_token(sessionToken)
else:
   # Open Database
   client.db_open("tinkerhome", "admin", "admin_passwd")

   # Enable Session Tokens
   client.set_session_token(True)
   
   # Fetch Session Token
   sessionToken = client.get_session_token()
   assert sessionToken != ''

# Query Database
record = client.query(
   "SELECT status FROM Nodes WHERE zone = 'living-room'")
```

Here, your application first checks whether the `sessionToken` variable is an empty string.  If it finds that it is not an empty string, it uses the variable to reattach to an existing session.  If it finds that it is an empty string, it opens the database, enables session tokens, to fetches the current session token to set it on the `sessionToken` variable for later.  Afterwards, it queries the database for the status of all devices in the living room.

>In the above example note, when the client reattaches to an existing session, it doesn't need to reopen the database, given that the database is already open on that session.

