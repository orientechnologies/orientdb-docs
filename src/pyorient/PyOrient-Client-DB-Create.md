
# PyOrient Client - `db_create()`

Creates a database on the connected OrientDB Server.


## Creating Databases

In the event that a database does not exist already, you can create one from within your application, using the `db_create()` method.  This method requires one argument, but can take two others.

**Syntax**

```
client.db_create(<name>, <database-type>, <storage-type>)
```

- **`<name>`** Defines the database name.
- **`<database-type>`** Defines the database type, (optional):
  - *`pyorient.DB_TYPE_DOCUMENT`* Creates a Document Database.
  - *`pyorient.DB_TYPE_GRAPH`* Creates a Graph Database.
- **`<storage-type>`** Defines the storage type (optional):
  - *`pyorient.STORAGE_TYPE_PLOCAL`* Uses PLocal storage type.
  - *`pyorient.STORAGE_TYPE_MEMORY`* Uses Memory storage type.

Only the database name is required.  By default the method creates a Document Database using the PLocal storage type.

**Example**

Say that your application collects and analyzes data from various custom built smart home devices installed around the house.  When it first runs it finds that it needs to initialize a database on OrientDB to store the data it collects.

```py
try:
   client.db_create(
      "tinkerhome",
       pyorient.DB_TYPE_GRAPH,
       pyorient.STORAGE_TYPE_PLOCAL)
   logging.info("TinkerHome Database Created.")
except pyorient.PYORIENT_EXCEPTION as err:
   logging.critical(
      "Failed to create TinkerHome DB: %" 
      % err)
```

Here, PyOrient attempts to create the database `tinkerhome` on OrientDB.  If the create command fails, it logs it as a critical error.
