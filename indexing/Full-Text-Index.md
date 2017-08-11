---
search:
   keywords: ['index', 'FULLTEXT', 'full text', 'Lucene']
---

# Lucene FullText Index

In addition to the standard FullText Index, which uses the SB-Tree index algorithm, you can also create FullText indexes using the [Lucene Engine](http://lucene.apache.org/) .
Apache LuceneTM is a high-performance, full-featured text search engine library written entirely in Java.
Check the [Lucene's documentation](http://lucene.apache.org/core/6_6_0/index.html) for a full overview of its capabilities

## How Lucene's works?

Let's look at a sample corpus of five documents:
* My sister is coming for the holidays.
* The holidays are a chance for family meeting.
* Who did your sister meet?
* It takes an hour to make fudge.
* My sister makes awesome fudge.

What does Lucene do? Lucene is a full text search library.
Search has two principal stages: indexing and retrieval.

During indexing, each document is broken into words, and the list of documents containing each word is stored in a list called the _postings list_.
The posting list for the word _my_ is:

_my_ --> 1,5

Posting list for others terms:

_fudge_ --> 4,5

_sister_ --> 1,2,3,5

_fudge_ --> 4,5

The index consists of all the posting lists for the words in the corpus.
Indexing must be done before retrieval, and we can only retrieve documents that were indexed.

Retrieval is the process starting with a query and ending with a ranked list of documents.
Say the query is "my fudge".
In order to find matches for the query, we break it into the individual words, and go to the posting lists.
The full list of documents containing the keywords is [1,4,5].
Note that the query is broken into words (terms) and each term is matched with the terms in the index.
Lucene's default operator is *OR*, so it retrieves the documents tha contain _my_ *OR* _fudge_.
If we want to retrieve documents that contain both _my_ and _fudge_, rewrite the query: "+my +fudge".

Lucene doesn't work as a LIKE operator on steroids, it works on single terms. Terms are produced analyzing the provided text, so the right analyzer should be configured.
On the other side, it offers a complete query language, well documented (here)[https://lucene.apache.org/core/6_6_0/queryparser/org/apache/lucene/queryparser/classic/QueryParser.html]:

## Index creation

To create an index based on Lucene
<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX <name> ON <class-name> (prop-names) FULLTEXT ENGINE LUCENE [{json metadata}]</code>
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

When multiple properties should be indexed, define a *single multi-field index* over the class.
A single multi-field index needs less resources, such as file handlers.
Moreover, it is easy to write better Lucene queries.
The default analyzer used by OrientDB when a Lucene index is created is the [StandardAnalyzer](https://lucene.apache.org/core/6_6_0/core/org/apache/lucene/analysis/standard/StandardAnalyzer.html).
The StandardAnalyzer usually works fine with western languages, but Lucene offers analyzer for different languages and use cases.

## Two minutes tutorial

Open studio or console and create a sample dataset:

<pre>
orientdb> <code class="lang-sql userinput">
CREATE CLASS Item;
CREATE PROPERTY Item.text STRING;
CREATE INDEX Item.text ON Item(text) FULLTEXT ENGINE LUCENE;
INSERT INTO Item (text) VALUES ('My sister is coming for the holidays.');
INSERT INTO Item (text) VALUES ('The holidays are a chance for family meeting.');
INSERT INTO Item (text) VALUES ('Who did your sister meet?');
INSERT INTO Item (text) VALUES ('It takes an hour to make fudge.');
INSERT INTO Item (text) VALUES ('My sister makes awesome fudge.');
</code>
</pre>

Search all documents that contain _sister_:

<pre>
orientdb> <code class="lang-sql userinput">
SELECT FROM Item WHERE SEARCH_CLASS("sister") = true</code>
</pre>

Search all documents that contain _sister_ *AND* _coming_:

<pre>
orientdb> <code class="lang-sql userinput">
SELECT FROM Item WHERE SEARCH_CLASS("+sister +coming") = true</code>
</pre>

Search all documents that contain _sister_ but *NOT* _coming_:

<pre>
orientdb> <code class="lang-sql userinput">
SELECT FROM Item WHERE SEARCH_CLASS("+sister -coming") = true</code>
</pre>

Search all documents that contain the phrase _sister meet_:

<pre>
orientdb> <code class="lang-sql userinput">
SELECT FROM Item WHERE SEARCH_CLASS(' "sister meet" ') = true</code>
</pre>

Search all documents that contain terms starting with _meet_:

<pre>
orientdb> <code class="lang-sql userinput">
SELECT FROM Item WHERE SEARCH_CLASS('meet*') = true</code>
</pre>

To better understand how the query parser work, read carefully the official documentation and play with the above documents.

## Customize Analyzers

In addition to the StandardAnalyzer, full text indexes can be configured to use different analyzer by the `METADATA` operator through [`CREATE INDEX`](../sql/SQL-Create-Index.md).

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

`EnglishAnalyzer` will be used to analyze text while indexing and the `StandardAnalyzer` will be used to analyze query text.

A very detailed configuration, on multi-field index configuration, could be:

<pre>
orientdb> <code class="lang-sql userinput">
    CREATE INDEX Song.fulltext ON Song(name, lyrics, title, author, description)
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
* *author*: indexed and searched with KeywordAnalyzer
* *description*: indexed with StandardAnalyzer with a given set of stop-words that overrides the internal set

Analysis is the foundation of Lucene. By default the StandardAnalyzer removes english stop-words and punctuation and lowercase the generated terms:

_The holidays are a chance for family meeting!_

Would produce

* _holidays_
* _are_
* _chance_
* _for_
* _family_
* _meeting_

Each analyzer has its set of stop-words and tokenize the text in a different way.
Read the full (documentation)[http://lucene.apache.org/core/6_6_0/].

## Query parser

It is possible to configure some behavior of the Lucene [query parser](https://lucene.apache.org/core/6_6_0/queryparser/org/apache/lucene/queryparser/classic/QueryParser.html)
Query parser's behavior can be configured at index creation time and overridden at runtime.


### Allow Leading Wildcard

Lucene by default doesn't support leading wildcard: [Lucene wildcard support](https://wiki.apache.org/lucene-java/LuceneFAQ#What_wildcard_search_support_is_available_from_Lucene.3F)

It is possible to override this behavior with a dedicated flag on meta-data:

```json
{
  "allowLeadingWildcard": true
}
```

<pre>
orientdb> <code class="lang-sql userinput">
    CREATE INDEX City.name ON City(name)
            FULLTEXT ENGINE LUCENE METADATA {
                "allowLeadingWildcard": true
            }</code>
</pre>



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

<pre>
orientdb> <code class="lang-sql userinput">
    CREATE INDEX City.name ON City(name)
            FULLTEXT ENGINE LUCENE METADATA {
              "lowercaseExpandedTerms": false,
              "default" : "org.apache.lucene.analysis.core.KeywordAnalyzer"
            }</code>
</pre>

With *lowercaseExpandedTerms* set to false, these two queries will return different results:

<pre>
<code class="lang-sql userinput">SELECT from Person WHERE SEARCH_CLASS("NAME") = true

SELECT from Person WHERE WHERE SEARCH_CLASS("name") = true
</code>
</pre>

## Querying Lucene FullText Indexes

OrientDB 3.0.x introduced search functions: *SEARCH_CLASS*, *SEARCH_FIELDS*, *SEARCH_INDEX*, *SEARCH_MORE*
Every function accepts as last, optional, parameter a JSON with additional configuration.

### SEARCH_CLASS

The best way to use the search capabilities of OrientDB is to define a single multi-fields index and use the *SEARCH_CLASS* function.
In case more than one full-text index are defined over a class, an error is raised in case of *SEARCH_CLASSI* invocation.

Suppose to have this index
<pre>
orientdb> <code class="lang-sql userinput">
    CREATE INDEX City.fulltex ON City(name, description) FULLTEXT ENGINE LUCENE </code>
</pre>


<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM City WHERE SEARCH_CLASS("+name:cas*  +description:beautiful") = true</code>
</pre>

The function accepts metadata JSON as second parameter:

<pre>orientdb> <code class="lang-sql userinput">SELECT FROM City WHERE SEARCH_CLASS("+name:cas*  +description:beautiful", {
    "allowLeadingWildcard": true ,
    "lowercaseExpandedTerms": false,
    "boost": {
        "name": 2
    },
    "highlight": {
        "fields": ["name"],
        "start": "<em>",
        "end": "</em>"
    }
}) = true</code>
</pre>

The query shows query parser's configuration override, boost of field *name* with highlight. Highlight and boost will be explained later.

### SEARCH_MORE

OrientDB exposes the Lucene's _more like this_ capability with a dedicated function.

The first parameter is the array of RID of elements to be used to calculate similarity, the second parameter the usual metadata JSON used to tune the query behaviour.

<pre>orientdb> <code class="lang-sql userinput">SELECT FROM City WHERE SEARCH_MORE([#25:2, #25:3],{'minTermFreq':1, 'minDocFreq':1} ) = true</code>
</pre>

It is possible to use a query to gather RID of documents to be used to calculate similarity:

<pre>orientdb> <code class="lang-sql userinput">SELECT FROM City
    let $a=(SELECT @rid FROM City WHERE name = 'Rome')
    WHERE SEARCH_MORE( $a, { 'minTermFreq':1, 'minDocFreq':1} ) = true</code>
</pre>

Lucene's MLT has a lot of parameter, and all these are exposed through the metadata JSON: http://lucene.apache.org/core/6_6_0/queries/org/apache/lucene/queries/mlt/MoreLikeThis.html

* *fieldNames*: array of field's names to be used to extract content
* *maxQueryTerms*
* *minDocFreq*
* *maxDocFreq*
* *minTermFreq*
* *boost*
* *boostFactor*
* *maxWordLen*
* *minWordLen*
* *maxNumTokensParsed*
* *stopWords*

### Query parser's runtime configuration

It is possible to override the query parser's  configuration given at creation index time at runtime passing a json:

<pre>
<code class="lang-sql userinput">SELECT from Person WHERE SEARCH_CLASS("bob",{
        "allowLeadingWildcard": true ,
        "lowercaseExpandedTerms": false
    } ) = true
</code>
</pre>

The same can be done for query analyzer, overriding the configuration given at index creation's time:

<pre>
<code class="lang-sql userinput">SELECT from Person WHERE SEARCH_CLASS("bob",{
        "customAnalysis": true ,
        "query": "org.apache.lucene.analysis.standard.StandardAnalyzer",
        "name_query": "org.apache.lucene.analysis.en.EnglishAnalyzer"
    } ) = true
</code>
</pre>

The *customAnalysis* flag is mandatory to enable the runtime configuration of query analyzers.
The runtime configuration is _per query_ and it isn't stored nor reused for a subsequent query.
The custom configuration can be used with all the functions.

### SEARCH_INDEX

The *SEARCH_INDEX* function allows to execute the query on a single index. It is useful if more than one index are defined over a class.

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM City WHERE SEARCH_INDEX("City.name", "cas*") = true</code>
</pre>

The function accepts a JSON as third parameter, as for *SEARCH_CLASS*.

### SEARCH_FIELDS

The *SEARCH_FIELDS* function allows to execute query over the index that is defined over one ormore fields:

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM City WHERE SEARCH_FIELDS(["name", "description"], "name:cas* description:beautiful") = true</code>
</pre>

The function accepts a JSON as third parameter, as for *SEARCH_CLASS*.


### Numeric and date range queries

If the index is defined over a numeric field (INTEGER, LONG, DOUBLE) or a date field (DATE, DATETIME), the engine supports [range queries](http://lucene.apache.org/core/6_6_0/queryparser/org/apache/lucene/queryparser/classic/package-summary.html#Range_Searches)
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
SELECT FROM City WHERE SEARCH_CLASS('name:cas* AND size:[15000 TO 20000]') = true
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
SELECT FROM Article WHERE SEARCH_CLASS('[201612221000 TO 201612221100]') =true</code>
</pre>

### Retrieve the Score

When the lucene index is used in a query, the results set carries a context variable for each record representing the score.
To display the score add `$score` in projections.

<pre>
orientdb> <code class="lang-sql userinput">
SELECT *,$score FROM V WHERE name LUCENE "test*"
</pre>

### Highlighting

OrientDB uses the Lucene's highlighter. Highlighting can be configured using the metadata JSON. The highlighted content of a field is stored in a dedicated field.

<pre>
orientdb> <code class="lang-sql userinput">SELECT name, $name_hl, description, $description_hl FROM City
WHERE SEARCH_CLASS("+name:cas*  +description:beautiful", {
    "highlight": {
        "fields": ["name", "description"],
        "start": "<em>",
        "end": "</em>"
    }
}) = true</code>
</pre>

Parameters
* *fields*: array of field names to be highlighted
* *start*: start delimiter for highlighted text (default \<B>)
* *end*: end delimiter for highlighted text (default \</B>)
* *maxNumFragments*: maximum number of text's fragments to highlight

### Cross class search (Enterprise Edition)

Bundled with the enterprise edition there's the *SEARH_CROSS* function that is able to search over all the Lucene indexes defined on a database

Suppose to define two indexes:

<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX Song.title ON Song (title,author) FULLTEXT ENGINE LUCENE METADATA
CREATE INDEX Author.name on Author(name,score) FULLTEXT ENGINE LUCENE METADATA
</code>
</pre>

Searching for a term on each class implies a lot of different queries to be aggregated.

The *SEARCH_CLASS* function automatically performs the given query to each full-text index configured inside the database.

<pre>
orientdb> <code class="lang-sql userinput">SELECT  EXPAND(SEARCH_CROSS('beautiful'))
</code>
</pre>

The query will be execute over all the indexes configured on each field.
It is possible to search over a given field of a certain class, just qualify the field names with their class name:

<pre>
orientdb> <code class="lang-sql userinput">SELECT  EXPAND(SEARCH_CROSS('Song.title:beautiful  Author.name:bob'))
</code>
</pre>

Another way is to use the metadata field *_CLASS* present in every index:

<pre>
orientdb> <code class="lang-sql userinput">SELECT expand(SEARCH_CROSS('(+_CLASS:Song +title:beautiful) (+_CLASS:Author +name:bob)') )
</code>
</pre>

All the options of a Lucene's query are allowed: inline boosting, phrase queries, proximity etc.

The function accepts a metadata JSON as second parameter

<pre>
orientdb> <code class="lang-sql userinput">SELECT  EXPAND(SEARCH_CROSS('Author.name:bob Song.title:*tain', {"
   "allowLeadingWildcard" : true,
   "boost": {
        "Author.name": 2.0
        }
   }
)
</code>
</pre>

Highlight isn't supported yet.

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

* indexWriterConfig : https://lucene.apache.org/core/6_6_0/core/org/apache/lucene/index/IndexWriterConfig.html
* indexWriter: https://lucene.apache.org/core/6_6_0/core/org/apache/lucene/index/IndexWriter.html

## Index lifecycle

Lucene indexes are lazy. If the index is in idle mode, no reads and no writes, it will be closed.
Intervals are fully configurable.

* *flushIndexInterval*: flushing index interval in milliseconds, default to 20000 (10s)
* *closeAfterInterval*: closing index interval in milliseconds, default to 120000 (12m)
* *firstFlushAfter*: first flush time in milliseconds, default to 10000 (10s)

To configure the index lifecycle, just pass the parameters in the JSON of metadata:

<pre>
<code class="lang-sql userinput">CREATE INDEX City.name ON City(name) FULLTEXT ENGINE LUCENE METADATA
{
  "flushIndexInterval": 200000,
  "closeAfterInterval": 200000,
  "firstFlushAfter": 20000
}
</code>
</pre>

## Create index using the Java API

The FullText Index with the Lucene Engine is configurable through the Java API.

<pre><code class="lang-java">
    OSchema schema = databaseDocumentTx.getMetadata().getSchema();
    OClass oClass = schema.createClass("Foo");
    oClass.createProperty("name", OType.STRING);
    oClass.createIndex("City.name", "FULLTEXT", null, null, "LUCENE", new String[] { "name"});
</code>
</pre>


### The LUCENE operator (deprecated)

_NOTE_: *LUCENE* operator is translated to *SEARCH_FIELDS* function, but it doesn't support the metadata JSON

You can query the Lucene FullText Index using the custom operator `LUCENE` with the [Query Parser Syntax](http://lucene.apache.org/core/6_3_0/queryparser/org/apache/lucene/queryparser/classic/package-summary.html#package_description) from the Lucene Engine.

<pre>
orientdb> <code class='lang-sql userinput'>SELECT FROM V WHERE name LUCENE "test*"</code>
</pre>

This query searches for `test`, `tests`, `tester`, and so on from the property `name` of the class `V`.
The query can use proximity operator _~_, the required (_+_) and prohibit (_-_) operators, phrase queries, regexp queries:

<pre>
orientdb> <code class='lang-sql userinput'>SELECT FROM Article WHERE content LUCENE "(+graph -rdbms) AND +cloud"</code>
</pre>


### Working with multiple fields (deprecated)

_NOTE_: define a single Lucene index on the class and use *SEARCH_CLASS* function

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


## Creating a Manual Lucene Index (deprecated)

_NOTE_: avoid manual Lucene index

The Lucene Engine supports index creation without the need for a class.

**Syntax**:

```sql
CREATE INDEX <name> FULLTEXT ENGINE LUCENE  [<key-type>] [METADATA {<metadata>}]
```

For example, create a manual index using the [`CREATE INDEX`](../sql/SQL-Create-Index.md) command:

<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX Manual FULLTEXT ENGINE LUCENE STRING, STRING</code>
</pre>

Once you have created the index `Manual`, you can insert values in index using the [`INSERT INTO INDEX:...`](../sql/SQL-Insert.md) command.

<pre>
orientdb> <code class="lang-sql userinput">INSERT INTO INDEX:Manual (key, rid) VALUES(['Enrico', 'Rome'], #5:0)</code>
</pre>

You can then query the index through [`SELECT...FROM INDEX:`](../sql/SQL-Query.md):

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
