---
search:
   keywords: ['PyOrient', 'client', 'database exists']
---

# PyOrient Client - `db_exists()`

This method checks whether or not the given database exists on the connected OrientDB Server.  In the event that you need the database to exist and be of a specific storage type, you can pass a second argument to check this as well.


## Checking Database Existence

There are two methods available in determining whether a database exists on the OrientDB Server.  You can use the [`db_list()`](PyOrient-Client-DB-List.md) method to find all the databases on the server, then search the results or, in the event that you know the database name, you can check it directly with `db_exists()`.

**Syntax**

```
client.db_exists(<name>, <storage-type>)
```

- **`<name>`** Defines the database you want to find.
- **`<storage-type>`** Defines the storage type you want to find, (optional):
  - *`pyorient.STORAGE_TYPE_PLOCAL`* Checks for PLocal database.
  - *`pyorient.STORAGE_TYPE_MEMORY`* Checks for Memory database.

By default, it searches for a PLocal database type.


**Example**

Consider the example of the database for your smart home application.  Since the application requires a database to operate, you might use this method as a basic check when the application starts.  For instance,

```py
# Check Database
if client.db_exists("tinkerhome"):
   # Open Database
   client.db_open("tinkerhome", "admin", "admin_passwd")

else:
   # Create Database
   client.db_create(
      "tinkerhome",
      pyorient.DB_TYPE_GRAPH,
      pyorient.STORAGE_TYPE_PLOCAL 
   )
```

Here, the application checks if the `tinkerhome` database exists.  If it does, it opens the database on the client.  If it doesn't, it creates a PLocal Graph Database on that name.
