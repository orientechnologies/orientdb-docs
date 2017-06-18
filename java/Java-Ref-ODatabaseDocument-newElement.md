---
search:
   keywords: ['java', 'ODatabaseDocument', 'new element']
---

# ODatabaseDocument - newElement()

This method creates a new record on the database.

## Creating Elements

When you use OrientDB to host a Document database, the [`OElement`](Java-Ref-OElement.md) class represents a document in the database.  With Graph databases, [`OElement`](Java-Ref-OElement.md) is the superclass to `OVertex` and `OEdge`.  This method allows you to create a new element within your application.   You can then set data on the element and save it to the database. 

>**NOTE**: In version 2.2.x and earlier, OrientDB Document databases used the `ODocument` class to represent documents.  While it still exists as the main implementation of [`OElement`](Java-Ref-OElement.md), it is recommended that you no longer use it directly.  Instead, from now on use the [`OElement`](Java-Ref-OElement.md) class for documents.

### Syntax

There are two methods available to you, one creates an empty element and the other creates the new element using a particular OrientDB class.

```
// METHOD 1
OElement ODatabaseDocument().newElement()

// METHOD 2
OElement ODatabaseDocument().newElement(String class)
```

| Argument | Type | Description |
|---|---|---|
| **`class`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the database class |

#### Return Value

This method returns an [`OElement`](Java-Ref-OElement.md) instance.  You can then call additional methods on the element to add and configure the data it contains.  When you are ready to make the changes persistent on OrientDB, call the [`save()`](Java-Ref-OElement.md#saving-elements) method on the element.

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
   OElement entry = db.newElement("BlogEntry");

   // Add Data
   entry.setProperty("title", title);
   entry.setProperty("author", author);
   entry.setProperty("text", text);
   entry.setProperty("publish", publish);

   // Update Database
   entry.save();

}
```
