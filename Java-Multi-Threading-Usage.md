---
search:
   keywords: ['Java API', 'mutli-thread', 'multithread']
---

# Working with Multi-threading

When developing multi-threaded applications with OrientDB, the simplest way to operate on the same database through additional threads is to create a new database instance within the scope of the `run()` method.  Doing so causes OrientDB to set the new database automatically in `ThreadLocal` for further use.

For instance,

```java
OrientGraphFactory factory = new OrientGraphFactory(
   "remote:localhost/petshop")
   .setupPool(10, 20);

new Thread(
   new Runable() {
      public void run() {
         OrientBaseGraph graph = factory.getTx();

         try {
            // OPERATION WITH THE GRAPH INSTANCE
            graph.addVertex(
               "class:Account", "name", "Amiga Corporation"
            );
         } finally {
            graph.shutdown();
         }
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
database1.activateOnCurrentThread(); // MANDATORY SINCE 2.1
database1.save(rec1);

rec2.field("name", "Luke");
database2.activeOnCurrentTHread(); // MANDATORY SINCE 2.1
database2.save(rec2);
```

In the above example, bear in mind that the `activeOnCurrentThread()` method is mandatory as of version 2.1 of OrientDB.  Also, that the `save()` method forces saving on the database, no matter where the record comes from.

>In version 2.0.x and earlier of OrientDB, the `activateOnCurrentThread()` method doesn't exist.  Instead, use the `setCurrentDatabaseInThreadLocal()` method.


### Retrieving Current Databases

To get the current database from `ThreadLocal`, use:

```java
ODatabaseDocument dataabase = (ODatabaseDocument)
   ODatabaseRecordThreadLocal.INSTANCE.get();
```


### Manual Control

When you reuse database instances from different threads or attempt to handle multiple instances on a single thread, you may occasionally run into conflicts, where two threads are attempting to use the same instance or where one thread is trying to use two instances.  In such cases, you can override the current database by manually enabling control.

- From version 2.1 of OrientDB and later, use the `activateOnCurrentThread()` method on the database instance.

- For version 2.0 of OrientDB and earlier, use the `setCurrentDatabaseInThreadLocal` method.

For instance,

```java
database1.activateOnCurrentThread();
ODocument rec1 = database1.newInstance();
rec1.field("name", "Luca");
rec.save();

database2.activateOnCurrentThread();
ODocument rec2 = database2.newInstance();
rec2.field("name", "Luke");
rec2.save();
```

### Custom Database Factory

Beginning in version 1.2, OrientDB provides an interface to enable custom database management in mutli-threading use-cases.You can use this in building a custom database factory.

```java
public interface ODatabaseThreadLocalFactory {
   public ODatabaseRecord getThreadDatabase();
}
```

For instance,

```java
public class MyCustomRecordFacctory
      implements ODatabaseThreadLocalFactory {

   public ODatabaseRecord getDb() {
      return ODatabaseDocumentPool
         .global()
         .acquire(url, "admin", "admin_passwd");
   }
}

public class MyCustomObjectFactory
      implements ODatabaseThreadLocalFactory {
   
   public ODatabaseRecord getThreadDatabase() {
      return OObjectDatabasePool
         .global()
         .acquire(url, "admin", "admin_passwd")
         .getUnderlying()
         .getUnderlying();
   }
}
```

To then register the factory, you might use the following code:

```java
ODatabaseThreadLocalFactory customFactory = new 
   MyCustomRecordFactory();
Orient.instance()
   .registerThreadDatabaseFactory(customFactory);
```

Whenever a database is not found in the current thread, OrientDB calls the factory `getDb()` to retrieve the database instance.

### Closing Databases

`ThreadLocal` isn't a stack.  In the event that you are working with two databases and close one, you lose the previous database that was in use.  For instance,

```java
ODatabaseDocumentTx db1 = new 
   ODatabaseDocumentTx("plocal:/tmp/db1")
   .create();
ODatabaseDocumentTx db2 = new
   ODatabaseDocumentTx("plocal:/tmp/db2")
   .create();

...

db2.close()
```

The database is not set in `ThreadLocal`.  In order to work with `db1` from this point on, you need to call the `activateOnCurrentThread()` method.

```java
db1.activateOnCurrentThread();
```
