# Document API

To use the Document API include the following jars in your classpath:
```
orientdb-core-*.jar
```

If you're using the Document Database interface connected to a remote server (not local/embedded mode) include also:
```
orientdb-client-*.jar
orientdb-enterprise-*.jar
```

# Introduction

The Orient Document DB is the base of higher-level implementation like [Object-Database](Object-Database.md) and [Graph-Database](Graph-Database-Tinkerpop.md). The Document Database API has the following features:
- supports [Multi threads](#Multi-threading) access
- supports [Transactions](Transactions.md)
- supports [Queries](#Query)
- supports [Traverse](#Traverse)
- very flexible: can be used in schema-full, schema-less or schema-hybrid mode.

This is an example to store 2 linked documents in the database:
```java
// OPEN THE DATABASE
ODatabaseDocumentTx db = new ODatabaseDocumentTx("remote:localhost/petshop").open("admin", "admin");

// CREATE A NEW DOCUMENT AND FILL IT
ODocument doc = new ODocument("Person");
doc.field( "name", "Luke" );
doc.field( "surname", "Skywalker" );
doc.field( "city", new ODocument("City").field("name","Rome").field("country", "Italy") );

// SAVE THE DOCUMENT
doc.save();

db.close();
```
This is the very first example. While the code is pretty clear and easy to understand please note that we haven't declared the type "Person" before now. When an ODocument instance is saved, the declared type "Person" will be created without constraints. To declare persistent classes look at the [Schema management](Schema.md).

# Use the database

Before to execute any operation you need an opened database instance. You can [open an existent database](#Open_a_database) or [create a new one](#Create_a_new_database). Databases instances aren't thread safe, so use one database per thread.

Before to open or create a database instance you need a valid URL. URL is where the database is available. URL says what kind of database will be used. For example *memory:* means in-memory only database, *plocal:* is for embedded ones and *remote:* to use a remote database hosted on an up & running [DBServer OrientDB Server](Concepts.md#storage) instance. For more information look at [Database URL](Concepts.md#database_url).

Database instances must be closed once finished to release precious resources. To assure it the most common usage is to enclose all the database operations inside a try/finally block:
```java
ODatabaseDocumentTx db = new ODatabaseDocumentTx("plocal:/temp/test");
db.open("admin", "admin");

try {
  // YOUR CODE
} finally {
  db.close();
}
```
If you are using a remote storage (url starts with **"remote:"**) assure the server is up & running and include the **orientdb-client.jar** file in your classpath.

## Multi-threading

The ODatabaseDocumentTx class is non thread-safe. For this reason use different ODatabaseDocumentTx instances by multiple threads. They will share the same Storage instance (with the same URL) and the same level-2 cache. For more information look at [Multi-Threading with Java](Java-Multi-Threading.md).

## Create a new database

### In local filesystem
```java
ODatabaseDocumentTx db = new ODatabaseDocumentTx ("plocal:/tmp/databases/petshop").create();
```
### On a remote server

To create a database in a remote server you need the user/password of the remote OrientDB Server instance. By default the "root" user is created on first startup of the server. Check this in the file config/orientdb-server-config.xml, where you will also find the password.

To create a new document database called dbname on dbhost using filesystem storage (as opposed to in-memory storage):
```java
new OServerAdmin("remote:dbhost")
    .connect("root", "kjhsdjfsdh128438ejhj")
    .createDatabase("dbname","document","local").close();
```

To create a graph database replace "document" with "graph".

To store the database in memory replace "local" with "memory".

## Open a database
```java
ODatabaseDocumentTx db = new ODatabaseDocumentTx ("remote:localhost/petshop").open("admin", "admin");
```
The database instance will share the connection versus the storage. if it's a "local" storage, then all the database instances will be synchronized on it. If it's a "remote" storage then the network connection will be shared among all the database instances.

### Use the connection Pool

One of most common use cases is to reuse the database, avoiding to create it every time. It's also the typical scenario of the Web applications. Instead of creating a new ODatabaseDocumentTx instance all the times, get an available instance from the pool:
```java
// OPEN THE DATABASE
ODatabaseDocumentTx db = ODatabaseDocumentPool.global().acquire("remote:localhost/petshop", "admin", "admin");
try {
  // YOUR CODE
  ...
} finally {
  db.close();
}
```
Remember to always close the database instance using the <code>close()</code> database method like a classic non-pooled database. In this case the database will be not closed for real, but the instance will be released to the pool, ready to be reused by future requests. The best is to use a try/finally block to avoid cases where the database instance remains open, just like the example above.
### Global pool

By default OrientDB provide a global pool declared with maximum 20 instances. Use it with: <code>ODatabaseDocumentPool.global()</code>.
### Use your pool

To create your own pool build it and call the <code>setup(min, max)</code> method to define minimum and maximum managed instances. Remember to close it when the pool is not more used. Example:
```java
// CREATE A NEW POOL WITH 1-10 INSTANCES
ODatabaseDocumentPool pool = new ODatabaseDocumentPool();
pool.setup(1,10);
...
pool.close();
```
# Schema

OrientDB can work in schema-full (like RDBMS), schema-less (like many NoSQL Document databases) and in schema-hybrid mode. For more information about the Schema look at the [Schema](Schema.md) page.

To use the schema with documents create the ODocument instance using the <code>ODocument(String className)</code> constructor passing the class name. If the class hasn't been declared, it's created automatically with no fields. This can't work during transaction because schema changes can't be applied in transactional context.

# Security

Few NoSQL solutions supports security. OrientDB does it. To know more about it look at [Security](Security.md).

To manage the security get the Security Manager and use it to work with users and roles. Example:
```java
OSecurity sm = db.getMetadata().getSecurity();
OUser user = sm.createUser("god", "god", new String[] { "admin" } );
```
To get the reference to the current user use:
```java
OUser user = db.getUser();
```
# Create a new document

ODocument instances can be saved by calling the save() method against the object itself. Note that the behaviour depends on the running transaction, if any. See [Transactions](Transactions.md).
```java
ODocument animal = new ODocument("Animal");
animal.field( "name", "Gaudi" );
animal.field( "location", "Madrid" );
animal.save();
```
# Retrieve documents

## Browse all the documents in a cluster
```java
for (ODocument doc : database.browseCluster("CityCars")) {
  System.out.println( doc.field("model") );
```
## Browse all the records of a class
```java
for (ODocument animal : database.browseClass("Animal")) {
  System.out.println( animal.field( "name" ) );
```
## Count records of a class
```java
long cars = database.countClass("Car");
```
v= Count records of a cluster ==
```java
long cityCars = database.countCluster("CityCar");
```
## Execute a query

Although OrientDB is part of the NoSQL database community, it supports a subset of SQL that allows it to process links to documents and graphs.

To know more about the SQL syntax supported go to: [SQL-Query](SQL-Query.md).

Example of a SQL query:
```java
List<ODocument> result = db.query(
  new OSQLSynchQuery<ODocument>("select * from Animal where ID = 10 and name like 'G%'"));
```

### Asynchronous query

OrientDB supports asynchronous queries. The result is not collected and returned like synchronous ones (see above) but a callback is called every time a record satisfy the predicates:

```java
database.command(
  new OSQLAsynchQuery<ODocument>("select * from animal where name = 'Gipsy'",
    new OCommandResultListener() {
      resultCount = 0;
      @Override
      public boolean result(Object iRecord) {
        resultCount++;
        ODocument doc = (ODocument) iRecord;
        // DO SOMETHING WITH THE DOCUMENT

        return resultCount > 20 ? false : true;
      }

      @Override
      public void end() {
      }
    })).execute();
```

Asynchronous queries are useful to manage big result sets because don't allocate memory to collect results.

### Non-Blocking query (since v2.1)

Both Synchronous and Asynchronous queries are blocking, that means that the first instruction you have after db.query() or db.command().execute() will be executed only after you received all the result-set or last callback was invoked. 
OrientDB also supports non-blocking queries. The API is very similar to asynchronous queries (you have a callback that is invoked for every record in the result-set), but the behavior is completely different: the execution of your current thread continues without blocking on the db.query() or db.command().execute(), and the callback is invoked by a different thread. That means that in the meantime you can close your db instance and keep on receiving callbacks from the query result.

```java
Future future = database.command(new OSQLNonBlockingQuery<Object>("select * from animal where name = 'Gipsy'",
    new OCommandResultListener() {
      resultCount = 0;
      @Override
      public boolean result(Object iRecord) {
        resultCount++;
        ODocument doc = (ODocument) iRecord;
        // DO SOMETHING WITH THE DOCUMENT

        System.out.println("callback "+resultCount+" invoked");
        return resultCount > 20 ? false : true;
      }

      @Override
      public void end() {
      }
    })).execute();

System.out.println("query executed");

future.get();
```

the result of this snippet of code will be something like

```
query executed
callback 0 invoked
callback 1 invoked
callback 2 invoked
callback 3 invoked
callback 4 invoked
```

but it could also be 

```
callback 0 invoked
callback 1 invoked
query executed
callback 2 invoked
callback 3 invoked
callback 4 invoked
```

depending on race conditions on the two parallel threads (the one that fires query execution and then continues with "query executed", and the other one that invokes callbacks).

```future.get();``` is a blocking call that returns only after last callback invocation (you can avoid this if you don't need to know when the query terminates).

### Prepared query

Prepared query are quite similar to the Prepared Statement of JDBC. Prepared queries are pre-parsed so on multiple execution of the same query are faster than classic SQL queries. Furthermore the pre-parsing doesn't allow SQL Injection.
Note: prepared queries (parameter substition) only works with select statements (but not select statements within other types of queries such as "create vertex").

Prepared query uses two kinds of markers to substitute parameters on execution:
```java
? is positional parameter
:<par> is named parameter
```

Example of positional parameters:
```java
OSQLSynchQuery<ODocument> query = new OSQLSynchQuery<ODocument>("select from Profile where name = ? and surname = ?");
List<ODocument> result = database.command(query).execute("Barack", "Obama");
```
Example of named parameters:
```java
OSQLSynchQuery<ODocument> query = new OSQLSynchQuery<ODocument>("select from Profile where name = :name and
  surname = :surname");
Map<String,Object> params = new HashMap<String,Object>();
params.put("name", "Barack");
params.put("surname", "Obama");

List<ODocument> result = database.command(query).execute(params);
```
#### Right usage of the graph

OrientDB is a graph database. This means that traversing is very efficient. You can use this feature to optimize queries. A common technique is the [Pivoting](Pivoting-With-Query.md).

### SQL Commands

To execute SQL commands use the <code>command()</code> method passing a OCommandSQL object:
```java
int recordsUpdated = db.command(
  new OCommandSQL("update Animal set sold = false")).execute();
```

If the command modifies the schema (like `create/alter/drop class` and `create/alter/drop property` commands), remember to force updating of the schema of the database instance you're using:

```java
db.getMetadata().getSchema().reload();
```

For more information look at the [available SQL commands](SQL.md).

## Traverse records

Traversing is the operation to cross documents by links (relationships). OrientDB is a graph database so this operation is much much more efficient than executing a JOIN in the relational databases. To know more about traversing look at the [Java traverse API](Java-Traverse.md).

The example below traverses, for each movie, all the connected records up to the 5th depth level.
```java
for (OIdentifiable id : new OTraverse()
              .field("in").field("out")
              .target( database.browseClass("Movie").iterator() )
              .predicate(new OCommandPredicate() {

    public boolean evaluate(ORecord<?> iRecord, OCommandContext iContext) {
      return ((Integer) iContext.getVariable("depth")) <= 5;
    }
  })) {

  System.out.println(id);
}
```
# Update a document

Any persistent document can be updated by using the Java API and then by calling the db.save() method.  Alternatively, you can call the document's save() method to synchronize the changes to the database. The behaviour depends on the transaction begun, if any.  See [Transactions](Transactions.md).
```java
animal.field( "location", "Nairobi" );
animal.save();
```
OrientDB will update only the fields really changed.

Example of how to increase the price of all the animals by 5%:
```java
for (ODocument animal : database.browseClass("Animal")) {
  animal.field( "price", animal.field( "price" ) * 105 / 100 );
  animal.save();
}
```
# Delete a document

To delete a document call the delete() method on the document instance that's loaded.  The behaviour depends on the transaction begun, if any.  See [Transactions](Transactions.md).
```java
animal.delete();
```
Example of deletion of all the documents of class "Animal".
```java
for (ODocument animal : database.browseClass("Animal"))
  animal.delete();
```
# Transactions

Transactions are a practical way to group a set of operations together.  OrientDB supports [ACID](http://en.wikipedia.org/wiki/ACID) transactions so that all or none of the operations succeed.  The database always remains consistent.  For more information look at [Transactions](Transactions.md).

Transactions are managed at the database level.  Nested transactions are currently not supported.  A database instance can only have one transaction running.  The database's methods to handle transactions are:
- **<code>begin()</code>** to start a new transaction. If a transaction was already running, it's rolled back and a new one is begun.
- **<code>commit()</code>** makes changes persistent. If an error occurs during commit the transaction is rolled back and an OTransactionException exception is raised.
- **<code>rollback()</code>** aborts a transaction.  All the changes will be lost.

## Optimistic approach

The current release of OrientDB only supports [OPTIMISTIC transactions](Transactions.md#optimistic_transaction) where no lock is kept and all operations are checked at commit time.  This improves concurrency but can throw an <code>OConcurrentModificationException</code> exception in the case where records are modified by concurrent clients or threads.  In this scenario, the client code can reload the updated records and repeat the transaction.

Optimistic transactions keep all the changes in memory in the client.  If you're using remote storage no changes are sent to the server until <code>commit()</code> is called.  All the changes will be transferred in a block.  This reduces network latency, speeds-up the execution, and increases concurrency.  This is a big difference compared to most Relational DBMS where, during a transaction, changes are sent immediately to the server.

## Usage

Transactions are committed only when the <code>commit()</code> method is called and no errors occur.  The most common usage of transactions is to enclose all the database operations inside a <code>try/finally</code> block.  On closing of the database ("finally" block) if a pending transaction is running it will be rolled back automatically.  Look at this example:
```java
ODatabaseDocumentTx db = new ODatabaseDocumentTx(url);
db.open("admin", "admin");

try {
  db.begin();
  // YOUR CODE
  db.commit();
} finally {
  db.close();
}
```
# Index API

Even though you can use [Indices](Indexes.md) via SQL, the best and most efficient way is to use the Java API.

The main class to use to work with indices is the [IndexManager](http://www.orientechnologies.com/javadoc/latest/com/orientechnologies/orient/core/index/OIndexManager.html). To get the implementation of the [IndexManager](http://www.orientechnologies.com/javadoc/latest/com/orientechnologies/orient/core/index/OIndexManager.html) use:
```java
OIndexManager idxManager = database.getMetadata().getIndexManager();
```
The Index Manager allows you to manage the index life-cycle for creating, deleting, and retrieving an index instance.  The most common usage is with a single index.  You can get the reference to an index by using:
```java
OIndex<?> idx = database.getMetadata().getIndexManager().getIndex("Profile.name");
```
Where "Profile.name" is the index name. Note that by default OrientDB assigns the name as <code>&lt;class&gt;.&lt;property&gt;</code> for automatic indices created against a class's property.

The [OIndex](http://www.orientechnologies.com/javadoc/latest/com/orientechnologies/orient/core/index/OIndex.html) interface is similar to a Java Map and provides methods to get, put, remove, and count items.  The following are examples of retrieving records using a UNIQUE index against a name field and a NOTUNIQUE index against a gender field:
```java
OIndex<?> nameIdx = database.getMetadata().getIndexManager().getIndex("Profile.name");

// THIS IS A UNIQUE INDEX, SO IT RETRIEVES A OIdentifiable
OIdentifiable luke = nameIdx.get( "Luke" );
if( luke != null )
  printRecord( (ODocument) luke.getRecord() );

OIndex<?> genderIdx = database.getMetadata().getIndexManager().getIndex("Profile.gender");

// THIS IS A NOTUNIQUE INDEX, SO IT RETRIEVES A Set<OIdentifiable>
Set<OIdentifiable> males = genderIdx.get( "male" );
for( OIdentifiable male : males )
  printRecord( (ODocument) male.getRecord() );
```
While automatic indices are managed automatically by OrientDB hooks, the manual indices can be used to store any value. To create a new entry use the <code>put()</code>:
```java
OIndex<?> addressbook = database.getMetadata().getIndexManager().getIndex("addressbook");

addressbook.put( "Luke", new ODocument("Contact").field( "name", "Luke" );
```
# Resources

- Javadoc: [JavaDoc](http://www.orientechnologies.com/javadoc/latest/)
- [OrientDB Studio Web tool](Home-page.md).