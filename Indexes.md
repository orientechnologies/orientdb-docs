# Indexes

OrientDB supports four index algorithms:

- [**SB-Tree Index**](SB-Tree-index.md) Provides a good mix of features available from other index types, good for general use.  It is durable, transactional and supports range queries.  It is the default index type.
- [**Hash Index**](Hash-Index.md) Provides fast lookup and is very light on disk usage.  It is durable and transactional, but does not support range queries.  It works like a HashMap, which makes it faster on punctual lookups and it consumes less resources than other index types.
- [**Lucene Full Text Index**](Full-Text-Index.md) Provides good full-text indexes, but cannot be used to index other types.  It is durable, transactional and supports range queries.
- [**Lucene Spatial Index**](Spatial-Index.md) Provides good spatial indexes, but cannot be used to index other types.  It is durable, transactional and supports range queries.


## Understanding Indexes

OrientDB can handle indexes in the same manner as classes, using the SQL language and prefixing the name with `index:` followed by the index name.  An index is like a class with two properties:

- `key` The index key.
- `rid` The [Record ID](Concepts.md#recordid), which points to the record associated with the key.

### Index Target

OrientDB can use two methods to update indexes:

- **Automatic** Where the index is bound to schema properties.  (For example, `User.id`.)  If you have a schema-less database and you want to create an automatic index, then you need to create the class and the property before using the index.

- **Manual** Where the index is handled by the application developer, using the Java API and SQL commands (see below).  You can use them as Persistent Maps, where the entry's value are the records pointed to by the index.

You can rebuild automatic indexes using the [`REBUILD INDEX`](SQL-Rebuild-Index.md) command.

### Index Types

When you create an index, you create it as one of several available algorithm types.  Once you create an index, you cannot change its type.  OrientDB supports four index algorithms and several types within each.  You also have the option of using any third-party index algorithms available
through plugins.

- **SB-Tree Algorithm** 
  - `UNIQUE` These indexes do not allow duplicate keys.  For composite indexes, this refers to the uniqueness of the composite keys.
  - `NOTUNIQUE` These indexes allow duplicate keys.
  - `FULLTEXT` These indexes are based on any single word of text.  You can use them in queries through the `CONTAINSTEXT` operator.
  - `DICTIONARY` These indexes are similar to those that use `UNIQUE`, but in the case of duplicate keys, they replaces the existing record with the new record.
- **HashIndex Algorithm**
  - `UNIQUE_HASH_INDEX` These indexes do not allow duplicate keys.  For composite indexes, this refers to the uniqueness of the composite keys.  Available since version 1.5.x.
  - `NOTUNIQUE_HASH_INDEX` These indexes allow duplicate keys.  Available since version 1.5.x.
  - `FULLTEXT_HASH_INDEX` These indexes are based on any single word of text.  You can use them in queries through the `CONTAINSTEXT` operator.  Available since version 1.5.x.
  - `DICTIONARY_HASH_INDEX` These indexes are similar to those that use `UNIQUE_HASH_INDEX`, but in cases of duplicate keys, they replaces the existing record with the new record.  Available since version 1.5.x.
- **Lucene Engine**
  - `FULLTEXT` These indexes use the Lucene engine to index string content.  You can use them in queries with the `LUCENE` operator.
  - `SPATIAL` These indexes use the Lucene engine to index geospatial coordinates.

Every database has a default manual index type `DICTIONARY`, which uses strings as keys.  You may find this useful in handling the root records of trees and graphs, and handling singleton records in configurations.


### Indexes and Null Values

By default, indexes do not support null values.  Queries made against `NULL` values that use indexes fail with the `Null keys are not supported` exception.

In the event that you want to index null values, you must set `{ignoreNullValues: false}` in the metadata.  For instance,

<pre>
orientdb> <code class='lang-sql userinput'>CREATE INDEX addresses ON Employee (address) NOTUNIQUE METADATA {ignoreNullValues: false}</code>
</pre>


### Indexes and Composite Keys

Operations that work with indexes also work with indexes formed from composite keys.  By its nature, a composite key is  acollection of values, so, syntactically, it is a collection.

For example, consider a case where you have a class `Book`, indexed by three fields: `author`, `title` and `publicationYear`.  You might use the following query to look up an individual book:

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM INDEX:books WHERE key = ["Donald Knuth", "The Art of Computer
          Programming", 1968]</code>
</pre>

Alternatively, you can look a public up through the field `publicationYear`:

<pre>
orientdb> <code class='lang-sql userinput'>SELECT FROM INDEX:books WHERE key BETWEEN ["Donald Knuth", "The Art of 
          Computer Programming", 1960] AND ["Donald Knuth", "The Art of Computer 
          Programming", 2000]</code>
</pre>

#### Partial Match Searches

Occasionally, you may need to search an index record by several fields of its composite key.  In these partial match searches, the remaining fields with undefined values can match any value in the result.

Only use composite indexes for partial match searches when the declared fields in the composite index are used from left to right.  For instance, from the example above searching only `title` wouldn't work with a composite index, since `title` is the second value.  But, you could use it when searching `author` and `title`.

For example, consider a case where you don't care when the books in your database were published.  This allows you to use a somewhat different query, to return all books with the same author and title, but from any publication year.

<pre>
orientdb> <code class='lang-sql userinput'>SELECT FROM INDEX:books WHERE key = ["Donald Knuth", "The Art of Computer 
          Programming"]</code>
</pre>

In the event that you also don't know the title of the work you want, you can further reduce it to only search all books with the same author.

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM INDEX:books WHERE key = ["Donald Knuth"]</code>
</pre>

Or, the equivalent,

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM INDEX:books WHERE key = "Donald Knuth"</code>
</pre>

#### Insertion for Composite Indexes

|||
|-|-|
|![](images/warning.png)| Direct insertion for composite indexes is not yet supported in OrientDB.|

### Range Queries

In the case of range queries, the field subject to the range must be the last one, (that is, the one on the far right).  For example,

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM INDEX:books WHERE key BETWEEN ["Donald Knuth", "The Art of 
          Computer Programming", 1900] AND ["Donald Knuth", "The Art of Computer 
          Programming", 2014]</code>
</pre>




## Operations against Indexes

Once you have a good understanding of the theoretical side of what indexes are and some of basic concepts that go into their use, it's time to consider the practical aspects of creating and using indexes with your application.

### Creating Indexes

When you have created the relevant classes that you want to index, create the index.  To create an automatic index, bound to a schema property, use the `ON` section or use the name in the `<class>.<property>` notation.

**Syntax:**


```sql
CREATE INDEX <name> [ON <class-name> (prop-names)] <type> [<key-type>]
                    [METADATA {<metadata>}]
```

- `<name>` Provides the logical name for the index.  You can also use the `<class.property>` notation to create an automatic index bound to a schema property.  In this case, for `<class>` use the class of the schema and `<property>` the property created in the class.

  Bear in mind that this means case index names cannot contain the period (`.`) symbol, as OrientDB would interpret the text after as a property.

- `<class-name>` Provides the name of the class that you are creating the automatic index to index.  Thisclass must already exist in the database.

- `<prop-names>` Provides a comma-separated list of properties, which you want the automatic index to index.  These properties must already exist in the schema.

  If the property belongs to one of the Map types, (such as `LINKMAP`, or `EMBEDDEDMAP`), you can specify the keys or values to use in generating indexes.  You can do this with the `BY KEY` or `BY VALUE` expressions, if nothing is specified, these keys are used during index creation.
  
- `<type>` Provides the algorithm and type of index that you want to create.  For information on the supported index types, see [Index Types](Indexes.md#index-types).

- `<key-type>` Provides the optional key type.  With automatic indexes, the key type OrientDB automatically determines the key type by reading teh target schema property where the index is created.  With manual indexes, if not specified, OrientDB automatically determines the key type at run-time, during the first insertion by reading the type of the class.

- `<metadata>` Provides a JSON representation

**Examples:**

- Creating custom indexes:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE INDEX mostRecentRecords UNIQUE date</code>
  </pre>

- Creating automatic indexes bound to the property `id` of the class `User`:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE PROPERTY User.id BINARY</code>
  orientdb> <code class="lang-sql userinput">CREATE INDEX User.id UNIQUE</code>
  </pre>

- Creating another index for the property `id` of the class `User`:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE INDEX indexForId ON User (id) UNIQUE</code>
  </pre>

- Creating indexes for property `thumbs` on class `Movie`:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE INDEX thumbsAuthor ON Movie (thumbs) UNIQUE</code>
  orientdb> <code class="lang-sql userinput">CREATE INDEX thumbsAuthor ON Movie (thumbs BY KEY) UNIQUE</code>
  orientdb> <code class="lang-sql userinput">CREATE INDEX thumbsValue on Movie (thumbs BY VALUE) UNIQUE</code>
  </pre>

- Creating composite indexes:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE PROPERTY Book.author STRING</code>
  orientdb> <code class="lang-sql userinput">CREATE PROPERTY Book.title STRING</code>
  orientdb> <code class="lang-sql userinput">CREATE PROPERTY Book.publicationYears EMBEDDEDLIST INTEGER</code>
  orientdb> <code class="lang-sql userinput">CREATE INDEX books ON Book (author, title, publicationYears) UNIQUE
  </pre>

For more information on creating indexes, see the [`CREATE INDEX`](SQL-Create-Index.md) command.

### Dropping Indexes

In the event that you have an index that you no longer want to use, you can drop it from the database.  This operation does not remove linked records.

**Syntax:**

```sql
DROP INDEX <name>
```
- `<name>` provides the name of the index you want to drop.

For more information on dropping indexes, see the [`DROP INDEX`](SQL-Drop-Index.md) command.

### Querying Indexes

When you have an index created and in use, you can query records in the index using the [`SELECT`](SQL-Query.md) command.

**Syntax:**

```sql
SELECT FROM INDEX:<index-name> WHERE key = <key>
```

**Example:**

- Selecting from the index `dictionary` where the key matches to `Luke`:

  <pre>
  orientdb> <code class="lang-sql userinput">SELECT FROM INDEX:dictionary WHERE key='Luke'</code>
  </pre>

### Case-insensitive Matching with Indexes

In the event that you would like the index to use case-insensitive matching, set the `COLLATE` attribute of the indexed properties to `ci`.  For instance,

<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX OUser.name ON OUser (name COLLATE ci) UNIQUE</code>
</pre>

### Inserting Index Entries

You can insert new entries into the index using the `key` and `rid` pairings.

**Syntax:**

```sql
INSERT INTO INDEX:<index-name> (key,rid) VALUES (<key>,<rid>)
```

**Example:**

- Inserting the key `Luke` and Record ID `#10:4` into the index `dictionary`:

  <pre>
  orientdb> <code class="lang-sql userinput">INSERT INTO INDEX:dictionary (key, rid) VALUES ('Luke', #10:4)</code>
  </pre>

### Querying Index Ranges

In addition to querying single results from the index, you can also query a range of results between minimum and maximum values.  Bear in mind that not all index types support this operation.

**Syntax:**


```sql
SELECT FROM INDEX:<index-name> WHERE key BETWEEN <min> AND <max>
```

**Example:**

- Querying from the index `coordinates` and range between `10.3` and `10.7`:

  <pre>
  orientdb> <code class="lang-sql userinput">SELECT FROM INDEX:coordinates WHERE key BETWEEN 10.3 AND 10.7</code>
  </pre>

### Removing Index Entries

You can delete entries by passing the `key` and `rid` values.  This operation returns `TRUE` if the removal was successful and `FALSE` if the entry wasn't found.

**Syntax:**

```sql
DELETE FROM INDEX:<index-name> WHERE key = <key> AND rid = <rid>
```

**Example:**

- Removing an entry from the index `dictionary`:

  <pre>
  orientdb> <code class='lang-sql userinput'>DELETE FROM INDEX:dictionary WHERE key = 'Luke' AND rid = #10:4</code>
  </pre>



### Removing Index Entries by Key

You can delete all entries from the index through the requested key.

**Syntax:**

```sql
DELETE FROM INDEX:<index-name> WHERE key = <key>
```

**Example:**

- Delete entries from the index `addressbook` whee the key matches to `Luke`:

  <pre>
  orientdb> <code class='lang-sql userinput'>DELETE FROM INDEX:addressbook WHERE key = 'Luke'</code>
  </pre>

### Removing Index Entries by RID

You can remove all index entries to a particular record by its record ID.

**Syntax:**

```sql
DELETE FROM INDEX:<index-name> WHERE rid = <rid>
```

**Example:**

- Removing entries from index `dictionary` tied to the record ID `#10:4`:

  <pre>
  orientdb> <code class="lang-sql userinput">DELETE FROM INDEX:dictionary WHERE rid = #10:4
  </pre>

### Counting Index Entries

To see the number of entries in a given index, you can use the `COUNT()` function.

**Syntax:**


```sql
SELECT COUNT(*) AS size FROM INDEX:<index-name>
```

**Example:**

- Counting the entries on the index `dictionary`:

  <pre>
  orientdb> <code class='lang-sql userinput'>SELECT COUNT(*) AS size FROM INDEX:dictionary</code>
  </pre>

### Querying Keys from Indexes

You can query all keys in an index using the [`SELECT`](SQL-Query.md) command.

**Syntax:**

```sql
SELECT key FROM INDEX:<index-name>
```

**Example:**

- Querying the keys in the index `dictionary`:

  <pre>
  orientdb> <code class="lang-sql userinput">SELECT key FROM INDEX:dictionary</code>
  </pre>

### Querying Index Entries

You can query for all entries on an index as `key` and `rid` pairs.

**Syntax:**

```sql
SELECT key, value FROM INDEX:<index-name>
```

**Example:**

- Querying the `key`/`rid` pairs from the index `dictionary`:

  <pre>
  orientdb> <code class='lang-sql userinput'>SELECT key, value FROM INDEX:dictionary</code>
  </pre>

### Clearing Indexes

Remove all entries from an index.  After running this command, the index is empty.

**Syntax:**

```sql
DELETE FROM INDEX:<index-name>
```

**Example:**

- Removing all entries from the index `dictionary`:

  <pre>
  orientdb> <code class="lang-sql userinput">DELETE FROM INDEX:dictionary</code>
  </pre>




## Custom Keys

OrientDB includes support for the creation of custom keys for indexes.  This feature has been available since version 1.0, and can provide you with a huge performance improvement, in the event that you would like minimize memory usage by developing your own serializer.

For example, consider a case where you want to handle SHA-256 data as binary keys without using a string to represent it, which would save on disk space, CPU and memory usage.

To implement this, begin by creating your own type,

```java
public static class ComparableBinary implements Comparable<ComparableBinary> {
      private byte[] value;

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

With your index type created, next create a binary selector for it to use:

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

      public void serialize(
         final ComparableBinary object,
         final byte[] stream,
	 final int startPosition) {
                  final byte[] buffer = object.toByteArray();
                  System.arraycopy(buffer, 0, stream, startPosition, buffer.length);
            }

      public ComparableBinary deserialize(
         final byte[] stream,
	 final int startPosition) {
                 final byte[] buffer = Arrays.copyOfRange(
			      stream,
			      startPosition,
			      startPosition + LENGTH);
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

Lastly, register the new serializer with OrientDB:

```java
OBinarySerializerFactory.INSTANCE.registerSerializer(new OHash256Serializer(), null);
index = database.getMetadata().getIndexManager().createIndex("custom-hash", "UNIQUE", new ORuntimeKeyIndexDefinition(OHash256Serializer.ID), null, null);
```

Your custom keys are now available for use in searches:

```java
ComparableBinary key1 = new ComparableBinary(new byte[] { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1 });
ODocument doc1 = new ODocument().field("k", "key1");
index.put(key1, doc1);
```


## Query the available indexes

To access to the indexes, you can use [SQL](SQL.md#query-the-available-indexes).

## Create your index engine

Here you can find a guide how to create a [custom index engine](Custom-Index-Engine.md).
