---
search:
   keywords: ['Document API', 'document database']
---

# Working with Document Databases

Before you can execute any operation on a Document Database, you first need to create an instance of an OrientDB context, to do this you need a valid url and eventually an server username and password.

 The URL defines where OrientDB looks for the database and what kind it should use.  For instance, `embedded` refers to a database that is in the current system instead `remote` to a database either on a remote server or accessed through localhost.  For more information, see [Database URL](../datamodeling/Concepts.md#database_url).

## Managing Database Instances

When you finish with a database instance, you must close it in order to free up the system resources that it uses.  To ensure this, the most common practice is to enclose the database operation within a `try`/`finally` block.  For instance,

```java
// Open the /tmp/test Document Database
OrientDB orientDB = new OrientDB("embedded:/tm/", OrientDBConfig.defaultConfig());


try(ODatabaseDocumentTx db = orientDB.open("test","admin","admin");) {
     // Enter your code here...
}
// close the context when you shutdown the application or don't need anymore access to the database.
orientDB.close();
```

>Remember, the `ODatabaseDocument` class is not thread-safe.  When using multiple threads, use separate instances of this class.  This way, they share the same storage instance, (with the same Database URL), and the same level-2 cache.
>
>For more information, see [Multi-Threading with Java](Java-Multi-Threading.md).



## Creating New Databases

In the event that the database doesn't exist already, you can create one through the Java API.  From the local file system, this is relatively straight forward, using `plocal`:

```java
OrientDB orientDB = new OrientDB("embedded:/tmp/",OrientDBConfig.defaultConfig());
orientDB.create("test",ODatabaseType.PLOCAL);
//....
orientDB.close();
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

For more information on how to add/remove users/roles, change roles to a user, change passwords, please refer to [Database-Security](../gettingstarted/Database-Security.md)

For creating database instances on remote servers, You need the user and password to access the remote OrientDB Server instance.  By default, OrientDB creates the `root` user when the server asking the password at first starts.

Example:

```java
OrientDB orientDB = new OrientDB("remote:localhost","root","root_passwd",OrientDBConfig.defaultConfig());
orientDB.create("test",ODatabaseType.PLOCAL);
//....
orientDB.close();
```

### Using Database Pools

It is not always the best practice to create database instances every time you need them.  In cases where your application needs to scale to many database connections, such as in the case of a web app, it's often better to pool the instances together to improve performance.  By default, OrientDB provides a pool implementation. for instance,

```java

OrientDB orientDB = new OrientDB("remote:localhost","root","root_passwd",OrientDBConfig.defaultConfig());
ODatabasePool pool = new ODatabasePool(orientDB,"test","admin","admin");
// OPEN DATABASE
try (ODatabaseDocument db = pool.acquire() {
   // YOUR CODE
   ...
}
pool.close();
orientDB.close();
```

Remember to close the database instance using the `.close()` database method as you would with classic non-pooled databases.  In cases like the above example, closing the database instance does not actually close it.  Rather, closing it releases the instance back to the pool, where it's made available to future requests.

>**NOTE**: It's best practice to use the `try` blocks here, as it helps you to ensure the database instances are returned to the pool rather than left open.


### Dropping a database

```
OrientDB orientDB = new OrientDB("remote:localhost","root","root_passwd",OrientDBConfig.defaultConfig());// use embedded url for embedded environment
orientDB.drop("test");
```


