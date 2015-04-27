# Lucene Full Text Index

Full text index can be created using the OrientDB SQL syntax as written [here](https://github.com/orientechnologies/orientdb/wiki/Indexes). Specify the index engine to use the lucene full text capabilities.

Syntax:

```sql
CREATE INDEX <name> ON <class-name> (prop-names) FULLTEXT ENGINE LUCENE
```

Example

```sql
CREATE INDEX City.name ON City (name) FULLTEXT ENGINE LUCENE
```

Index can also be created on n-properties:

Example:
```sql
CREATE INDEX City.name_description ON City (name,description) FULLTEXT ENGINE LUCENE
```

This will create a basic lucene index on  the properties specified. If the analyzer is not specified, the default will be the [StandardAnalyzer](http://lucene.apache.org/core/4_7_0/analyzers-common/org/apache/lucene/analysis/standard/StandardAnalyzer.html). To use a different analyzer use the field analyzer in the metadata JSON object in the CREATE INDEX syntax.

Example:

```sql
CREATE INDEX City.name ON City (name) FULLTEXT ENGINE LUCENE METADATA {"analyzer":"org.apache.lucene.analysis.en.EnglishAnalyzer"}
```

The Index can also be created with the Java API. Example:

```java
OSchema schema = databaseDocumentTx.getMetadata().getSchema();
OClass oClass = schema.createClass("Foo");
oClass.createProperty("name", OType.STRING);
oClass.createIndex("City.name", "FULLTEXT", null, null, "LUCENE", new String[] { "name"});
```

### How to query a Full Text Index

The full text index can be queried using the custom operator `LUCENE` using the [Query Parser Syntax](http://lucene.apache.org/core/2_9_4/queryparsersyntax.html) of Lucene. Example:

```sql
SELECT * FROM V WHERE name LUCENE "test*"
```

will look for `test`, `tests`, `tester`, etc..

#### Working with multiple field

To query multiple fields use this special syntax:

```sql
SELECT * FROM Class WHERE [prop1,prop2] LUCENE "query"
```

If `query` is a plain string the engine will parse the query using [MultiFieldQueryParser](http://lucene.apache.org/core/4_7_0/queryparser/org/apache/lucene/queryparser/classic/MultiFieldQueryParser.html) on each indexed field.

To execute a more complex query on each fields surround your query with `()` parenthesis, to address specific field.

Example:
```sql
SELECT * FROM Class WHERE [prop1,prop2] LUCENE "(prop1:foo AND props2:bar)"
```

With this syntax the engine parse the query using the [QueryParser](http://lucene.apache.org/core/4_7_0/queryparser/org/apache/lucene/queryparser/classic/QueryParser.html).
