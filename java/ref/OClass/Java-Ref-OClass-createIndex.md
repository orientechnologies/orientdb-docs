---
search:
   keywords: ['Java API', 'OClass', 'index', 'OIndex']
---

# OClass - createIndex()

This method creates an index on the given fields.

## Creating Indexes

OrientDB provides support for several different types of indexes, which can help improve performance in retrieving records.  Using this method, you can create them on a particular class, indexing the given fields (that is, properties), on the class.


### Syntax

```
// METHOD 1
OIndex<?> OClass().createIndex(String name,
	OClass.INDEX_TYPE type,
	String... fields)

// METHOD 2
OIndex<?> OClass().createIndex(String name, 
	String type-name, 
	OProgressListener listener,
	ODocument metadata, 
	String... fields)

// METHOD 3
OIndex<?> OClass().createIndex(String name, 
	String type-name,
	OProgressListener listener
	ODocument metadata,
	String algorithm,
	String... fields)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the index name |
| **`type`** | `OClass.INDEX_TYPE` | Defines the index type |
| **`fields`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the fields to index |
| **`type-name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the index type, as a string |
| **`listener`** | `OProgressListener` | Defines the progress listener for the index |
| **`metadata`** | `ODocument` | Defines metadata for the index |
| **`algorithm`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the algorithm to use |


#### Return Value

This method creates an index on the given properties for the class.  It then returns the index as an `OIndex` instance.
