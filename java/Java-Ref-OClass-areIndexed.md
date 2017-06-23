---
search:
   keywords: ['Java API', 'OClass', 'index', 'areIndexed']
---

# OClass - areIndexed()

This method determines whether the given fields are contained as first key fields in the database class indexes. 

## Checking Indexes

OrientDB provides support for several different kinds of indexes, which you can use to improve database performance on queries.  With this method, you can check a series of fields in the database class to determine whether any are contained as first key fields in the class indexes.

### Syntax

```
// METHOD 1
Boolean OClass().areIndexed(Collection<String>  colFields)

// METHOD 2
Boolean OClass().areIndexed(String... strFields)
```

| Argument | Type | Description |
|---|---|---|
| **`colFields`** | [`Collection`]({{ book.javase }}/api/java/util/Collection.html)[`<String>`]({{ book.javase/api/java/lang/String.html) | Defines a collection of fields to check |
| **`strFields`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines fields to check |

#### Return Value

This method returns a [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) instance.  If the return value is `true`, it inidcates that the the given fields are contained as first key fields in the database class indexes.

