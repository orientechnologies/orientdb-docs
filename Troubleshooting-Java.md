# Troubleshooting using Java API


## OConcurrentModificationException: Cannot update record #X:Y in storage 'Z' because the version is not the latest. Probably you are updating an old record or it has been modified by another user (db=vA your=vB)

This exception happens because you're running in a Multi Version Control Check (MVCC) system and another thread/user has updated the record you're saving. For more information about this topic look at [Concurrency](Concurrency.md). To fix this problem you can:
- Change the Graph [consistency level](Graph-Consistency.md) to don't use transactions.
- Or write code concurrency proof.

Example:
```java
for (int retry = 0; retry < maxRetries; ++retry) {
  try {
    // APPLY CHANGES
    document.field(name, "Luca");

    document.save();
    break;
  } catch(ONeedRetryException e) {
    // RELOAD IT TO GET LAST VERSION
    document.reload();
  }
}
```

The same in transactions:
```java
for (int retry = 0; retry < maxRetries; ++retry) {
  db.begin();
  try {
    // CREATE A NEW ITEM
    ODocument invoiceItem = new ODocument("InvoiceItem");
    invoiceItem.field(price, 213231);
    invoiceItem.save();

    // ADD IT TO THE INVOICE
    Collection<ODocument> items = invoice.field(items);
    items.add(invoiceItem);
    invoice.save();

    db.commit();
    break;
  } catch (OTransactionException e) {
    // RELOAD IT TO GET LAST VERSION
    invoice.reload();
  }
}
```


Where <code>maxRetries</code> is the maximum number of attempt of reloading.

## Run in OSGi context

(by Raman Gupta)
OrientDB uses [ServiceRegistry](http://docs.oracle.com/javase/7/docs/api/javax/imageio/spi/ServiceRegistry.html) to load OIndexFactory and some OSGi containers might not work with it.

One solution is to set the TCCL so that the [ServiceRegistry](http://docs.oracle.com/javase/7/docs/api/javax/imageio/spi/ServiceRegistry.html) lookup works inside of OSGi:
```java
ODatabaseObjectTx db = null;
ClassLoader origClassLoader = Thread.currentThread().getContextClassLoader();
try {
  ClassLoader orientClassLoader = OIndexes.class.getClassLoader();
  Thread.currentThread().setContextClassLoader(orientClassLoader);
  db = objectConnectionPool.acquire(dbUrl, username, password);
} finally {
  Thread.currentThread().setContextClassLoader(origClassLoader);
}
```
Because the [ServiceLoader](http://docs.oracle.com/javase/6/docs/api/java/util/ServiceLoader.html) uses the thread context classloader, you can configure it to use the classloader of the OrientDB bundle so that it finds the entries in META-INF/services.

Another way is to embed the dependencies in configuration in the Maven pom.xml file under plugin(maven-bundle-plugin)/configuration/instructions:

```xml
<Embed-Dependency>
  orientdb-client,
  orient-commons,
  orientdb-core,
  orientdb-enterprise,
  orientdb-object,
  javassist
</Embed-Dependency>
```

Including only the jars you need. Look at [Which library do I use?](Java-API.md#which_library_do_i_use?)

## Database instance has been released to the pool. Get another database instance from the pool with the right username and password

This is a generic error telling that the database has been found closed while using it.

Check the stack trace to find the reason of it:

## OLazyObjectIterator

This is the case when you're working with [Object Database API](Object-Database.md) and a field contains a collection or a map loaded in lazy. On iteration it needs an open database to fetch linked records.

Solutions:
- assure to leave the database open while browsing the field
- or early load all the instances (just iterate the items)
- define a fetch-plan to load the entire object tree in one shoot and then work offline. If you need to save the object back to the database then reopen the database and call <code>db.save( object )</code>.

## Stack Overflow on saving objects

This could be due to the high deep of the graph, usually when you create many records. To fix it save the records more often.
