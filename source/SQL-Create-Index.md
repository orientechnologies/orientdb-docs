# SQL - CREATE INDEX

Creates a new index. To create an automatic index bound to a schema property use section "**ON**" of create index command or use as name the <**class.property**> notation. But assure to have created the schema for it before the index. See the example below.

Indexes can be:

- **UNIQUE**, doesn't allow duplicated
- **NOTUNIQUE**, allows duplicates
- **FULLTEXT**, by indexing any single word of the text. It's used in query with the operator [CONTAINSTEXT](SQL-Where.md#operators)

## Syntax

```sql
CREATE INDEX <name> [ON <class-name> (prop-names)] <type> [<key-type>]
             METADATA [{<json-metadata>}]
```
Where:

- **name** logical name of index. Can be **<code>&lt;class&gt;.&lt;property&gt;</code>** to create an automatic index bound to a schema property. In this case **class** is the class of the schema and **property**, is the property created into the class. Notice that in another case index name can't contain '.' symbol
- **class-name** name of class that automatic index created for. Class with such name must already exist in database
- **prop-names** comma-separated list of properties that this automatic index is created for. Property with such name must already exist in schema. If property belongs to one of the Map types (LINKMAP, EMBEDDEDMAP) you can specify will be keys or values used for index generation. Use "by key" or "by value" expressions for that, if nothing will be specified keys will be used during index creation.
- **type**, between 'unique', 'notunique' and 'fulltext'
- **key-type**, is the type of key (Optional). On automatic indexes is auto-determined by reading the target schema property where the index is created. If not specified for manual indexes, at run-time during the first insertion the type will be auto determined by reading the type of the class. In case of creation composite index it is a comma separated list of types.
- **metadata** is a json representing all the additional metadata as key/value

If "**ON**" and **key-type** sections both exist database validate types of specified properties. And if types of properties not equals to types specified in **key-type** list, exception will be thrown.

List of key types can be used for creation manual composite indexes, but such indexes don't have fully support yet.


## See also
- [SQL Drop Index](SQL-Drop-Index.md)
- [Indexes](Indexes.md)
- [SQL commands](SQL.md)

## Examples

### Examples of non-automatic index to store dates manually:
```sql
CREATE INDEX mostRecentRecords unique date
```

### Examples of automatic index bound to the property "id" of class "User":
```sql
CREATE PROPERTY User.id BINARY
CREATE INDEX User.id UNIQUE
```

### Examples of index for "thumbs" property of class "Movie".
```sql
CREATE INDEX thumbsAuthor ON Movie (thumbs) UNIQUE;
CREATE INDEX thumbsAuthor ON Movie (thumbs BY KEY) UNIQUE;
CREATE INDEX thumbsValue ON Movie (thumbs BY VALUE) UNIQUE;
```

### Composite index example:
```sql
CREATE PROPERTY Book.author STRING
CREATE PROPERTY Book.title STRING
CREATE PROPERTY Book.publicationYears EMBEDDEDLIST INTEGER
CREATE INDEX books ON Book (author, title, publicationYears) UNIQUE
```

### Index by Edge's date range
You can create an index against the edge class if it's containing the begin/end date range of validity. This is a very common use case with historical graphs. Consider this File system example:

```sql
CREATE CLASS File EXTENDS V
CREATE CLASS Has EXTENDS E
CREATE PROPERTY Has.started DATETIME
CREATE PROPERTY Has.ended DATETIME
CREATE INDEX Has.started_ended ON Has (started, ended) NOTUNIQUE
```

And then you can retrieve all the edge that existed in 2014:

```sql
SELECT FROM Has WHERE started >= '2014-01-01 00:00:00.000' AND ended < '2015-01-01 00:00:00.000'
```

To have the connected parent File:

```sql
SELECT outV() FROM Has WHERE started >= '2014-01-01 00:00:00.000' AND ended < '2015-01-01 00:00:00.000'
```
To have the connected children Files:

```sql
SELECT inV() FROM Has WHERE started >= '2014-01-01 00:00:00.000' AND ended < '2015-01-01 00:00:00.000'
```


### Null values

Indexes by default ignore null values. For such reason queries against NULL value that use indexes return no entries.

If you want to index also null values set ```{ ignoreNullValues : false }``` as metadata. Example:

```sql
CREATE INDEX addresses ON Employee (address) NOTUNIQUE
             METADATA {ignoreNullValues : false}
```
