---
search:
   keywords: ['index', 'FULLTEXT', 'full text', 'Lucene']
---

# Lucene FullText Index

In addition to the standard FullText Index, which uses the SB-Tree index algorithm, you can also create FullText indexes using the Lucene Engine. Beginning from version 2.0, this plugin is packaged with OrientDB distribution.

**Syntax**:

<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX <name> ON <class-name> (prop-names) FULLTEXT ENGINE LUCENE</code>
                                                                                                                  </pre>

The following SQL statement will create a FullText index on the property `name` for the class `City`, using the Lucene Engine.

<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX City.name ON City(name) FULLTEXT ENGINE LUCENE</code>
</pre>

Indexes can also be created on *n*-properties.  For example, create an index on the properties `name` and `description` on the class `City`.

<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX City.name_description ON City(name, description)
          FULLTEXT ENGINE LUCENE</code>
</pre>

The default analyzer used by OrientDB when a Lucene index is created id the [StandardAnalyzer](https://lucene.apache.org/core/6_3_0/core/org/apache/lucene/analysis/standard/StandardAnalyzer.html).

### Analyzer 

In addition to the StandardAnalyzer, full text indexes can be configured to use different analyzer by the `METADATA` operator through [`CREATE INDEX`](SQL-Create-Index.md).

Configure the index on `City.name` to use the `EnglishAnalyzer`:
<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX City.name ON City(name)
            FULLTEXT ENGINE LUCENE METADATA {
                "analyzer": "org.apache.lucene.analysis.en.EnglishAnalyzer"
            }</code>
</pre>


Configure the index on `City.name` to use different analyzers for indexing and querying.

<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX City.name ON City(name)
            FULLTEXT ENGINE LUCENE METADATA {
                "index": "org.apache.lucene.analysis.en.EnglishAnalyzer",
                "query": "org.apache.lucene.analysis.standard.StandardAnalyzer"
          }</code>
</pre>

`EnglishAnalyzer` will be used to analyze text while indexing and the `StandardAnalyzer` will be used to analyze query terms.

A very detailed configuration, on multi-field index configuration, could be:

<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX City.name_description ON City(name, lyrics, title,author, description)
            FULLTEXT ENGINE LUCENE METADATA {
                "default": "org.apache.lucene.analysis.standard.StandardAnalyzer",
                "index": "org.apache.lucene.analysis.core.KeywordAnalyzer",
                "query": "org.apache.lucene.analysis.standard.StandardAnalyzer",
                "name_index": "org.apache.lucene.analysis.standard.StandardAnalyzer",
                "name_query": "org.apache.lucene.analysis.core.KeywordAnalyzer",
                "lyrics_index": "org.apache.lucene.analysis.en.EnglishAnalyzer",
                "title_index": "org.apache.lucene.analysis.en.EnglishAnalyzer",
                "title_query": "org.apache.lucene.analysis.en.EnglishAnalyzer",
                "author_query": "org.apache.lucene.analysis.core.KeywordAnalyzer",
                "description_index": "org.apache.lucene.analysis.standard.StandardAnalyzer",
                "description_index_stopwords": [
                  "the",
                  "is"
                ]
            }</code>
</pre>

With this configuration, the underlying Lucene index will works in different way on each field:

* *name*: indexed with StandardAnalyzer, searched with KeywordAnalyzer (it's a strange choice, but possible)
* *lyrics*: indexed with EnglishAnalyzer, searched with default query analyzer StandardAnalyzer
* *title*:  indexed and searched with EnglishAnalyzer
* *author*: indexed and searched with KeywordhAnalyzer
* *description*: indexed with StandardAnalyzer with a given set of stopwords


### Java API

The FullText Index with the Lucene Engine is configurable through the Java API.

<pre><code class="">
    OSchema schema = databaseDocumentTx.getMetadata().getSchema();
    OClass oClass = schema.createClass("Foo");
    oClass.createProperty("name", OType.STRING);
    oClass.createIndex("City.name", "FULLTEXT", null, null, "LUCENE", new String[] { "name"});
</code>
</pre>

## Query parser

It is possible to configure some behavior of the Lucene [query parser](https://lucene.apache.org/core/5_3_2/queryparser/org/apache/lucene/queryparser/classic/QueryParser.html)

### Allow Leading Wildcard

Lucene by default doesn't support leading wildcard: [Lucene wildcard support](https://wiki.apache.org/lucene-java/LuceneFAQ#What_wildcard_search_support_is_available_from_Lucene.3F)

It is possible to override this behavior with a dedicated flag on meta-data:

```json
{
  "allowLeadingWildcard": true
}
```

Use this flag carefully, as stated in the Lucene FAQ: 
> Note that this can be an expensive operation: it requires scanning the list of tokens in the index in its entirety to look for those that match the pattern.

### Disable lower case on terms

Lucene's QueryParser applies a lower case filter on expanded queries by default. It is possible to override this behavior with a dedicated flag on meta-data:

```json
{
  "lowercaseExpandedTerms": false
}
```

It is useful when used in pair with keyword analyzer:

```json
{
  "lowercaseExpandedTerms": false,
  "default" : "org.apache.lucene.analysis.core.KeywordAnalyzer"
}
```

With *lowercaseExpandedTerms* set to false, these two queries will return different results:

<pre>
<code class="lang-sql userinput">SELECT from Person WHERE name LUCENE "NAME"

SELECT from Person WHERE name LUCENE "name"

</code>
</pre>


## Lucene Writer fine tuning (expert)

It is possible to fine tune the behaviour of the underlying Lucene's IndexWriter 

<pre>
<code class="lang-sql userinput">CREATE INDEX City.name ON City(name)
    FULLTEXT ENGINE LUCENE METADATA {
        "directory_type": "nio",
        "use_compound_file": false,
        "ram_buffer_MB": "16",
        "max_buffered_docs": "-1",
        "max_buffered_delete_terms": "-1",
        "ram_per_thread_MB": "1024",
        "default": "org.apache.lucene.analysis.standard.StandardAnalyzer"
    }
</code>
</pre>

* *directory_type*: configure the acces type to the Lucene's index
    * *nio* (_default)_: the index is opened with *NIOFSDirectory*
    * *mmap*:  the index is opened with *MMapDirectory*
    * *ram*: index will be created in memory with *RAMDirectory*
* *use_compound_file*: default is false
* *ram_buffer_MB*: size of the document's buffer in MB, default value is 16 MB (which means flush when buffered docs consume approximately 16 MB RAM)
* *max_buffered_docs*: size of the document's buffer in number of docs, disabled by default (because IndexWriter flushes by RAM usage by default) 
* *max_buffered_delete_terms*: disabled by default (because IndexWriter flushes by RAM usage by default).
* *ram_per_thread_MB*: default value is 1945

For a detailed explanation of config parameters and IndexWriter behaviour

* indexWriterConfig : https://lucene.apache.org/core/6_3_0/core/org/apache/lucene/index/IndexWriterConfig.html
* indexWriter: https://lucene.apache.org/core/6_3_0/core/org/apache/lucene/index/IndexWriter.html

## Querying Lucene FullText Indexes

You can query the Lucene FullText Index using the custom operator `LUCENE` with the [Query Parser Syntax](http://lucene.apache.org/core/6_3_0/queryparser/org/apache/lucene/queryparser/classic/package-summary.html#package_description) from the Lucene Engine.

<pre>
orientdb> <code class='lang-sql userinput'>SELECT FROM V WHERE name LUCENE "test*"</code>
</pre>

This query searches for `test`, `tests`, `tester`, and so on from the property `name` of the class `V`.
The query can use proximity operator _~_, the required (_+_) and prohibit (_-_) operators, phrase queries, regexp queries:

<pre>
orientdb> <code class='lang-sql userinput'>SELECT FROM Article WHERE content LUCENE "(+graph -rdbms) AND +cloud"</code>
</pre>


### Working with multiple fields

In addition to the standard Lucene query above, you can also query multiple fields.  For example,

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM Class WHERE [prop1, prop2] LUCENE "query"</code>
</pre>

In this case, if the word `query` is a plain string, the engine parses the query using [MultiFieldQueryParser](http://lucene.apache.org/core/6_3_0/queryparser/org/apache/lucene/queryparser/classic/MultiFieldQueryParser.html) on each indexed field.

To execute a more complex query on each field, surround your query with parentheses, which causes the query to address specific fields.

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM Article WHERE [content, author] LUCENE "(content:graph AND author:john)"</code>
</pre>

Here, the engine parses the query using the [QueryParser](http://lucene.apache.org/core/6_3_0/queryparser/org/apache/lucene/queryparser/classic/QueryParser.html)

### Numeric and date range queries

If the index is defined over a numeric field (INTEGER, LONG, DOUBLE) or a date field (DATE, DATETIME), the engine supports [range queries](http://lucene.apache.org/core/6_3_0/queryparser/org/apache/lucene/queryparser/classic/package-summary.html#Range_Searches)
Suppose to have a `City` class witha multi-field Lucene index defined:

<pre>
orientdb> <code class="lang-sql userinput">
CREATE CLASS CITY EXTENDS V
CREATE PROPERTY CITY.name STRING
CREATE PROPERTY CITY.size INTEGER
CREATE INDEX City.name ON City(name,size) FULLTEXT ENGINE LUCENE
</code>
</pre>

Then query using ranges:

<pre>
orientdb> <code class="lang-sql userinput">
SELECT FROM City WHERE [name,size] LUCENE 'name:cas* AND size:[15000 TO 20000]'
</code>
</pre>

Ranges can be applied to DATE/DATETIME field as well. Create a Lucene index over a property:

<pre>
orientdb> <code class="lang-sql userinput">
CREATE CLASS Article EXTENDS V
CREATE PROPERTY Article.createdAt DATETIME
CREATE INDEX Article.createdAt  ON Article(createdAt) FULLTEXT ENGINE LUCENE
</code>
</pre>

Then query to retrieve articles published only in a given time range:

<pre>
orientdb> <code class="lang-sql userinput">
SELECT FROM Article WHERE createdAt LUCENE '[201612221000 TO 201612221100]'</code>
</pre>



### Retrieve the Score

When the lucene index is used in a query, the results set carries a context variable for each record representing the score.
To display the score add `$score` in projections.

```
SELECT *,$score FROM V WHERE name LUCENE "test*"
```

## Creating a Manual Lucene Index

The Lucene Engine supports index creation without the need for a class.

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

Manual indexes could be created programmatically using the Java API

```java
ODocument meta = new ODocument().field("analyzer", StandardAnalyzer.class.getName());
OIndex<?> index = databaseDocumentTx.getMetadata().getIndexManager()
        .createIndex("apiManual", OClass.INDEX_TYPE.FULLTEXT.toString(),
            new OSimpleKeyIndexDefinition(1, OType.STRING, OType.STRING), null, null, meta, OLuceneIndexFactory.LUCENE_ALGORITHM);

```
