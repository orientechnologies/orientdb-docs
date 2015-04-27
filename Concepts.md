# Basic Concepts

- [Record](Concepts.md#record)
  - [RecordID](Concepts.md#recordid)
  - [Record version](Concepts.md#record-version)
- [Class](Concepts.md#class)
  - [Abstract Class](Concepts.md#abstract-class)
  - [When to use class or cluster in queries?](Concepts.md#when-to-use-class-or-cluster-in-queries)
- [Relationships](Concepts.md#relationships)
  - [Referenced relationships](Concepts.md#referenced-relationships)
      - [1-1 and N-1 referenced relationships](Concepts.md#1-1-and-n-1-referenced-relationships)
      - [1-N and N-M referenced relationships](Concepts.md#1-n-and-n-m-referenced-relationships)
  - [Embedded relationships](Concepts.md#embedded-relationships)
      - [1-1 and N-1 embedded relationships](Concepts.md#1-1-and-n-1-embedded-relationships)
      - [1-N and N-M embedded relationships](Concepts.md#1-n-and-n-m-embedded-relationships)
  - [Inverse Relationships](Concepts.md#inverse-relationships)
- [Database](Concepts.md#database)
  - [Database URL](Concepts.md#database-url)
  - [Database Usage](Concepts.md#database-usage)


## Record

A record is the smallest unit that can be loaded from and stored into the database.

### Document

Documents are the most flexible record type available in OrientDB. They are softly typed and are defined by schema classes with defined constraints but can also be used in schema-less mode. Documents handle fields in a flexible way. A Document can easily be imported and exported in JSON format. Below is an example of a Document in JSON:

```json
{
  "name": "Jay",
  "surname": "Miner",
  "job": "Developer",
  "creations": [
    { "name": "Amiga 1000",
      "company": "Commodore Inc."
    },
    { "name": "Amiga 500",
      "company": "Commodore Inc."
    }
  ]
}
```
OrientDB Documents support complex [relationships](Concepts.md#relationships). From a programmer's perspective this can be seen as a sort of persistent Map<String,Object>.

### RecordID

In OrientDB, each record has an auto assigned Unique ID. The RecordID (or RID) is composed in this way:

```
#[<cluster>:<position>]
```

Where:

- `<cluster>` is the cluster id. Positive numbers indicate persistent records. Negative numbers indicate temporary records, like those used in result sets for queries that use projections.

- `<position>` is the absolute position of the record inside a cluster.

> **NOTE**: The prefix character `#` is mandatory to recognize a RecordID.

The record never loses its identity unless it is deleted. Once deleted its identity is never recycled (but with "local" storage). You can access a record directly by its RecordID. For this reason you don't need to create a field as a primary key like in a Relational DBMS.

### Record version

Each record maintains its own version number that is incremented at every update. In optimistic transactions the version is checked in order to avoid conflicts at commit time.

## Class

A Class is a concept taken from the [Object Oriented paradigm](http://en.wikipedia.org/wiki/Object-oriented_programming). In OrientDB it defines a type of record. It's the closest concept to a Relational DBMS Table. Classes can be schema-less, schema-full, or mixed.

A class can inherit from another, creating a tree of classes. [Inheritance](http://en.wikipedia.org/wiki/Inheritance_%28object-oriented_programming%29) means that a sub-class extends a parent class, inheriting all its attributes.

Each class has its own [clusters](Concepts.md#cluster). A class must have at least one cluster defined (its default cluster), but can support multiple ones. When you execute a query against a class, it's automatically propagated to all the clusters that are part of the class. When a new record is created, the cluster that is selected to store it is picked by using a [configurable strategy](Cluster-Selection.md). 

When you create a new class by default a new [persistent cluster](Concepts.md#physical_cluster) is created with the same name of the class in lowercase.

### Abstract Class

If you know Object-Orientation you already know what an abstract class is. For all the rest:
- [Abstract Type](http://en.wikipedia.org/wiki/Abstract_type)
- [Abstract Methods and Classes](http://docs.oracle.com/javase/tutorial/java/IandI/abstract.html)
For our purpose, we can sum up an abstract class as:
- A class used as a foundation for defining other classes (eventually, concrete classes)
- A class that can't have instances

To create a new abstract class look at [CREATE CLASS](SQL-Create-Class.md#abstract-class).

Abstract classes are essential to support Object Orientation without the typical spamming of the database with always empty auto-created clusters.

> **NOTE**: Feature available since 1.2.0.

### When do you use a class or a cluster in queries?

Let's use an example: Let's assume you created a class "Invoice" and two clusters "invoice2011" and "invoice2012".

You can now query all the invoices by using the class as a target in the SQL select:

```sql
SELECT FROM Invoice
```

If you want to filter per year (2012) and you've created a "year" field in the Invoice class do this:

```sql
SELECT FROM Invoice where year = 2012
```

You may also query specific objects from a single cluster (so, by splitting the Class Invoice in multiple clusters, e.g. one per year, you narrow your candidate objects):

```sql
SELECT FROM cluster:invoice2012
```

This query may be significantly faster because OrientDB can narrow the search to the targeted cluster.

The combination of Classes and Clusters is very powerful and has many use cases.

## Relationships

OrientDB supports two kinds of relationships: *referenced* and *embedded*. OrientDB can manage relationships in a schema-full or in schema-less scenario.

### Referenced relationships

Relationships in OrientDB are managed natively without computing costly JOINs, as in a Relational DBMS. In fact, OrientDB stores direct link(s) to the target objects of the relationship. This boosts up the load speed of the entire graph of connected objects like in Graph and Object DBMSs.

For example:

```
                  customer
  Record A     ------------->    Record B
CLASS=Invoice                 CLASS=Customer
  RID=5:23                       RID=10:2
```

<b>Record A</b> will contain the *reference* to **Record B** in the property called "customer". Note that both records are reachable by other records since they have a [RecordID](Concepts.md#recordid).

#### 1-1 and N-1 referenced relationships

These kinds of relationships are expressed using the **LINK** type.

#### 1-N and N-M referenced relationships

These kinds of relationships are expressed using the collection of links such as:

- **LINKLIST**, as an ordered list of links.
- **LINKSET**, as an unordered set of links. It doesn't accepts duplicates.
- **LINKMAP**, as an ordered map of links with **String** as the key type. A keys doesn't accept duplicates.

### Embedded relationships

Embedded records, instead, are contained inside the record that embeds them. It's a kind of relationship that's stronger than the reference. It can be represented like the [UML Composition relationship](http://en.wikipedia.org/wiki/Class_diagram#Composition). The embedded record will not have its own [RecordID](Concepts.md#recordid), since it can't be directly referenced by other records. It's only accessible through the container record. If the container record is deleted, then the embedded record will be deleted too. Example:

```
                   address
  Record A     <>---------->   Record B
CLASS=Account               CLASS=Address
  RID=5:23                     NO RID!
```

**Record A** will contain the entire **Record B** in the property called "address". **Record B** can be reached only by traversing the container record.

Example:

```sql
SELECT FROM account WHERE address.city = 'Rome'
```

#### 1-1 and N-1 embedded relationships

These kinds of relationships are expressed using the **EMBEDDED** type.

#### 1-N and N-M embedded relationships

These kinds of relationships are expressed using a collection of links such as:

- **EMBEDDEDLIST**, as an ordered list of records.
- **EMBEDDEDSET**, as an unordered set of records. It doesn't accept duplicates.
- **EMBEDDEDMAP**, as an ordered map of records as the value and a **String** as the key. It doesn't accept duplicate keys.

### Inverse relationships

In OrientDB, all Graph Model edges (connections between vertices) are bi-directional. This differs from the Document Model where relationships are always mono-directional, thus requiring the developer to maintain data integrity. In addition, OrientDB automatically maintains the consistency of all bi-directional relationships (aka edges).

## Database

A database is an interface to access the real [Storage](Concepts.md#storage). The database understands high-level concepts like Queries, Schemas, Metadata, Indices, etc. OrientDB also provides multiple database types. Take a look at the [Database types](Java-API.md#database-types) to learn more about them.

Each server or JVM can handle multiple database instances, but the database name must be UNIQUE. So you can't manage two databases named "customer" in two different directories at the same time. To handle this case use the `$` (dollar) as a separator instead of `/` (slash). OrientDB will bind the entire name, so it will be unique, but at the file system level it will convert `$` with `/` allowing multiple databases with the same name in different paths. Example:

```
test$customers -> test/customers
production$customers = production/customers
```

The database must be opened as:

```sql
test = new ODatabaseDocumentTx("remote:localhost/test$customers");
production = new ODatabaseDocumentTx("remote:localhost/production$customers");
```

### Database URL

OrientDB has its own [URL](http://en.wikipedia.org/wiki/Uniform_Resource_Locator) format:

```
<engine>:<db-name>
```

Where:
- `<db-name>` is the database name and depends on the engine used (see below)
- `<engine>` can be:

|Engine|Description|Example|
|------|-----------|-------|
|[plocal](Paginated-Local-Storage.md)|This engine writes to the file system to store data. There is a LOG of changes to restore the storage in case of a crash.|`plocal:/temp/databases/petshop/petshop`|
|[memory](Memory-storage.md)|Open a database completely in memory|`memory:petshop`|
|remote|The storage will be opened via a remote network connection. It requires an OrientDB Server up and running. In this mode, the database is shared among multiple clients. Syntax: `remote:<server>:[<port>]/db-name`. The port is optional and defaults to 2424.|`remote:localhost/petshop`|

### Database usage

The database must always be closed once you've finished working with it.

> **NOTE**: OrientDB automatically closes all opened databases when the process dies gracefully (not by killing it by force). This is assured if the Operating System allows a graceful shutdown.
