---
search:
   keywords: ['Java API', 'OClass', 'class', 'count records', 'count']
---

# OClass - count()

This method counts the number of the records of this class.  It also considers the records in subclasses.

## Counting Records

When you create records on the database, they're created as part of a database class.  Using this method you can retrieve a count of all records created on the given class.  By default, it includes all subclasses.  You can also pass it a [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) instance to define whether you want it to exclude subclass records.

### Syntax

```
// METHOD 1
Long OClass().count() 

// METHOD 2
Long OClass().count(Boolean isPolymorphic)
```

| Argument | Type | Description |
|---|---|---|
| **`isPolymorphic`** | [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Determines whether method includes records of subclasses in the count |

#### Return Value

This method returns a [`Long`]({{ book.javase }}/api/java/lang/Long.html) instance, which provides the number of records in the database class or class and subclasses.


