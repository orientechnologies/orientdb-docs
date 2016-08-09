# PyOrient OGM - Connection

In order to use the Object-Graph Mapper with your application, you first need to connect to a running OrientDB Server.  In PyOrient, there are two interface classes used in this process and you can access them through an `import` statement:

```py
# Module Imports
from pyorient.ogm import Graph, Config
```

- **`pyorient.ogm.Graph`** Wraps the lower-level PyOrient Client, that is, `pyorient.OrientDB()` and adds to it support for mapping Python classes to OrientDB database schemas and database schemas to Python Classes.

- **`pyorient.ogm.Config`** Provides an interface for defining how the OGM connects to OrientDB. 
 
## Connecting to OrientDB

When the PyOrient OGM connects to OrientDB, it uses the `pyorient.ogm.Config` class to define the specific database and credentials it uses in establishing the connection.  

**Syntax**

```
Config.from_url(
      <database-url>, 
      <user>, 
      <password>, 
      initial_drop = False)
```

- **`<database-url>`** Defines the database.
- **`<user>`** Defines the username.
- **`<password>`** Defines the user password.
- **`initial_drop`** Defines whether PyOrient should drop any existing databases that share this configuration.

For the database URL, you have the option of using one of several supported formats:

- Connecting to a Plocal database:
  - `localhost/<database-name>`
  - `plocal://localhost:<port>/<database-name>`
- Connecting to a Memory database:
  - `<database-name>`
  - `memory://localhost:<port>/<database-name>`

**Example**

For instance, say that you have a smart home system written in Python that uses OrientDB for back-end database storage.  You might use something like this to set up the database connection for your application:

```py
# Connect to Database
Config.from_url(
   'plocal://localhost:2424/smarthome',
   'root', 'root_passwd')
```

### Connecting with Graph Object

In addition to basic connection described above, you can also pass the connection configuration when you initialize the `Graph` object.  For instance,

```py
graph = Graph(
      Config.from_url(
         'localhost/smarthome',
	 'root', 'root_passwd'))
```

This initializes a `graph` instance of the `pyorient.ogm.Graph` class and defines how you want the OGM to connect to OrientDB.  You can then use `graph` in your applications to access further PyOrient OGM methods.
