# Indexes

OrientDB supports 4 kinds of indexes:

|Index type|Durable|Transactional|Range queries|Best features|Description|
|----------|-------|-------------|-------------|-------------|--------------|
|[SB-Tree](SB-Tree-index.md)|**YES**|**YES**|**YES**|Good mix of all|the default one is durable and transactional|
|[Hash](Hash-Index.md)|**YES**|**YES**|no|Super fast lookup, very light on disk|Works like a HashMap so it's faster on punctual lookup (select from xxx where salary = 1000)  and consumes less resources, but you cannot use it for range queries (select from xxx where salary between 1000 and 2000)|
|[Lucene](https://github.com/orientechnologies/orientdb-lucene)|**YES**|**YES**|**YES**|Good on full-text and spatial indexes|Lucene indexes can be used only for full-text and spatial|

## What's an index?

Indexes can be handled like classes (or tables for RDBMS users) using the SQL language and prefixing with "index:" the index name. The index is like a class (or table) with 2 properties:

- `key`, as the index's key
- `rid`, as the [RecordId](Concepts.md#recordid) that points to the record associated with the key

## Index target

Indexes can be updated:

- **Automatically** when are bound to schema properties, example "User.id". If you have a schema-less database and you want to create an automatic index, then you need to create the class and the property before using indexing.

- **Manually**, handled by the developer using Java API and SQL commands (see below). You can use them as Persistent Maps where they entry's value are the records pointed by index.

Automatic indexes can be rebuilt by using [SQL Rebuild Index](SQL-Rebuild-Index.md) command.

## Index types

The index type cannot be changed once created. The supported index types are the following:

- **SB-Tree** algorithm:
 - `UNIQUE`, doesn't allow duplicates. For composite index means uniqueness of composite keys.
 - `NOTUNIQUE`, allows duplicates
 - `FULLTEXT`, by indexing any single word of the text. It's used in query with the operator `CONTAINSTEXT`
 - `DICTIONARY`, like `UNIQUE` but in case the key already exists replace the record with the new one
- **HashIndex** algorithm:
 - `UNIQUE_HASH_INDEX`, doesn't allow duplicates. For composite index means uniqueness of composite keys.
 - `NOTUNIQUE_HASH_INDEX`, allows duplicates
 - `FULLTEXT_HASH_INDEX`, by indexing any single word of the text. It's used in query with the operator `CONTAINSTEXT`
 - `DICTIONARY_HASH_INDEX`, like `UNIQUE` but in case the key already exists replace the record with the new one
- **Lucene** engine:
 - [FULLTEXT](Full-Text-Index.md), it uses Lucene to index the string content. Use the `LUCENE` operator to retrieve it.
 - [SPATIAL](Spatial-Index.md), it uses Lucene to index the geo spatial coordinates.

- Any 3rd party index plugged

### Dictionary

Every single database has a default manual index of type `DICTIONARY` called `dictionary` with Strings as keys. This is very useful to:

- handle root records of trees and graphs
- handle singleton records used for configuration

## Operations against indexes
### Create an index

Creates a new index. To create an automatic index bound to a schema property use section "ON" of create index command or use as name the `<class.property>` notation. But assure to have created the schema for it before the index. See the example below.

Syntax:

```sql
CREATE INDEX <name> [ON <class-name> (prop-names)] <type> [<key-type>]
                    [METADATA {<metadata>}]
```
Where:

- `<name>` logical name of index. Can be `<class>.<property>` to create an automatic index bound to a schema property. In this case `<class>` is the class of the schema and `<property>`, is the property created into the class. Notice that in another case index name can't contain '`.`' symbol
- `<class-name>` name of class that automatic index created for. Class with such name must already exist in database
- `<prop-names>` comma-separated list of properties for which automatic index is created for. Property with such name must already exist in schema. If property belongs to one of the Map types (`LINKMAP`, `EMBEDDEDMAP`) you can specify the keys or values used for index generation. Use `BY KEY` or `BY VALUE` expressions for that, if nothing will be specified keys will be used during index creation.
- `<type>`, can be any index among the supported ones:
 - `unique`, uses the SB-Tree algorithm. Supports range queries.
 - `notunique`, uses the SB-Tree algorithm. Supports range queries.
 - `fulltext`, uses the SB-Tree algorithm. Supports range queries.
 - `dictionary`, uses the SB-Tree algorithm. Supports range queries.
 - `unique_hash_index`, uses the Hash algorithm. Doesn't supports range queries. Available since 1.5.x.
 - `notunique_hash_index`, uses the Hash algorithm. Doesn't supports range queries. Available since 1.5.x.
 - `fulltext_hash_index`, uses the Hash algorithm. Doesn't supports range queries. Available since 1.5.x.
 - `dictionary_hash_index`, uses the Hash algorithm. Doesn't supports range queries. Available since 1.5.x.
- `<key-type>`, is the type of key (Optional). On automatic indexes is auto-determined by reading the target schema property where the index is created. If not specified for manual indexes, at run-time during the first insertion the type will be auto determined by reading the type of the class.
- `<metadata>` is a JSON representing all the additional metadata as key/value

Examples of custom index:

```sql
CREATE INDEX mostRecentRecords UNIQUE date
```

Examples of automatic index bound to the property `id` of class `User`:

```sql
CREATE PROPERTY User.id BINARY
CREATE INDEX User.id UNIQUE
```

Another index for `id` property of class `User`:

```sql
CREATE INDEX indexForId ON User (id) UNIQUE
```

Examples of index for `thumbs` property of class `Movie`.

```sql
CREATE INDEX thumbsAuthor ON Movie (thumbs) Unique
CREATE INDEX thumbsAuthor ON Movie (thumbs BY KEY) UNIQUE
CREATE INDEX thumbsValue ON Movie (thumbs BY VALUE) UNIQUE
```

Example of composite index

```sql
CREATE PROPERTY Book.author STRING
CREATE PROPERTY Book.title STRING
CREATE PROPERTY Book.publicationYears EMBEDDEDLIST INTEGER
CREATE INDEX books ON Book (author, title, publicationYears) UNIQUE
```

For more information look at [CREATE INDEX](SQL-Create-Index.md).

### Drop an index

Drop an index. Linked records will be not removed.
Syntax:

```sql
DROP INDEX <name>
```

Where:
- `<name>` of the index to drop

For more information look at [DROP INDEX](SQL-Drop-Index.md).

### Lookup

Returns all the records with the requested `key`.

```sql
SELECT FROM INDEX:<index-name> WHERE key = <key>
```
Example:

```sql
SELECT FROM INDEX:dictionary WHERE key = 'Luke'
```

#### Case insensitive match

To set a case-insensitive match in index, set the `COLLATE` attribute of indexed properties to `ci` (stands for Case Insensitive). Example:


```sql
CREATE INDEX OUser.name ON OUser (name COLLATE ci) UNIQUE
```

### Put an entry

Inserts a new entry in the index with `key` and `rid`.

```sql
INSERT INTO INDEX:<index-name> (key,rid) VALUES (<key>,<rid>)
```

Example:

```sql
INSERT INTO INDEX:dictionary (key,rid) VALUES ('Luke',#10:4)
```

### Query range

Retrieves the key ranges between `<min>` and `<max>`.

```sql
SELECT FROM INDEX:<index-name> WHERE key BETWEEN <min> AND <max>
```

Example:

```sql
SELECT FROM INDEX:coordinates WHERE key BETWEEN 10.3 AND 10.7
```

### Remove entries by key

Deletes all the entries with the requested `key`.

```sql
DELETE FROM INDEX:<index-name> WHERE key = <key>
```
Example:

```sql
DELETE FROM INDEX:addressbook WHERE key = 'Luke'
```
### Remove an entry

Deletes an entry by passing `key` and `rid`. Returns true if removed, otherwise false if the entry wasn't found.

```sql
DELETE FROM INDEX:<index-name> WHERE key = <key> AND rid = <rid>
```
Example:

```sql
DELETE FROM INDEX:dictionary WHERE key = 'Luke' AND rid = #10:4
```

### Remove all references to a record

Removes all the entries with the `rid` passed.

```sql
DELETE FROM INDEX:<index-name> WHERE rid = <rid>
```
Example:

```sql
DELETE FROM INDEX:dictionary WHERE rid = #10:4
```

### Count all the entries

Returns the number of entries on that index.

```sql
SELECT COUNT(*) AS size FROM INDEX:<index-name>
```

Example:

```sql
SELECT COUNT(*) AS size FROM INDEX:dictionary
```
### Retrieve all the keys

Retrieves all the keys of the index.

```sql
SELECT key FROM INDEX:<index-name>
```
Example:
```sql
SELECT key FROM INDEX:dictionary
```
### Retrieve all the entries

Retrieves all the entries of the index as pairs `key` and `rid`.

```sql
SELECT key, value FROM INDEX:<index-name>
```
Example:

```sql
SELECT key, value FROM INDEX:dictionary
```

### Clear the index

Removes all the entries. The index will be empty after this call.
This removes all the entries of an index.

```sql
DELETE FROM INDEX:<index-name>
```
Example:

```sql
DELETE FROM INDEX:dictionary
```

## Null values

Indexes by default don't support null values. Queries against `NULL` value that use indexes fail with "Null keys are not supported." exception.

If you want to index also null values set `{ ignoreNullValues : false }` as metadata. Example:

```sql
CREATE INDEX addresses ON Employee (address) notunique
             METADATA {ignoreNullValues : false}
```

## Composite keys

You can do the same operations with composite indexes.

A composite key is a collection of values by its nature, so syntactically it is defined as a collection.
For example, if we have class book, indexed by its three fields:
- `author`,
- `title` and
- `publication year`

We can use following query to look up a book:

```sql
SELECT FROM INDEX:books WHERE key = ["Donald Knuth", "The Art of Computer Programming", 1968]
```
Or to look up a book within a `publication year` range:

```sql
SELECT FROM INDEX:books WHERE key BETWEEN ["Donald Knuth", "The Art of Computer Programming", 1960] AND ["Donald Knuth", "The Art of Computer Programming", 2000]
```

### Partial match search

This is a mechanism that allows searching index record by several first fields of its composite key. In this case the remaining fields with undefined value can match any value in result.

Composite indexes are used for partial match search only when the declared fields in composite index are used from left to right. Using the example above, if you search only for `title`, the composite index cannot be used, but it will be used if you search for `author` + `title`.

For example, if we don't care when books have been published, we can throw away the `publication year` field from the query. So, the result of the following query will be all books with this `author` and `title` and any `publication year`
```sql
SELECT FROM INDEX:books WHERE key = ["Author", "The Art of Computer Programming"]
```
If we also don't know `title`, we can keep only `author` field in query. Result of following query will be all books of this `author`.

```sql
SELECT FROM INDEX:books WHERE key = ["Donald Knuth"]
```

Or equivalent

```sql
SELECT FROM INDEX:books WHERE key = "Donald Knuth"
```

### Range Queries
In case of range queries, the field subject to the range must be the last one. Example:

```sql
SELECT FROM INDEX:books
  WHERE key BETWEEN ["Donald Knuth", "The Art of Computer Programming", 1900] 
    AND ["Donald Knuth", "The Art of Computer Programming", 2014]
```

### Direct insertion for composite indexes

Unsupported yet.

## Custom keys

OrientDB since release 1.0 supports custom keys for indexes. This could give a huge improvement if you want to minimize memory used using your own serializer.

Below an example to handle SHA-256 data as binary keys without using a STRING to represent it saving disk space, cpu and memory.

### Create your own type

```java
public static class ComparableBinary implements Comparable<ComparableBinary> {
  private byte[]	value;

  public ComparableBinary(byte[] buffer) {
    value = buffer;
  }

  public int compareTo(ComparableBinary o) {
    final int size = value.length;
    for (int i = 0; i < size; ++i) {
      if (value[i] > o.value[i])
	return 1;
      else if (value[i] < o.value[i])
        return -1;
    }
    return 0;
  }

  public byte[] toByteArray() {
    return value;
  }
}
```

### Create your own binary serializer

```java
public static class OHash256Serializer implements OBinarySerializer<ComparableBinary> {

  public static final OBinaryTypeSerializer INSTANCE = new OBinaryTypeSerializer();
  public static final byte ID = 100;
  public static final int LENGTH = 32;

  public int getObjectSize(final int length) {
    return length;
  }

  public int getObjectSize(final ComparableBinary object) {
    return object.toByteArray().length;
  }

  public void serialize(final ComparableBinary object, final byte[] stream, final int startPosition) {
    final byte[] buffer = object.toByteArray();
    System.arraycopy(buffer, 0, stream, startPosition, buffer.length);
  }

  public ComparableBinary deserialize(final byte[] stream, final int startPosition) {
    final byte[] buffer = Arrays.copyOfRange(stream, startPosition, startPosition + LENGTH);
    return new ComparableBinary(buffer);
  }

  public int getObjectSize(byte[] stream, int startPosition) {
    return LENGTH;
  }

  public byte getId() {
    return ID;
  }
}
```

#### Register your serializer

```java
OBinarySerializerFactory.INSTANCE.registerSerializer(new OHash256Serializer(), null);
index = database.getMetadata().getIndexManager().createIndex("custom-hash", "UNIQUE", new ORuntimeKeyIndexDefinition(OHash256Serializer.ID), null, null);
```

#### Usage

```java
ComparableBinary key1 = new ComparableBinary(new byte[] { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1 });
ODocument doc1 = new ODocument().field("k", "key1");
index.put(key1, doc1);
```
## Query the available indexes

To access to the indexes, you can use [SQL](SQL.md#query-the-available-indexes).

## Create your index engine

Here you can find a guide how to create a [custom index engine](Custom-Index-Engine.md).
