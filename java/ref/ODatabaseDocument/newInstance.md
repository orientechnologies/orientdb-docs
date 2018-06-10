---
search:
   keywords: ['java', 'ODatabaseDocument', 'new instance']
---

# ODatabaseDocument - newInstance()

This method creates a new record on the database.

## Creating Elements

Whether you are using OrientDB to how a Document or Graph database, this method provides you with a generic way to create new documents, vertices or edges in your application.

### Syntax

```
<RET> RET ODatabaseDocument().newElement(String class)
```

| Argument | Type | Description |
|---|---|---|
| **`RET`** | | Defines the return value type |
| **`class`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the database class |

#### Return Value

This method returns an instance of the class given as a generic.  The particular class you choose depends on whether you're using OrientDB as a Graph or Document databases.  The recommended methods are:

- [**`OElement`**](Java-Ref-OElement.md) To represent documents in a Document database
- [**`OVertex`**](Java-Ref-OVertex.md) To represent vertices in a Graph database
- [**`OEdge`**](Java-Ref-OEdge.md) TO represent edges in a Graph database

You can then take the return value and call additional methods on it to set data.  To make the document, graph or vertex persistent on the database, you must then call the `save()` method.

### Example

Imagine that you have a web application hosting blogs.  You might want a method in the account management class to add new blog entries to OrientDB.

```java
private ODatabaseDocument db;

// ADD NEW BLOG ENTRY
public void createBlogEntry(String title, String author, 
         String text, Boolean publish){

   // Log Operation
   logger.info("Creating New Blog Entry");

   // Initialize Entry
   OElement entry = db.newInstance("BlogEntry");

   // Add Data
   entry.setProperty("title", title);
   entry.setProperty("author", author);
   entry.setProperty("text", text);
   entry.setProperty("publish", publish);

   // Update Database
   entry.save();

}

```
