<!-- proofread 2015-12-10 SAM -->

# Lucene FullText Index

In addition to the standard FullText Index, which uses the SB-Tree index algorithm, you can also create FullText indexes using the Lucene Engine. Beginning from version 2.0, this plugin is packaged with OrientDB distribution.

**Syntax**:

```sql
CREATE INDEX <name> ON <class-name> (prop-names) FULLTEXT ENGINE LUCENE
```

The following SQL statement will create a FullText index on the property `name` for the class `City`, using the Lucene Engine.

<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX City.name ON City(name) FULLTEXT ENGINE LUCENE</code>
</pre>

Indexes can also be created on *n*-properties.  For example, create an index on the properties `name` and `description` on the class `City`.

<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX City.name_description ON City(name, description)
          FULLTEXT ENGINE LUCENE</code>
</pre>


### Analyzer 

This creates a basic FullText Index with the Lucene Engine on the specified properties.  In the even that you do not specify the analyzer, OrientDB defaults to [StandardAnalyzer](http://lucene.apache.org/core/4_7_0/analyzers-common/org/apache/lucene/analysis/standard/StandardAnalyzer.html).

In addition to the StandardAnalyzer, you can also create indexes that use different analyzer, using the `METADATA` operator through [`CREATE INDEX`](SQL-Create-Index.md).

<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX City.name ON City(name) FULLTEXT ENGINE LUCENE METADATA
          {"analyzer": "org.apache.lucene.analysis.en.EnglishAnalyzer"}</code>
</pre>

**(from 2.2)**

Starting from 2.2 it is possible to configure different analyzers for indexing and querying.

<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX City.name ON City(name) FULLTEXT ENGINE LUCENE METADATA
          {
          "index_analyzer": "org.apache.lucene.analysis.en.EnglishAnalyzer",
          "query_analyzer": "org.apache.lucene.analysis.standard.StandardAnalyzer"
          }</code>
</pre>

EnglishAnalyzer will be used to analyze text while indexing and the StandardAnalyzer will be used to analyze query terms. 

It is posssbile to configure analyzers at field level

<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX City.name_description ON City(name, description) FULLTEXT ENGINE LUCENE METADATA
          {
          "index_analyzer": "org.apache.lucene.analysis.en.EnglishAnalyzer",
          "query_analyzer": "org.apache.lucene.analysis.standard.StandardAnalyzer",
          "name_index_analyzer": "org.apache.lucene.analysis.standard.StandardAnalyzer",
          "name_query_analyzer": "org.apache.lucene.analysis.core.KeywordAnalyzer"
          }</code>
</pre>

With this configuration **name** will be indexed with StandardAnalyzer and query will be analyzed with the KeywordAnalyzer: **description** hasn't a custom configuration, so default analyzers for indexing an querying will be used.


You can also use the FullText Index with the Lucene Engine through the Java API.

```java
OSchema schema = databaseDocumentTx.getMetadata().getSchema();
OClass oClass = schema.createClass("Foo");
oClass.createProperty("name", OType.STRING);
oClass.createIndex("City.name", "FULLTEXT", null, null, "LUCENE", new String[] { "name"});
```

## Querying Lucene FullText Indexes

You can query the Lucene FullText Index using the custom operator `LUCENE` with the [Query Parser Synta]x(http://lucene.apache.org/core/2_9_4/queryparsersyntax.html) from the Lucene Engine.

<pre>
orientdb> <code class='lang-sql userinput'>SELECT FROM V WHERE name LUCENE "test*"</code>
</pre>

This query searches for `test`, `tests`, `tester`, and so on from the property `name` of the class `V`.

### Working with Multiple Fields

In addition to the standard Lucene query above, you can also query multiple fields.  For example,

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM Class WHERE [prop1, prop2] LUCENE "query"</code>
</pre>

In this case, if the word `query` is a plain string, the engine parses the query using [MultiFieldQueryParser](http://lucene.apache.org/core/4_7_0/queryparser/org/apache/lucene/queryparser/classic/MultiFieldQueryParser.html) on each indexed field.

To execute a more complex query on each field, surround your query with parentheses, which causes the query to address specific fields.

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM CLass WHERE [prop1, prop2] LUCENE "(prop1:foo AND prop2:bar)"</code>
</pre>

Here, hte engine parses the query using the [QueryParser](http://lucene.apache.org/core/4_7_0/queryparser/org/apache/lucene/queryparser/classic/QueryParser.html)


## Creating a Manual Lucene Index

Beginning with version 2.1, the Lucene Engine supports index creation without the need for a class.

**Syntax**:

```sql
CREATE INDEX <name> FULLTEXT ENGINE LUCENE  [<key-type>] [METADATA {<metadata>}]
```

For example, create a manual index using the [`CREATE INDEX`](SQL-Create-Index.md) command:

<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX Manual FULLTEXT ENGINE LUCENE STRING, STRING</code>
</pre>

Once you have created the index `Manual`, you can insert values in index using the [`INSERT INTO INDEX:...`](SQL-Insert.md) command.

<pre>
orientdb> <code class="lang-sql userinput">INSERT INTO INDEX:Manual (key, rid) VALUES(['Enrico', 'Rome'], #5:0)</code>
</pre>

You can then query the index through [`SELECT...FROM INDEX:`](SQL-Query.md):

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM INDEX:Manual WHERE key LUCENE "Enrico"</code>
</pre>

