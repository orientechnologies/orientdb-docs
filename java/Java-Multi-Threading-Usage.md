
# Working with Multi-threading

When developing multi-threaded applications with OrientDB, the simplest way to operate on the same database through additional threads is to create a new database instance within the scope of the `run()` method.  Doing so causes OrientDB to set the new database automatically in `ThreadLocal` for further use.

For instance,

```java
OrientGraphFactory factory = new OrientGraphFactory(
   "remote:localhost/petshop")
   .setupPool(10, 20);
new Thread(() -> {
  OrientBaseGraph graph = factory.getTx();

  try {
    // OPERATION WITH THE GRAPH INSTANCE
    graph.addVertex("class:Account", "name", "Amiga Corporation"
    );
  } finally {
    graph.shutdown();
  }

}).start();
```

In the event that you are using a database instance that was created in another thread, ensure that you active the instance before using it.  The activation API's are,

- **Graph API** `graph.makeActive()`
- **Document API** `database.activateOnCurrentThread()`


## Multiple Databases

When using multiple database instances on the same thread, you must explicitly set the database or graph instance before using it.  For instance,

```java
ODocument rec1 = database1.newInstance();
ODocument rec2 = database2.newInstance();

rec1.field("name", "Luca");
database1.activateOnCurrentThread();
database1.save(rec1);

rec2.field("name", "Luke");
database2.activeOnCurrentTHread();
database2.save(rec2);
```

In the above example, bear in mind that the `activeOnCurrentThread()` method is mandatory as of version 2.1 of OrientDB.  Also, that the `save()` method forces saving on the database, no matter where the record comes from.

### Closing Databases

`ThreadLocal` isn't a stack.  In the event that you are working with two databases and close one, you lose the previous database that was in use.  For instance,

```java
ODatabaseDocument db1 = orientDB.open("db1","admin","admin");
ODatabaseDocument db2 = orientDB.open("db2","admin","admin");

...

db2.close()
```

The database is not set in `ThreadLocal`.  In order to work with `db1` from this point on, you need to call the `activateOnCurrentThread()` method.

```java
db1.activateOnCurrentThread();
db1.close();
```
