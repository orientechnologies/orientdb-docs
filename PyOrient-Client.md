# PyOrient Client

The base module in PyOrient provides a Python wrapper for the OrientDB [Binary Protocol](Network-Binary-Protocol.md).  Using this wrapper, you can initialize a client instance within your application, then operate on the OrientDB Server through this instance.

In order to use the PyOrient Client, you need to import the base module into your application.  

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


### Server Shutdown

From within your application, you can shut down the OrientDB Server.  The user that initiates the shutdown must have shutdown permissions in the `orientdb-server-config.xml` configuration file, (for instance, the `root` user on the OrientDB Server).

```py
client.shutdown('root', 'root_passwd')
```

## Working with the Client

Within your application, once you have initialized the PyOrient Client this object provides you with an interface in working databases on the OrientDB Server.

- [**`command()`**](PyOrient-Client-Command.md) This method issues SQL commands.
- [**`data_cluster_add()`**](PyOrient-Client-Data-Cluster-Add.md) This method creates new clusters on the database.
- [**`data_cluster_data_range()`**](PyOrient-Client-Data-Cluster-Data-Range.md) This method retrieves all records in the given cluster.
- [**`db_count_records()`**](PyOrient-Client-DB-Count-Records.md) This method counts records on a database.
- [**`db_create()`**](PyOrient-Client-DB-Create.md) This method creates databases.
- [**`db_drop()`**](PyOrient-Client-DB-Drop.md) This method removes databases.
- [**`db_exists()`**](PyOrient-Client-DB-Exists.md) This method determines if a database exists.
- [**`db_list()`**](PyOrient-Client-DB-List.md) This method lists databases on the server.
- [**`db_open()`**](PyOrient-Client-DB-Open.md) This method opens a database on the server.
- [**`db_reload()`**](PyOrient-Client-DB-Reload.md) This method reloads the database on the client.
- [**`db_size()`**](PyOrient-Client-DB-Size.md) This method returns the size of the database.
- [**`get_session_token()`**`](PyOrient-Client-Get-Session-Token.md) This method returns the client session token.
- [**`query()`**](PyOrient-Client-Query.md) This method issues synchronous queries to the database.
- [**`query_async()`**](PyOrient-Client-Query-Async.md) This method issues asynchronous queries to the database.
- [**`record_create()`**](PyOrient-Client-Record-Create.md) This method creates records on the database.
- [**`record_delete()`**](PyOrient-Client-Record-Delete.md) This method removes records from the database.
- [**`record_load()`**](PyOrient-Client-Record-Load.md) This method retrieves records from the database.
- [**`record_update()`**](PyOrient-Client-Record-Update.md) This method updates records on the database.
- [**`set_session_token()`**](PyOrient-Client-Set-Session-Token.md) This method enables and loads a token for the client session.




