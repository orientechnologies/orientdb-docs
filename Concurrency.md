<!-- proofread 2015-11-26 SAM -->
# Concurrency

OrientDB uses an optimistic approach to concurrency.  Optimistic Concurrency Control, or [OCC](http://en.wikipedia.org/wiki/Optimistic_concurrency_control) assumes that multiple transactions can compete frequently without interfering with each other.

## Optimistic Concurrency in OrientDB

Optimistic concurrency control is used in environments with low data contention.  That is, where conflicts are rare and transactions can complete without the expense of managing locks and without having transactions wait for locks to clear. This means a reduced throughput over other concurrency control methods.

OrientDB uses OCC for both [Atomic Operations](Concurrency.md#atomic-operations) and [Transactions](Concurrency.md#transactions).


### Atomic Operations

OrientDB supports Multi-Version Concurrency Control, or [MVCC](http://en.wikipedia.org/wiki/Multiversion_concurrency_control), with atomic operations. This allows it to avoid locking server side resources. At the same time, it checks the version in the database. If the version is equal to the record version contained in the operation, the operation is successful. If the version found is higher than the record version contained in the operation, then another thread or user has already updated the same record.  In this case, OrientDB generates an `OConcurrentModificationException` exception.

Given that behavior of this kind is normal on systems that use optimistic concurrency control, developers need to write concurrency-proof code.  Under this design, the application retries transactions *x* times before reporting the error.  It does this by catching the exception, reloading the affected records and attempting to update them again.  For example, consider the code for saving a document,


```java
int maxRetries = 10;
List<ODocument> result = db.query("SELECT FROM Client WHERE id = '39w39D32d2d'");
ODocument address = result.get(0);

for (int retry = 0; retry < maxRetries; ++retry) {
     try {
          // LOOKUP FOR THE INVOICE VERTEX
          address.field( "street", street );
          address.field( "zip", zip );
          address.field( "city", cityName );
          address.field( "country", countryName );

          address.save();

          // EXIT FROM RETRY LOOP
          break;
	 }
	 catch( ONeedRetryException e ) {
          // IF SOMEONE UPDATES THE ADDRESS DOCUMENT
          // AT THE SAME TIME, RETRY IT.
     }
}
```

### Transactions

OrientDB supports optimistic transactions. The database does not use locks when transactions are running, but when the transaction commits, each record (document or graph element) version is checked to see if there have been updates from another client. For this reason, you need to code your applications to be concurrency-proof.

Optimistic concurrency requires that you retire the transaction in the event of conflicts.  For example, consider a case where you want to connect a new vertex to an existing vertex:

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

          // EXIT FROM RETRY LOOP
          break;
     }
	 catch( OConcurrentModificationException e ) {
          // SOMEONE HAS UPDATED THE INVOICE VERTEX
		  // AT THE SAME TIME, RETRY IT
     }
}
```

#### Concurrency Level

In order to guarantee atomicity and consistency, OrientDB uses an exclusive lock on the storage during transaction commits.  This means that transactions are serialized.

Given this limitation, developers with OrientDB are working on improving parallelism to achieve better scalability on multi-core machines, by optimizing internal structure to avoid exclusive locking.


## Concurrency when Adding Edges

Consider the case where multiple clients attempt to add edges on the same vertex.  OrientDB could throw the `OConcurrentModificationException` exception.  This occurs because collections of edges are kept on vertices,  meaning that, every time OrientDB adds or removes an edge, both vertices update and their versions increment.  You can avoid this issue by using [RIDBAG Bonsai structure](RidBag.md), which are never embedded, so the edge never updates the vertices.
 
To use this configuration at run-time, before launching OrientDB, use this code:

```java
OGlobalConfiguration.RID_BAG_EMBEDDED_TO_SBTREEBONSAI_THRESHOLD.setValue(-1);
```

Alternatively, you can set a parameter for the Java virtual-machine on startup, or even at run-time, before OrientDB is used:

<pre>
$ <code class="lang-sql userinput">java -DridBag.embeddedToSbtreeBonsaiThreshold=-1</code>
</pre>


| ![NOTE](images/warning.png) | While running in distributed mode SBTrees are not supported. If using a distributed database then you must set <pre>ridBag.embeddedToSbtreeBonsaiThreshold = Integer.MAX\_VALUE</pre>  to avoid replication errors. |
|----|:----|


## Troubleshooting

### Reduce Transaction Size

On occasion, OrientDB throws the `OConcurrentModificationException` exception even when you concurrently update the first element. In particularly large transactions, where you have thousands of records involved in a transaction, one changed record is enough to roll the entire process back with an `OConcurrentModificationException` exception.

To avoid issues of this kind, if you plan to update many elements in the same transaction with high-concurrency on the same vertices, a best practice is to reduce the transaction size.


