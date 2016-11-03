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

## Graph API

```java
for (int retry = 0; retry < maxRetries; ++retry) {

   try {

      // APPLY CHANGES
      vertex.setProperty("name", "Luca");
      vertex.addEdge("Buy", product);

      breakl

   } catch(ONeedRetryException e) {

      // RELOAD IT TO GET LAST VERSION
      vertex.reload();
      product.reload();
   }
}
```

## Document API

```java
for (int retry = 0; retry < maxRetries; ++retry) {

   try {

      // APPLY CHANGES
      document.field("name", "Luca");
      document.save();

      break;

   } catch(ONeedRetryException e) {

      // RELOAD IT TO GET LAST VERSION
      document.reload();
   }
}
```

## Transactions

There is a similar procedure used with transactions:

```java
for (int retry = 0; retry < maxRetries; ++retry) {

   db.begin();

   try {

      // CREATE A NEW ITEM
      ODocument invoiceItem = new ODocument("InvoieItem");
      invoiceItem.field("price", 213231);
      invoiceItem.save();

      // ADD IT TO THE INVOICE
      Collection<ODocument> items = invoice.field(items);
      items.add(invoiceItem);
      invoice.save();

      db.commit();
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
ODatabaseDocumentTx db1 = new
   ODatabaseDocumentTx("plocal:/tmp/db1")
   .create(); // SETS CURRENT DB TO db1
db1.begin();

ODocument doc1 = new ODocument("Customer");
doc1.field("name", "Luca");
doc1.save(); // OPERATION BOUND TO db1 TRANSACTION

ODatabaseDocumenTx db2 = new
   ODatabaseDocumentTx("plocal:/tmp/db2")
   .create(); // SETS CURRENT DB TO db2

ODocument doc2 = new ODocument("Provider");
doc2.field("name", "Chuck");
doc2.save(); // OPERATION BOUND TO db2 BECAUSE IT'S CURRENT

db1.activateOnCurrentThread();
db1.commit(); // COMMITS TRANSACTION FOR doc1 ONLY
```
