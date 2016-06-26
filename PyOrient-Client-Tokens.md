# Session Tokens with PyOrient

In certain use cases, you may want to maintain a client across several sessions.  For instance, in a web application you might use this in setting an identifier for a shopping cart or to maintain a local history of the user's interactions with the site.

Beginning in version 27, PyOrient provides support for token-based sessions.  Using this, your application can reattach to old sessions rather than initiating new sessions.

## Getting Tokens

In order to use a session token in your application, use the `set_session_token()` and `get_session_token()` methods to enable the feature and set it on a variable.

```py
# Initialize a Client
client = pyorient.OrientDB("localhost", 2424)

# Enable Token-based Authentication
client.set_session_token(True)

# Open a Database
client.db_open("tinkersales", "admin", "admin_passwd")

# Set Session Token
sessionToken = client.get_session_token()

# Ensuure that the Server allows Session Tokens
assert sessionToken != ''
```

Here, token-based sessions are enabled by passing a boolean value to the `set_session_token()` method.  Using the `get_session_token()` method, the current session token is set on the `sessionToken` variable, which you can then pass or set in a browser cookie for use later.  In the event that your server is not configured to support token-based sessions, `get_session_token()` returns an empty string.

## Setting Tokens

When you have a token from existing session, whether retrieved from a cookie or obtained through some other means, you can then use it to reattach to the previous session:

```py
# Initialize a Client
client = pyorient.OrientDB("localhost", 2424)

# Set the Session Token
client.set_session_token(sessionToken)

# Query Database
record = client.query("SELECT FROM Nodes WHERE zone = 'living-room'")
```

Since you set the session token for `client`, you don't need to reopen the database before issuing queries.

## Renewing Tokens

In the event that you want to get a new client token, you can reset it by calling the `set_session_token` again with a boolean.

```py
# Renew the Token
client.set_session_token(True)

# Open the Database
client.db_open("tinkersales", 2424)

# Get New Session Token
new_sessionToken = client.get_session_token()

# Check that Token is New
assert sessionToken != new_sessionToken
```

By passing the boolean `True` to the `set_session_token()` method, you renew the session token set for the `client` variable.  You can then use `get_session_token()` to retrieve the new session token, using the `assert` statement to ensure that the token is in fact new.


