<!-- proofread 2015-12-10 SAM -->

# FullText Indexes

The SB-Tree index algorithm provides support for FullText indexes.  These indexes allow you to index text as a single word and its radix.  FullText indexes are like having a search engine on your database.

>**NOTE**: Bear in mind that there is a difference between `FULLTEXT` without the `LUCENE` operator, which uses a FullText index with the SB-Tree index algorithm and `FULLTEXT` with the `LUCENE` operator, which uses a FullText index through the Lucene Engine.
>
>For more information on the latter, see [Lucene FullText Index](Full-Text-Index.md).


## Creating FullText Indexes

If you want to create an index using the FullText SB-Tree index algorithm, you can do so using the [`CREATE INDEX`](SQL-Create-Index.md) command.

<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX City.name ON City(name) FULLTEXT</code>
</pre>

This creates a FullText index on the property `name` of the class `City`, using the default configuration.  

### FullText Index Parameters

In the event that the default FullText Index configuration is not sufficient to your needs, there are a number of parameters available to fine tune how it generates the index.

|Parameter|Default|Description|
|---------|-------------|-------------|
|`indexRadix`|`TRUE`|Word prefixes will be also index|
|`ignoreChars`|`"`|Chars to skip when indexing|
|`separatorChars`|` \r\n\t:;,.&#124;+*/\=!?[](.md)`||
|`minWordLength`|`3`|Minimum word length to index|
|`stopWords`|`the in a at as and or for his her him this that what which while up with be was were is`|Stop words escluded from indexing|

To configure a FullText Index, from version 1.7 on, you can do so through the OrientDB console or the Java API.  When configuring the index from the console, use the [`CREATE INDEX`](SQL-Create-Index.md) command with the `METADATA` operator.

<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX City.name ON City(name) FULLTEXT METADATA 
          {"indexRadix": true, "ignoreChars": "&", "separatorChars": " |()", 
          "minWordLength": 4, "stopWords": ["the", "of"]}</code>
</pre>

Alternatively, you can configure the index in Java.

```java
OSchema schema = db.getMetadata().getSchema();
OClass city = schema.getClass("City");
ODocument metadata = new ODocument();
metadata.field("indexRadix", true);
metadata.field("stopWords", Arrays.asList(new String[] { "the", "in", "a", "at" }));
metadata.field("separatorChars", " :;?[](.md)");
metadata.field("ignoreChars", "$&");
metadata.field("minWordLength", 5);
city.createIndex("City.name", "FULLTEXT", null, metadata, null, new String[] { "name" });
```
