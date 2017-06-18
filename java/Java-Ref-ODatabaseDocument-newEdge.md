---
search:
   keywords: ['java', 'ODatabaseDocument', 'new edge', 'newEdge']
---

# ODatabaseDocument - newEdge()

This method creates a new edge between the given vertices.

## Creating Edges

When using OrientDB as a Graph database, this method allows you to create new edges on the database and connect them to related vertices.  To create new vertices on the database, see the [`newVertex()`](Java-Ref-ODatabaseDocument-newVertex.md) method.

### Syntax

There are a few different versions available when using this method:

```
// METHOD 1
default OEdge ODatabaseDocument().newEdge(OVertex fromV, OVertex toV)

// METHOD 2
OEdge ODatabaseDocument().newEdge(OVertex fromV, OVertex toV, OClass class)

// METHOD 3
OEdge ODatabaseDocument().newEdge(OVertex fromV, OVertex toV, String class-name)
```

Edges have their own classes in OrientDB.  When using the first method, the edge is created using the default `E` class.  The other methods allow you to set the specific edge class that you want to use.


| Argument | Type | Description
|---|---|---|
| **`fromV`** | `OVertex` | Defines the vertex this edge comes from |
| **`toV`** | `OVertex` | Defines the vertex this edge points to |
| **`class`** | `OEdge` | Defines the edge class |
| **`class-name`** | [`String`]({{ book.javase }}/api/java/lang/String.html)  | Defines the edge class |


#### Return Value

This method returns an `OEdge` instance of the edge it creates.

### Example

Imagine an application that makes frequent use a particular edge class.  You might find it convenient to write a method that automatically calls that class by default when creating new edges.For instance, in a class handling social network accounts:

```java
// INITIALIZE VARIABLES
private static String edgeClass = "subscription"; 
private ODatabaseDocument db;
...

// SUBSCRIBE TO USER'S BLOG
public void subscribe(OVertex subscriber, OVertex publisher){

   db.newEdge(subscriber, publisher, edgeClass); 

}
```
