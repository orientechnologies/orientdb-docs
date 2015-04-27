# Relationships

The most important feature of a **graph** database is the management of **relationships**. Many users come to OrientDB from [MongoDB](http://www.mongodb.org) or other document databases because they lack efficient support of relationships.

## Relational Model

The relational model (and RDBMS - relational database management systems) has long been thought to be the best way to handle relationships. Graph databases suggest a more modern approach to this topic.

Most database developers are familiar with the relational model given it's 30+ years of dominance, spreading over generations of developers. Let's review how these systems manage relationships. As an example, we will use the relationships between the Customer and Address tables.

### 1-to-1 relationship

RDBMSs store the value of the target record in the "address" column of the Customer table. This is called a **foreign key**. The foreign key points to the **primary key** of the related record in the Address table:

![RDBMS 1-to-1](http://www.orientdb.org/images/rdbms-1to1.jpg)

To retrieve the address pointed to by customer "Luca", the query in a RDBMS would be:

```sql
SELECT B.location FROM Customer A, Address B WHERE A.name = 'Luca' AND A.address = B.id
```

This is a **`JOIN`**! A `JOIN` is executed at run-time every time you retrieve a relationship.

### 1-to-Many relationship

Since RDBMS have no concept of collections the Customer table cannot have multiple foreign keys. The way to manage a 1-to-Many relationship is by moving the foreign key to the Address table.

![RDBMS 1-to-N](http://www.orientdb.org/images/rdbms-1toN.jpg)

To extract all addresses of Customer 'Luca', the query in RDBMS reads:
```sql
SELECT B.location FROM Customer A, Address B WHERE A.name = 'Luca' AND B.customer = A.id
```

### Many-to-Many relationship

The most complex case is the Many-to-Many relationship. To handle this type of association, RDBMSs need a separate, intermediary table that matches both Customer and Addresses in all required combinations. This results in a **double `JOIN`** per record at runtime;

![RDBMS Many-to-Many](http://www.orientdb.org/images/rdbms-NtoM.jpg)

To extract all addresses of Customer 'Luca's the query in RDBMS becomes:

```sql
SELECT B.location FROM Customer A, Address B, CustomerAddress C WHERE A.name = 'Luca' AND B.id = A.id AND B.address = C.id
```


### The problem with `JOIN`

With document and relational DBMS, the more data you have, the slower the database will perform. Joins have heavy runtime costs. In comparison, OrientDB handles relationships as physical links to the records, assigned only once when the edge is created O(1). Compare this to an RDBMS that “computes“ the relationship every single time you query a database O(LogN). With OrientDB, speed of traversal is not affected by the database size. It is always constant regardless if it has one record or 100 billion records. This is critical in the age of Big Data.

Searching for an ID at runtime each time you execute a query, for every record could be very expensive! The first optimization with RDMS is using indexes. Indexes speed up searches but they slow down `INSERT`, `UPDATE` and `DELETE` operations.  In addition, they occupy substantial space on disk and in memory. You also need to qualify - are you sure the lookup into an index is actually fast? Let's try to understand how indexes work.

### Do indexes solve the problem with `JOIN`?

The database industry has plenty of indexing algorithms. The most common in both Relational and NoSQL DBMS is the [B+Tree](http://en.wikipedia.org/wiki/B%2B_tree). All balanced trees work in similar ways. Here is and example of how it would work when you're looking for "Luca": after only 5 hops the record is found.

![RDBMS Indexes](http://www.orientdb.org/images/index-lookup.jpg)

But what if there were millions or billions of records? There would be many, many more hops. And this operation is executed on every JOIN per record! Imagine joining 4 tables with thousands of records: the number of JOINS could be in the millions!

## Relations in OrientDB

OrientDB doesn't use JOINs. Instead it uses LINKs. A LINK is a relationship managed by storing the target [RID](Tutorial-Record-ID.md) in the source record. It's much like storing a pointer between 2 objects in memory. When you have Invoice -> Customer, then you have a pointer to Customer inside Invoice as an attribute. It's exactly the same. In this way it's like your database was in memory, a memory of several exabytes.

What about 1-to-N relationships? These relationships are handled as a collection of [RIDs](Tutorial-Record-ID.md), like you would manage objects in memory. OrientDB supports different kinds of relationships:
- **`LINK`**, to point to one record only
- **`LINKSET`**, to point to several records. Like Java Sets, the same RID can only be included once. The pointers also have no order
- **`LINKLIST`**, to point to several records. Like Java Lists, they are ordered and can contain duplicates
- **`LINKMAP`**, to point to several records with a key stored in the source record. The Map values are the RIDs. Works like the Java `Map<?,Record>`.
