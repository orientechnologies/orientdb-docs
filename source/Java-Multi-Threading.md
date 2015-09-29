# Multi-Threading

OrientDB supports multi-threads access to the database. `ODatabase*` and `OrientGraph*` instances are not thread-safe, so you've to get *an instance per thread* and each database instance can be used *only in one thread per time*. For more information about how concurrency is managed by OrientDB look at [Concurrency](Concurrency.md).

|![](images/warning.png)|Since v2.1 OrientDB doesn't allow implicit usage of multiple database instances from the same thread. Any attempt to manage multiple instances in the same thread must explicitly call the method `db.activateOnCurrentThread()` against the database instance BFORE you use it.|
|---|---|

Multiple database instances points to the same storage by using the same URL. In this case Storage is thread-save and orchestrates requests from different ```ODatabase*``` instances.

```
ODatabaseDocumentTx-1------+
                           +----> OStorage (url=plocal:/temp/db)
ODatabaseDocumentTx-2------+
```

The same as for Graph API:

```
OrientGraph-1------+
                   +----> OStorage (url=plocal:/temp/db)
OrientGraph-2------+
```

Database instances share the following objects:
- schema
- index manager
- security

These objects are synchronized for concurrent contexts by storing the current database in the [ThreadLocal](http://download.oracle.com/javase/6/docs/api/java/lang/ThreadLocal.html) variable. Every time you create, open or acquire a database connection, the database instance is **automatically** set into the current [ThreadLocal](http://download.oracle.com/javase/6/docs/api/java/lang/ThreadLocal.html) space, so in normal use this is hidden from the developer.

The current database is always reset for all common operations like load, save, etc.

Example of using two database in the same thread:
```java
ODocument rec1 = database1.newInstance();
ODocument rec2 = database2.newInstance();

rec1.field("name", "Luca");
database1.activateOnCurrentThread(); // MANDATORY SINCE 2.1
database1.save(rec1); // force saving in database1 no matter where the record came from

rec2.field("name", "Luke");
database2.activateOnCurrentThread(); // MANDATORY SINCE 2.1
database2.save(rec2); // force saving in database2 no matter where the record came from
```

In version 2.0.x, method ```activateOnCurrentThread()``` does not exist, you can use ```setCurrentDatabaseInThreadLocal()``` instead.


## Get current database

To get the current database from the [ThreadLocal](http://download.oracle.com/javase/6/docs/api/java/lang/ThreadLocal.html) use:

```java
ODatabaseDocument database = (ODatabaseDocument) ODatabaseRecordThreadLocal.INSTANCE.get();
```

## Manual control

Beware when you reuse database instances from different threads or then a thread handle multiple databases. In this case you can override the current database by calling this manually:

```java
database.activateOnCurrentThread(); //v 2.1
// for OrientDB v. 2.0.x: database.setCurrentDatabaseInThreadLocal();
```

Where database is the current database instance. Example:

```java

database1.activateOnCurrentThread();
ODocument rec1 = database1.newInstance();
rec1.field("name", "Luca");
rec1.save();

database2.activateOnCurrentThread();
ODocument rec2 = database2.newInstance();
rec2.field("name", "Luke");
rec2.save();
```

## Custom database factory

Since v1.2 Orient provides an interface to manage custom database management in MultiThreading cases:

```java
public interface ODatabaseThreadLocalFactory {
  public ODatabaseRecord getThreadDatabase();
}
```

Examples:
```java
public class MyCustomRecordFactory implements ODatabaseThreadLocalFactory {

  public ODatabaseRecord getDb(){
   return ODatabaseDocumentPool.global().acquire(url, "admin", "admin");
  }
}


public class MyCustomObjectFactory implements ODatabaseThreadLocalFactory {
  public ODatabaseRecord getThreadDatabase(){
   return OObjectDatabasePool.global().acquire(url, "admin", "admin").getUnderlying().getUnderlying();
  }
}
```

Registering the factory:

```java
ODatabaseThreadLocalFactory customFactory = new MyCustomRecordFactory();
 Orient.instance().registerThreadDatabaseFactory(customFactory);
```

When a database is not found in current thread it will be called the factory getDb() to retrieve the database instance.

## Close a database

What happens if you are working with two databases and close just one? The Thread Local isn't a stack, so you loose the previous database in use. Example:
```java
ODatabaseDocumentTx db1 = new ODatabaseDocumentTx("local:/temo/db1").create();
ODatabaseDocumentTx db2 = new ODatabaseDocumentTx("local:/temo/db2").create();
...

db2.close();

// NOW NO DATABASE IS SET IN THREAD LOCAL. TO WORK WITH DB1 SET IT IN THE THREAD LOCAL
db1.activateOnCurrentThread();
...
```

## Multi Version Concurrency Control

If two threads update the same record, then the last one receive the following exception:
"OConcurrentModificationException: Cannot update record #X:Y in storage 'Z' because the version is not the latest. Probably you are updating an old record or it has been modified by another user (db=vA your=vB)"

This is because every time you update a record, the version is incremented by 1. So the second update fails checking the current record version in database is higher than the version contained in the record to update.

This is an example of code to manage the concurrency properly:

### Graph API

```java
for( int retry = 0; retry < maxRetries; ++retry ) {
  try{
    // APPLY CHANGES
    vertex.setProperty( "name", "Luca" );
    vertex.addEdge( "Buy", product );

    break;
  } catch( ONeedRetryException e ) {
    // RELOAD IT TO GET LAST VERSION
    vertex.reload();
    product.reload();
  }
}
```

### Document API

```java
for( int retry = 0; retry < maxRetries; ++retry ) {
  try{
    // APPLY CHANGES
    document.field( "name", "Luca" );

    document.save();
    break;
  } catch( ONeedRetryException e ) {
    // RELOAD IT TO GET LAST VERSION
    document.reload();
  }
}
```

The same in transactions:
```java
for( int retry = 0; retry < maxRetries; ++retry ) {
  db.begin();
  try{
    // CREATE A NEW ITEM
    ODocument invoiceItem = new ODocument("InvoiceItem");
    invoiceItem.field( "price", 213231 );
    invoiceItem.save();

    // ADD IT TO THE INVOICE
    Collection<ODocument> items = invoice.field( items );
    items.add( invoiceItem );
    invoice.save();

    db.commit();
    break;
  } catch( OTransactionException e ) {
    // RELOAD IT TO GET LAST VERSION
    invoice.reload();
  }
}
```

Where <code>maxRetries</code> is the maximum number of attempt of reloading.

# What about running transaction?

Transactions are bound to a database, so if you change the current database while a tx is running, the deleted and saved objects remain attached to the original database transaction. When it commits, the objects are committed.

Example:
```java
ODatabaseDocumentTx db1 = new ODatabaseDocumentTx("local:/temo/db1").create();

db1.begin();

ODocument doc1 = new ODocument("Customer");
doc1.field("name", "Luca");
doc1.save(); // NOW IT'S BOUND TO DB1'S TX

ODatabaseDocumentTx db2 = new ODatabaseDocumentTx("local:/temo/db2").create(); // THE CURRENT DB NOW IS DB2

ODocument doc2 = new ODocument("Provider");
doc2.field("name", "Chuck");
doc2.save(); // THIS IS BOUND TO DB2 BECAUSE IT'S THE CURRENT ONE

db1.activateOnCurrentThread();
db1.commit(); // WILL COMMIT DOC1 ONLY
```
