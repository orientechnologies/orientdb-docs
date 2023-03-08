
# Document API

> In case of embedded GroupId: **com.orientechnologies**  ArtifactId: **orientdb-core**

> In case of remote GroupId: **com.orientechnologies**  ArtifactId: **orientdb-client**

The Document Database in OrientDB is the foundation of higher level implementations, like the [Object Database](Object-Database.md) and the [Tinkerpop Graph](Graph-Database-Tinkerpop.md).  The Document API supports:

- [Multi-thread Access](Java-Multi-Threading.md)
- [Transactions](../internals/Transactions.md)
- [Queries](Document-API-Documents.md#retrieving-documents)
- [Traverse](Document-API-Documents.md#traversing-documents)


```java
// OPEN THE DATABASE
OrientDB orientDB = new OrientDB("remote:localhost");
ODatabaseDocument db = orientDB.open("petshop","admin", "admin_passwd");

// CREATE A NEW DOCUMENT AND FILL IT
ODocument doc = new ODocument("Person");
doc.field( "name", "Luke" );
doc.field( "surname", "Skywalker" );
doc.field( "city", new ODocument("City")
   .field("name","Rome")
   .field("country", "Italy") );

// SAVE THE DOCUMENT
db.save(doc);

db.close();
orientDB.close();
```

>For more information, see
>
>- Javadoc: [JavaDoc](http://www.orientechnologies.com/javadoc/latest/)
>- [OrientDB Studio Web tool](../studio/README.md).



## Using the Document Database

In order to work with documents in your application, you first need to open a database and create an instance in your code.  For instance, when opening on localhost through the `remote` interface, you might use something like this:

```java
OrientDB orientDB = new OrientDB("remote:localhost");
ODatabaseDocument db = orientDB.open("petshop","admin", "admin_passwd");
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

>**NOTE**: This behavior can vary depending on whether you've begun a transaction.  For more information, see [Transactions](../internals/Transactions.md).


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

>**NOTE**: This behavior can vary depending on whether you've begun a transaction.  For more information, see [Transactions](../internals/Transactions.md).

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

>For more information, see [Schemas](../general/Schema.md).

In order to use the schema with documents, create the `ODocument` instance with the constructor `ODocument(String className)`, passing it the class name as an argument.  If you haven't declared the class, OrientDB creates it automatically with no fields.  This won't work during transactions, given it can't apply schema changes in transactional contexts.


## Security

Few NoSQL implementations support security.  OrientDB does.  For more information on its security features, see [Security](../security/Security.md).

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

>For more information, see [Transactions](../internals/Transactions.md).

OrientDB manages transactions at the database-level.  Currently, it does not support nesting transactions.  A database instance can only have one transaction running at a time. It provides three methods in handling transactions:

- **`begin()`** Starts a new transaction.  If a transaction is currently running, it's rolled back to allow the new one to start.
- **`commit()`**  Ends the transaction, making the changes persistent.  If an error occurs during the commit, the transaction is rolled back and it raises an `OTransactionException` exception.
- **`rollback()`** Ends the transaction and removes all changes.

### Optimistic approach

In its current release, OrientDB uses [Optimistic Transactions](../internals/Transactions.md#optimistic-transaction), in which no lock is kept and all operations are checked on the commit.  This improves concurrency, but can throw an `OConcurrentModificationException` exception in cases where the records are modified by concurrent client threads.  In this scenario, the client code can reload the updated records and repeat the transaction.

When optimistic transactions run, all changes are kept in memory.  If you're using remote storage, the changes are sent to the server only when you executed a query or you call the `commit()` method.  All changes transfer in a block to reduce network latency, speed up the execution and increase concurrency.  This differs from most Relational Databases, where changes are sent immediately to the server during transactions.


### Usage

OrientDB commits transactions only when you call the `commit()` method and no errors occur.  The most common use case for transactions is to enclose all database operations within a `try`/`finally` blocks.  When you close the database, (that is, when your application executes the `finally` block), OrientDB automatically rolls back any pending transactions still running.

For instance,

```java
OrientDB orientDB = new OrientDB("remote:localhost");

try (ODatabaseDocument db = orientDB.open("petshop","admin", "admin_passwd")) {
  db.begin();
  // YOUR CODE
  db.commit();
}

orientDB.close();
```

## Index API

> See also [SQL Indices](../indexing/Indexes.md).

You can declare an index on a property or a group of properties this will make orient automatically index the documents of the specific class with the specific properties and automatically use the index in the queries, the way to declare this indexes is through the [`OClass`](ref/OClass.md) and [`OProperty`](ref/OProperty.md) API.

Index on a single property, For instance,
```
OClass animalClass = database.getClass("Animal");
OProperty nameProp = animalClass.getProperty("name");
nameProp.createIndex(OClass.INDEX_TYPE.NOTUNIQUE);
```
This example will use as index name `<class-name>.<property-name>`

Index on multiple properies, For Instance,

```
OClass animalClass = database.getClass("Animal");
animalClass.createIndex("index_name", OClass.INDEX_TYPE.NOTUNIQUE, "name","location");
```


