# PyOrient Client - `db_size()`

This method returns the size of the open database.


## Getting the Database Size

Using the `db_size()` method, you can determine the size of a given database.  It does not receive any arguments, but rather checks the database currently open on the client.  To open a database, see [`db_open()`](PyOrient-Client-DB-Open.md).

**Syntax**

```
client.db_size()
```

**Example**

You might use `db_size()` as a sanity check in your application.  For instance, you might have your application check the database size in order to determine whether or not it has been properly initialized:

```py
client.db_open("tinkerhome", "admin", "admin_passwd")

# Fetch Size
size = client.db_size()

assert size != 0
```

Here, the application opens the `tinkerhome` database, then checks it's size.  It uses an `assert` statement to ensure that the database is not empty.
