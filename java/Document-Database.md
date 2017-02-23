---
search:
   keywords: ['Java', 'Document API']
---

# Document API

The Document Database in OrientDB is the foundation of higher level implementations, like the [Object Database](Object-Database.md) and the [Graph Database](Graph-Database-Tinkerpop.md).  The Document API supports:

- [Multi-thread Access](#Multi-threading)
- [Transactions](../Transactions.md)
- [Queries](Document-API-Documents.md#retrieving-documents)
- [Traverse](Document-API-Documents.md#traversing-documents)


It is also very flexible and can be used in schema-full, schema-less or mixed schema modes.

```java
// OPEN THE DATABASE
ODatabaseDocumentTx db = new ODatabaseDocumentTx(
   "remote:localhost/petshop").open("admin", "admin_passwd");

// CREATE A NEW DOCUMENT AND FILL IT
ODocument doc = new ODocument("Person");
doc.field( "name", "Luke" );
doc.field( "surname", "Skywalker" );
doc.field( "city", new ODocument("City")
   .field("name","Rome")
   .field("country", "Italy") );

// SAVE THE DOCUMENT
doc.save();

db.close();
```

Bear in mind, in this example that we haven't declared the `Person` class previously.  When you save this `ODocument` instance, OrientDB creates the `Person` class without constraints.  For more information on declaring persistent classes, see [Schema Management](../Schema.md).

In order to use the Document API, you must include the following jars in your classpath:


- `orientdb-core-*.jar`
- `concurrentlinkedhashmap-lru-*.jar`

Additionally, in the event that you would like to interface with the Document API on a remote server, you also need to include these jars:

- `orientdb-client-*.jar`
- `orientdb-enterprise-*.jar`

>For more information, see
>
>- Javadoc: [JavaDoc](http://www.orientechnologies.com/javadoc/latest/)
>- [OrientDB Studio Web tool](../studio/Studio-Home-page.md).



## Using the Document Database

In order to work with documents in your application, you first need to open a database and create an instance in your code.  For instance, when opening on localhost through the `remote` interface, you might use something like this:

```java
ODatabaseDocumentTx db = new ODatabaseDocumentTx
   ("remote:localhost/petshop")
   .open("admin", "admin_passwd");
```

Once you have the database open, you can create, update and delete documents, as well as query document data to use in your application.

>For more information, see
>
>- [Working with Document Databases](Document-API-Database.md)
>- [Working with Documents](Document-API-Documents.md)


### Creating Documents

You can create documents through the `ODocument` object by setting up the document instance and then calling the `save()` method on that instance.  For instance,

```java
ODocument animal = new ODocument("Animal");
animal.field("name", "Gaudi");
animal.field("location", "Madrid");
animal.save()
```

### Updating Documents

You can update persistent documents through the Java API by modifying the document instance and then calling `save()` on the database.  Alternatively, you can call `save()` on the document instance itself to synchronize the changes to the database.

```java
animal.field( "location", "Nairobi" );
animal.save();
```

When you call `save()`, OrientDB only updates the fields you've changed.

>**NOTE**: This behavior can vary depending on whether you've begun a transaction.  For more information, see [Transactions](../Transactions.md).


For instance, using the code below you can raise the price of animals by 5%:

```java
for (ODocument animal : database.browseClass("Animal")) {
  animal.field("price", animal.field("price") * 1.05);
  animal.save();
}
```


### Deleting Documents

Through the Java API, you can delete documents through the `delete()` method on the loaded document instance. For instance,


```java
animal.delete();
```

>**NOTE**: This behavior can vary depending on whether you've begun a transaction.  For more information, see [Transactions](../Transactions.md).

For instance, using the code below you can delete all documents of the `Animal` class:

```java
for (ODocument animal : database.browseClass("Animal")) {
   animal.delete();
}
```



## Schema

OrientDB is flexible when it comes to schemas.  You can use it,

- **Schema Full**, such as in Relational Databases.
- **Schema Less**, such as with many NoSQL Document Databases.
- **Scheme Hybrid**, which mixes the two.

>For more information, see [Schemas](../Schema.md).

In order to use the schema with documents, create the `ODocument` instance with the constructor `ODocument(String className)`, passing it the class name as an argument.  If you haven't declared the class, OrientDB creates it automatically with no fields.  This won't work during transactions, given it can't apply schema changes in transactional contexts.


## Security

Few NoSQL implementations support security.  OrientDB does.  For more information on its security features, see [Security](../Security.md).

To manage the security from within the Java API, get the Security Manager and use it to operate on users and roles.  For instance,

```java
OSecurity sm = db.getMetadata().getSecurity();
OUser user = sm.createUser(
   "john.smith", "smith_passwd",
   new String[]{"admin"});
```

Once you've have users on the database, you can retrieve information about them through the Java API:


```java
OUser user = db.getUser();
```


## Transactions

Transactions provide you with a practical way to group sets of operations together.  OrientDB supports [ACID](http://en.wikipedia.org/wiki/ACID) transactions, ensuring that either all operations succeed or none of them do.  The database always remains consistent.

>For more information, see [Transactions](../Transactions.md).

OrientDB manages transactions at the database-level.  Currently, it does not support nesting transactions.  A database instance can only have one transaction running at a time. It provides three methods in handling transactions:

- **`begin()`** Starts a new transaction.  If a transaction is currently running, it's rolled back to allow the new one to start.
- **`commit()`**  Ends the transaction, making the changes persistent.  If an error occurs during the commit, the transaction is rolled back and it raises an `OTransactionException` exception.
- **`rollback()`** Ends the transaction and removes all changes.

### Optimistic approach

In its current release, OrientDB uses [Optimistic Transactions](../Transactions.md#optimistic-transactions), in which no lock is kept and all operations are checked on the commit.  This improves concurrency, but can throw an `OConcurrentModificationException` exception in cases where the records are modified by concurrent client threads.  In this scenario, the client code can reload the updated records and repeat the transaction.

When optimistic transactions run, they keep all changes in memory on the client.  If you're using remote storage, it sends no changes to the server until you call the `commit()` method.  All changes transfer in a block to reduce network latency, speed up the execution and increase concurrency.  This differs from most Relational Databases, where changes are sent immediately to the server during transactions.


### Usage

OrientDB commits transactions only when you call the `commit()` method and no errors occur.  The most common use case for transactions is to enclose all database operations within a `try`/`finally` blocks.  When you close the database, (that is, when your application executes the `finally` block), OrientDB automatically rolls back any pending transactions still running.

For instance,

```java
ODatabaseDocumentTx db = new ODatabaseDocumentTx(url);
db.open("admin", "admin_passwd");

db.begin();
try {
  // YOUR CODE
  db.commit();
} finally {
  db.close();
}
```

## Index API

While you can set up and configure [Indices](../Indexes.md) through SQL, the recommended and most efficient way is through the Java API.

The main class to use when working with indices is the [`OIndexManager`](http://www.orientechnologies.com/javadoc/latest/com/orientechnologies/orient/core/index/OIndexManager.html)

```java
OIndexManager idxManager = database.getMetadata().getIndexManager();
```

The Index Manager allows you to manage the index life-cycle for creating, deleting and retrieving index instances.  The most common usage is through a single index.  You can get the index reference:

```java
OIndex<?> idx = database.getMetadata().getIndexManager()
   .getIndex("Profile.name");
```

Here, `Profile.name` is the index name.  By default, OrientDB assigns the name as `<class-name>.<property-name>` for automatic indices created against the class property.

The [`OIndex`](http://www.orientechnologies.com/javadoc/latest/com/orientechnologies/orient/core/index/OIndex.html) interface is similar to a Java Map and provides methods to get, put, remove and count items.

Below are examples of retrieving records using a `UNIQUE` index against aname field and a `NOTUNIQUE` index against the gender field:


```java
OIndex<?> nameIdx = database.getMetadata().getIndexManager()
   .getIndex("Profile.name");

// THIS IS A UNIQUE INDEX, SO IT RETRIEVES A OIdentifiable
OIdentifiable luke = nameIdx.get("Luke");
if( luke != null )
   printRecord((ODocument) luke.getRecord());

OIndex<?> genderIdx = database.getMetadata().getIndexManager()
   .getIndex("Profile.gender");

// THIS IS A NOTUNIQUE INDEX, SO IT RETRIEVES A Set<OIdentifiable>
Set<OIdentifiable> males = genderIdx.get( "male" );
for (OIdentifiable male : males)
   printRecord((ODocument) male.getRecord());
```

OrientDB manages automatic indices using hooks, you can use manual indices to store values.  To create a new entry, use the `put()` method:


```java
OIndex<?> addressbook = database.getMetadata().getIndexManager()
   .getIndex("addressbook");

addressbook.put( "Luke", new ODocument("Contact").field( "name", "Luke" );
```


