# PyOrient Client - `db_drop()`

This method removes a database from the connected OrientDB server.

## Dropping Databases

In certain situations, you may want to remove a full database from the OrientDB Server.  For instance, if you create a temporary database in memory for certain operations or if you want to provide the user with the ability to uninstall the database with the application, without removing OrientDB itself.

**Syntax**

```
client.db_drop(<db-name>)
```

- **`<db-name>`** Defines the database to remove.

**Example**

Consider the example of the smart home database.  In developing your application, you may want to frequently reset the database to a clean state.  This allows you to move forward with a new implementation without having to worry about an obsolete schema causing problems for you.

```py
# Reset Database
def reset_db(client, name):

   # Remove Old Database
   client.db_drop(name)

   # Create New Database
   client.db_create(name, 
      pyorient.DB_TYPE_GRAPH, 
      pyorient.STORAGE_TYPE_PLOCAL)
```

Here, the function receives the client and the database name.  It deletes the given database and creates a new one with the same name.
