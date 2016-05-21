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

**(from 2.1.16)**

From version 2.1.16 it is possible to provide a set of stopwords to the analyzer to override the default set of the analyzer:

<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX City.name ON City(name) FULLTEXT ENGINE LUCENE METADATA
          {
          "analyzer": "org.apache.lucene.analysis.en.EnglishAnalyzer",
          "analyzer_stopwords": ["a", "an", "and", "are", "as", "at", "be", "but", "by" ]
          }
          
          </code>
</pre>


**(from 2.2)**

Starting from 2.2 it is possible to configure different analyzers for indexing and querying.

<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX City.name ON City(name) FULLTEXT ENGINE LUCENE METADATA
          {
          "index": "org.apache.lucene.analysis.en.EnglishAnalyzer",
          "query": "org.apache.lucene.analysis.standard.StandardAnalyzer"
          }</code>
</pre>

EnglishAnalyzer will be used to analyze text while indexing and the StandardAnalyzer will be used to analyze query terms. 

It is posssbile to configure analyzers at field level

<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX City.name_description ON City(name, lyrics, title,author, description) FULLTEXT ENGINE LUCENE METADATA
          {
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

You can also use the FullText Index with the Lucene Engine through the Java API.

```java
OSchema schema = databaseDocumentTx.getMetadata().getSchema();
OClass oClass = schema.createClass("Foo");
oClass.createProperty("name", OType.STRING);
oClass.createIndex("City.name", "FULLTEXT", null, null, "LUCENE", new String[] { "name"});
```
## Allow Leading Wildcard

Lucene by default doesn't support leading wildcard: [Lucene wildcard support](https://wiki.apache.org/lucene-java/LuceneFAQ#What_wildcard_search_support_is_available_from_Lucene.3F)

It is possible to override this behaviour with a dedicated flag on metadata:

```json
{
  "allowLeadingWildcard": true
}
```

Use this flag carefully, as stated in the Lucene FAQ: 
> Note that this can be an expensive operation: it requires scanning the list of tokens in the index in its entirety to look for those that match the pattern.




## Lucene Writer fine tuning (expert)

It is possible to fine tune the behaviour of the underlying Lucene's IndexWriter 

<pre>
<code class="lang-sql userinput">CREATE INDEX City.name ON City(name) FULLTEXT ENGINE LUCENE METADATA
{
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

* indexWriterConfig : https://lucene.apache.org/core/5_0_0/core/org/apache/lucene/index/IndexWriterConfig.html
* indexWriter: https://lucene.apache.org/core/5_0_0/core/org/apache/lucene/index/IndexWriter.html

## Querying Lucene FullText Indexes

You can query the Lucene FullText Index using the custom operator `LUCENE` with the [Query Parser Syntax](http://lucene.apache.org/core/5_4_1/queryparser/org/apache/lucene/queryparser/classic/package-summary.html#package_description) from the Lucene Engine.

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

Manual indexes could be created programmatically using the Java API

```java
ODocument meta = new ODocument().field("analyzer", StandardAnalyzer.class.getName());
OIndex<?> index = databaseDocumentTx.getMetadata().getIndexManager()
        .createIndex("apiManual", OClass.INDEX_TYPE.FULLTEXT.toString(),
            new OSimpleKeyIndexDefinition(1, OType.STRING, OType.STRING), null, null, meta, OLuceneIndexFactory.LUCENE_ALGORITHM);

```
