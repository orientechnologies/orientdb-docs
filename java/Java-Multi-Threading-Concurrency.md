# Multi Version Concurrency Control

In the event that your application has two threads that attempt to update the same record, the last one issued receives the following exception:

```
OConcurrentModificationException: Cannot update records
#X:Y in storage 'Z' because the version is not the latest.
Probably you are updating an old record or it has been
modified by another user (db=vA your=vB)
```

Every time you update a record, the version number for that record gets incremented by one.  What this means is, when the instance that fails attempts to update the record, it finds that the version it is trying to update is behind what's current on the database.

Below are examples of how to properly manage version concurrency.

## Database Retry API

```
   ORID id = ...///
   // As first parameter you set the number of wanted retry, at second paramenter a lambda with your business logic 
   session.executeWithRetry(10, (currentSession) -> {
      currentSession.begin();
      OElement loaded = currentSession.load(id);
      loaded.setProperty("two", "three");
      currentSession.save(loaded);
      currentSession.commit();
      return null;
    });
```


## Database API Custom Retry

```java
for (int retry = 0; retry < maxRetries; ++retry) {

   try {

      // APPLY CHANGES
      document.field("name", "Luca");
      database.save(document);

      break;

   } catch(ONeedRetryException e) {

      // RELOAD IT TO GET LAST VERSION
      document.reload();
   }
}
```

## Tinkerpop Graph API Custom Retry

```java
for (int retry = 0; retry < maxRetries; ++retry) {

   try {

      // APPLY CHANGES
      vertex.setProperty("name", "Luca");
      vertex.addEdge("Buy", product);

      break;

   } catch(ONeedRetryException e) {

      // RELOAD IT TO GET LAST VERSION
      vertex.reload();
      product.reload();
   }
}
```


## Transactions Custom Retry

There is a similar procedure used with transactions:

```java
for (int retry = 0; retry < maxRetries; ++retry) {

   database.begin();

   try {

      // CREATE A NEW ITEM
      ODocument invoiceItem = new ODocument("InvoieItem");
      invoiceItem.field("price", 213231);
      database.save(invoiceItem;

      // ADD IT TO THE INVOICE
      Collection<ODocument> items = invoice.field(items);
      items.add(invoiceItem);
      database(invoice);

      database.commit();
      break;

  } catch(OTransactionException e) {
     
     // RELOAD IT TO GET LAST VERSION
     invoice.reload();
  }
}
```

Where `maxRetries` is the maximum number of attempts of reloading.


### Running Transactions

Transactions are bound to a database.  If you change the current database while a transaction is running, the deleted and saved objects remain attached to the original database transaction.  When it commits, the objected are committed.

For instance,

```java
ODatabaseDocument db1 =orientDB.open("db1","admin","admin"); // SETS CURRENT DB TO db1
db1.begin();

ODocument doc1 = new ODocument("Customer");
doc1.field("name", "Luca");
database.save(doc1); // OPERATION BOUND TO db1 TRANSACTION

ODatabaseDocumen db2 = orientDB.open("db2","admin","admin"); // SETS CURRENT DB TO db2

ODocument doc2 = new ODocument("Provider");
doc2.field("name", "Chuck");
db2.save(doc2); // OPERATION BOUND TO db2 BECAUSE IT'S CURRENT

db1.activateOnCurrentThread();
db1.commit(); // COMMITS TRANSACTION FOR doc1 ONLY
```
