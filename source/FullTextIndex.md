# Full Text

Full Text indexes allow to index text as single word and its radix. Full text indexes are like a search engine on your database. If you are using the Lucene engine, please refer to [Lucene Full-Text index](Full-Text-Index.md).

### Create a FullText Index

Example:

```sql
CREATE INDEX City.name ON City (name) FULLTEXT
```

This will create a FullText index on the property name of the class City,
with default configuration.

#### Configuration parameters of FullText Index:

|Parameter|Default|Description|
|---------|-------------|-------------|
|`indexRadix`|`TRUE`|Word prefixes will be also index|
|`ignoreChars`|`"`|Chars to skip when indexing|
|`separatorChars`|` \r\n\t:;,.&#124;+*/\=!?[](.md)`||
|`minWordLength`|`3`|Minimum word length to index|
|`stopWords`|"the in a at as and or for his her him this that what which while up with be was were is"|Stop words escluded from indexing|

#### Configure a FullText Index (OrientDB v. 1.7)

To configure fulltext index use the metadata field.

Example with SQL:

```
CREATE INDEX City.name ON City (name) FULLTEXT METADATA {"indexRadix" : TRUE, "ignoreChars" : "&" , "separatorChars" : " |()", "minWordLength" : 4 , "stopWords" : ['the','of']}
```

Example with Java;
```
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
