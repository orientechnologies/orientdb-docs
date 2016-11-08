---
search:
   keywords: ["tutorial", "relationship", "edge"]
---

<!-- proofread 2015-11-26 SAM -->

# Relationships

One of the most important features of Graph databases lies in how they manage relationships.  Many users come to OrientDB from MongoDB due to OrientDB having more efficient support for relationships.


## Relations in Relational Databases

Most database developers are familiar with the Relational model of databases and with relational database management systems, such as MySQL and MS-SQL.  Given its more than thirty years of dominance, this has long been thought the best way to handle relationships. By contrast, Graph databases suggest a more modern approach to this concept.

Consider, as an example, a database where you need to establish relationships between `Customer` and `Address` tables.

### 1-to-1 Relationship

Relational databases store the value of the target record in the `address` row of the `Customer` table. This is the Foreign Key. The foreign key points to the Primary Key of the related record in the `Address` table.

![RDBMS 1-to-1](http://www.orientdb.org/images/rdbms-1to1.jpg)

Consider a case where you want to view the address of a customer named Luca.  In a Relational database, like MySQL, this is how you would query the table:

<pre>
mysql> <code class="lang-sql userinput">SELECT B.location FROM Customer A, Address B
          WHERE A.name='Luca' AND A.address=B.id;</code>
</pre>

What happens here is a `JOIN`. That is, the contents of two tables are joined to form the results. The database executes the `JOIN` every time you retrieve the relationship.


### 1-to-Many Relationship

Given that it is not possible to store multiple values in one field, a customer record cannot have multiple foreign keys which refers to different addresses. The only way to manage a 1-to-Many Relationship in databases of this kind is to move the Foreign Key to the `Address` table.

![RDBMS 1-to-N](http://www.orientdb.org/images/rdbms-1toN.jpg)

For example, consider a case where you want to return all addresses connected to the customer Luca, this is how you would query the table:

<pre>
mysql> <code class="lang-sql userinput">SELECT B.location FROM Customer A, Address B
          WHERE A.name='Luca' AND B.customer=A.id;</code>
</pre>

### Many-to-Many relationship

The most complicated case is the Many-to-Many relationship.  To handle associations of this kind, Relational databases require a separate, intermediary table that matches rows from both `Customer` and `Address` tables in all required combinations.  This results in a double `JOIN` per record at runtime.

![RDBMS Many-to-Many](http://www.orientdb.org/images/rdbms-NtoM.jpg)

For example, consider a case where you want to return all address for the customer Luca, this is how you would query the table:

<pre>
mysql> <code class="lang-sql userinput">SELECT C.location FROM Customer A, CustomerAddress B, Address C
          WHERE A.name='Luca' AND B.id=A.id AND B.address=C.id;</code>
</pre>


## Understanding `JOIN`

In document and relational database systems, the more data that you have, the slower the database responds and `JOIN` operations have a heavy runtime cost.

For relational database systems, the database computes the relationship every time you query the server. That translates to `O(log N / block_size)`.  OrientDB handles relationships as physical links to the records and assigns them only once, when the edge is created.  That is, `O(1)`.

In OrientDB, the speed of traversal is not affected by the size of the database. It is always constant regardless of whether it has one record or one hundred billion records. This is a critical feature in the age of Big Data.

Searching for an identifier at runtime each time you execute a query, for every record will grow very expensive. The first optimization with relational databases is the use of indexing. Indexes speed up searches, but they slow down [`INSERT`](SQL-Insert.md), [`UPDATE`](SQL-Update.md), and [`DELETE`](SQL-Delete.md) operations. Additionally, they occupy a substantial amount of space on the disk and in memory.

Consider also whether searching an index is actually fast.

### Indexes and `JOIN`

In the database industry, there are a number of indexing algorithms available.  The most common in both relational and NoSQL database systems is the [B+ Tree](http://en.wikipedia.org/wiki/B%2B_tree).

Balance trees all work in a similar manner. For example, consider a case where you're looking for an entry with the name `Luca`: after only five hops, the record is found.

![RDBMS Indexes](http://www.orientdb.org/images/index-lookup.jpg)

While this is fine on a small database, consider what would happen if there were millions or billions of records. The database would have to go through many, many more hops to find `Luca`. And, the database would execute this operation on every `JOIN` per record. Picture: joining four tables with thousands of records. The number of `JOIN` operations could run in the millions.

## Relations in OrientDB

There is no `JOIN` in OrientDB. Instead, it uses `LINK`. `LINK` is a relationship managed by storing the target [Record ID](Tutorial-Record-ID.md) in the source record. It is similar to storing the pointer between two objects in memory.

When you have `Invoice` linked to `Customer`, then you have a pointer to `Customer` inside `Invoice` as an attribute. They are exactly the same. In this way, it's as though your database was kept in memory: a memory of several exabytes.

### Types of Relationships

In 1-to-N relationships, OrientDB handles the relationship as a collection of Record ID's, as you would when managing objects in memory.

OrientDB supports several different kinds of relationships:

- `LINK` Relationship that points to one record only.
- `LINKSET` Relationship that points to several records.  It is similar to Java sets, the same Record ID can only be included once.  The pointers have no order.
- `LINKLIST` Relationship that points to several records.  It is similar to Java lists, they are ordered and can contain duplicates.
- `LINKMAP` Relationship that points to several records with a key stored in the source record.  The Map values are the Record ID's.  It is similar to Java `Map<?,Record>`.
