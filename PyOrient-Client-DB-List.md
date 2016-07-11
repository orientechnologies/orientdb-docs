# PyOrient Client - `db_list()`

The PyOrient Client provides you with an interface for working with the OrientDB Server.  With the client initialized you can begin to operate on the server from within your Python operation.  The client provides a number of methods to accomplish this, including `db_list()`, which allows you to list databases on the OrientDB Server.


## Listing Databases

There are two methods available in determining what databases are available on the OrientDB Server.  The first is check whether an individual database is present, using [`db_exists()`](PyOrient-Client-DB-Exists.md).  In the event that you don't know the database name or you want to operate on all databases, you can use `db_list()` to fetch information on all databases on the server.


**Syntax**

```
client.db_list()
```

**Example**

When you create a database without specifying the username and password, OrientDB defaults to the user `admin` and the password `admin`.  While this behavior is fine during development, it poses certain security risks in production.  You might use `db_list()` as part of a basic security check to ensure that all databases on your server have non-default login credentials.  For instance, 


```py
# List Databases
database_list = client.db_list().__getattr__('databases')

# Check for Default Login
for i in database_list:
   try:
      client.db_open(i, "admin", "admin")
      print("Default Credentials found on: %s" % i)
      client.db_close()
   except:
      print("Non-default Credentials found on: %s" % i)
```

Here, PyOrient creates a dict object, where the key is the database name and the value the database path.  The `__getattr__()` method ensures that you retrieve a dict instead of an OrientRecord object.  You can test this using the Python console,

<pre>
>>> <code class="lang-py userinput">client.db_list()</code>
&lt;pyorient.otypes.OrientRecord object at 0x7f89c4211e10&gt;

>>> <code class="lang-py userinput">client.db_list().__getattr__('databases')</code>
{'tinkerhome': 'plocal:/data/tinkerhome',
'GratefulDeadConcerts': 'plocal:/data/GratefulDeadConcerts'}
</pre>

In the code, once this is set PyOrient then loops through the dict, checking each key, (that is, each database name), to test the default login credentials.  It then prints whether the login succeeds or fails to stdout.  This lets you know which databases need updated credentials.

