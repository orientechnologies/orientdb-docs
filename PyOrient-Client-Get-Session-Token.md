---
search:
   keywords: ['PyOrient', 'client', 'tokens', 'get token']
---

# PyOrient Client - `get_session_token()`

In certain use cases, you may want to maintain a client connection across several sessions.  For instance, in a web application you might set an identifier for a shopping cart or use sessions to maintain a local history of the user's interactions with the site.

Beginning in version 27, PyOrient provides support for token-based sessions.  Using the `get_session_token()` method, your client can fetch a session ID from the client, which you can then use in reattaching to old sessions.

## Getting Session Tokens

Retrieving session tokens from OrientDB is a process closely tied with setting them on the client using the [`set_session_token()`](PyOrient-Client-Set-Session-Token.md) method.  In order to fetch the session token, you first need to enable the feature through this method.

**Syntax**

```py
client.get_session_token()
```

The method returns either the current session token or, in the event that the feature is disabled, an empty string.


### Enabling Session Tokens

Working with session tokens requires that you configure the OrientDB Server to use them.  You can manage this through the [`set_session_token()`](PyOrient-Client-Set-Session-Token.md).  When you pass this parameter a token it reattaches to that session.  When you pass it a boolean value, it enables or disables the feature.

```py
# Initialize the Client
client = pyorient.OrientDB("localhost", 2424)

# Enable Token-based Authentication
client.set_session_token(True)
```

### Retrieving Session Tokens

Once you have enabled this feature, you can fetch a token for the current session and set it to the variable.

```py
# Fetch Session Token
sessionToken = client.get_session_token()
```

In the event that something went wrong or if for some reason session tokens are disabled on OrientDB when you call this method, it returns an empty string.  To avoid problems later, you can implement a check using an `assert` statement to ensure that the token was properly set:

```py
# Ensure that Server allows Session Tokens
assert sessionToken != ''
```

With the session token set on the variable `sessionToken`, you can reattach to your current session later using the [`set_session_token()`](PyOrient-Client-Set-Session-Token.md) method. 
