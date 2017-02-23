---
search:
   keywords: ['Document API', 'document database']
---

# Working with Document Databases

Before you can execute any operation on a Document Database, you first need to open an instance in your application.  You can do so by either opening an existing instance or creating a new one.  Bear in mind that database instances are not thread-safe, so only use one database per thread.

Whether you want to open or create a database, you first need a valid database URL.  The URL defines where OrientDB looks for the database and what kind it should use.  For instance, `memory` refers to a database that is in-memory only and volatile, `plocal` to one that is embedded and `remote` to a database either on a remote server or accessed through localhost.  For more information, see [Database URL](../Concepts.md#database_url).

## Managing Database Instances

When you finish with a database instance, you must close it in order to free up the system resources that it uses.  To ensure this, the most common practice is to enclose the database operation within a `try`/`finally` block.  For instance,

```java
// Open the /tmp/test Document Database
ODatabaseDocumentTx db = new ODatabaseDocumentTx("plocal:/tmp/test");
db.open("admin", "admin");

try {
     // Enter your code here...
} finally {
     db.close()
}
```

Using this layout, the database is automatically closed once it finishes executing your code.  If you want to open the database in memory, use `memory:` or `remote:` if you want to use a remote instance instead a PLocal connection.

>Remember, the `ODatabaseDocumentTx` class is not thread-safe.  When using multiple threads, use separate instances of this class.  This way, they share the same storage instance, (with the same Database URL), and the same level-2 cache.
>
>For more information, see [Multi-Threading with Java](Java-Multi-Threading.md).



## Creating New Databases

In the event that the database doesn't exist already, you can create one through the Java API.  From the local file system, this is relatively straight forward, using `plocal`:

```java
ODatabaseDocumentTx db = new ODatabaseDocumentTx 
        ("plocal:/tmp/database/petshop")
        .create();
```

When you create a db for the first time, OrientDB creates three users and three roles for you

Users:

- User `admin` (password "admin") with role `admin`
- User `reader` (password "reader") with role `reader`
- User `writer` (password "writer") with role `writer`

Roles:

- Role `admin` - full control on the database
- Role `reader` - read only permissions
- Role `writer` - read/write permissions, but no schema manipulation

For more information on how to add/remove users/roles, change roles to a user, change passwords, please refer to [Database-Security](../Database-Security.md)

For creating database instances on remote servers, the process is a little more complicated.  You need the user and password to access the remote OrientDB Server instance.  By default, OrientDB creates the `root` user when the server first starts.  Checking the file in `$ORIENTDB_HOME/config/orientdb-server-config.xml`, which also provides the password.


To create a new document database, here `ExampleDB` at the address `dbhost` using file system storage, add the following lines to your application:

```java
new OServerAdmin("remote:dbhost")
      .connect("root", "root_passwd")
      .createDatabase("ExampleDB", "document", "plocal").close();
```

This uses the `root` user to connect to the OrientDB Server, then creates the `ExampleDB` Document Database.  To create a graph database, replace `document` with `graph`.  To store the database in memory, replace `plocal` with `memory`.



## Opening Existing Databases

When dealing with existing databases, you need to open the instance instead of creating it.  The database instance shares the connection, rather than the storage.  If it's a `plocal` storage, then all the database instances synchronize on it.  IF it's a `remote` storage, then all the database instances share the network connection.

```java
ODatabaseDocumentTx db = new ODatabaseDocumentTx 
      ("remote:localhost/petshop")
      .open("admin", "admin"); //default password
``` 

### Using Database Pools

It is not always the best practice to create database instances every time you need them.  In cases where your application needs to scale to many database connections, such as in the case of a web app, it's often better to pool the instances together to improve performance.  By default, OrientDB provides a global pool declared with a maximum of twenty instances.  You can use it with: `ODatabaseDocumentPool.global()`, for instance,

```java
// OPEN DATABASE
ODatabaseDocumentTx db = ODatabaseDocumentPool.global()
      .acquire("remote:localhost/petshop", 
      "admin", "admin_passwd");
try {
   // YOUR CODE
   ...
} finally {
   db.close()
}
```

Remember to close the database instance using the `.close()` database method as you would with classic non-pooled databases.  In cases like the above example, closing the database instance does not actually close it.  Rather, closing it releases the instance back to the pool, where it's made available to future requests.

>**NOTE**: It's best practice to use the `try`/`finally` blocks here, as it helps you to ensure the database instances are returned to the pool rather than left open.

### Using Custom Pools

In addition to the standard database pools, you can also set up custom database pools, with defined minimum and maximum managed instances.  Bear in mind, when using deployments of this kind, you need to close the pool when it's no longer needed.  For instance,

```java
// CREATE A NEW POOL WITH 1 - 10 INSTANCES
ODatabaseDocumentPool pool = new ODatabaseDocumentPool();
pool.setup(1, 10);
...
pool.close()
```


### Dropping a database

To drop a database (`plocal`) ODatabaseDocumentTx provides the following API:

```
db.drop();
```

To drop a db in `remote`, you can use the following:

```
new OServerAdmin("remote:dbhost")
      .connect("root", "root_passwd")
      .dropDatabase("dbName", "plocal");
```


