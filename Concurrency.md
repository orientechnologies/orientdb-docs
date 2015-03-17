# Concurrency

OrientDB has an [optimistic approach to concurrency](http://en.wikipedia.org/wiki/Optimistic_concurrency_control): "Optimistic Concurrency Control (OCC) assumes that multiple transactions can frequently complete without interfering with each other. While running, transactions use data resources without acquiring locks on those resources. Before committing, each transaction verifies that no other transaction has modified the data it has read. If the check reveals conflicting modifications, the committing transaction rolls back and can be restarted.

OCC is generally used in environments with low data contention. When conflicts are rare, transactions can complete without the expense of managing locks and without having transactions wait for other transactions' locks to clear, leading to higher throughput than other concurrency control methods. However, if contention for data resources is frequent, the cost of repeatedly restarting transactions hurts performance significantly; it is commonly thought that other concurrency control methods have better performance under these conditions. However, locking-based ("pessimistic") methods also can deliver poor performance because locking can drastically limit effective concurrency even when deadlocks are avoided." - Wikipedia

OrientDB uses this approach on both atomic operations by using [Multi Version Concurrency Control (MVCC)](http://en.wikipedia.org/wiki/Multiversion_concurrency_control) and Transactions.

## Atomic operations
OrientDB supports [Multi Version Concurrency Control (MVCC)](http://en.wikipedia.org/wiki/Multiversion_concurrency_control) with atomic operations. This allows to avoid locking server side resources. At save time the version in database is checked. If it's equals to the record version contained in the operation, the operation succeed. If the version found in database is higher than the record version contained in the operation, then another thread/user already updated the same record in the meanwhile. In this case an `OConcurrentModificationException` exception is thrown.

Since this behavior is considered normal on Optimistic Systems, the developer should write a concurrency-proof code that retry X times before to report the error, by catching the exception, reloading the affected records and try updating them again. Below an example of saving a document.

## Transaction
OrientDB supports optimistic transactions, so no lock is kept when a transaction is running, but at commit time each record (document, or graph element) version is checked to see if there has been an update by another client. This is the reason why you should write your code to be concurrency-proof by handling the concurrent updating case:

```java
int maxRetries = 10;
List<ODocument> result = db.query("select from Client where id = '39w39D32d2d'");
ODocument address = result.get(0);

for (int retry = 0; retry < maxRetries; ++retry) {
  try {
    // LOOKUP FOR THE INVOICE VERTEX
    address.field( "street", street );
    address.field( "zip", zip );
    address.field( "city", cityName );
    address.field( "country", countryName );

    address.save();

    // OK, EXIT FROM RETRY LOOP
    break;
  } catch( ONeedRetryException e ) {
    // SOMEONE HAVE UPDATE THE ADDRESS DOCUMENT AT THE SAME TIME, RETRY IT
  }
}
```

## Concurrency with Graphs

Optimistic concurrency requires the transaction is retried in case of conflict. Example:

```java
int maxRetries = 10;
for (int retry = 0; retry < maxRetries; ++retry) {
  try {
    // LOOKUP FOR THE INVOICE VERTEX
    Vertex invoice = graph.getVertices("invoiceId", 2323);
    // CREATE A NEW ITEM
    Vertex invoiceItem = graph.addVertex("class:InvoiceItem");
    invoiceItem.field("price", 1000);
    // ADD IT TO THE INVOICE
    invoice.addEdge(invoiceItem);
    graph.commit();

    // OK, EXIT FROM RETRY LOOP
    break;
  } catch( OConcurrentModificationException e ) {
    // SOMEONE HAVE UPDATE THE INVOICE VERTEX AT THE SAME TIME, RETRY IT
  }
}
```

Note OConcurrentModificationException can be thrown when any graph element has been update in the meanwhile. 

## Concurrency on adding edges

What happens when multiple clients add edges on the same vertex? OrientDB could throw the `OConcurrentModificationException` exception as well. Why? Because collection of edges are kept on vertices, so every time an edge is added or removed, both involved vertices are updated, and their versions incremented.



### 