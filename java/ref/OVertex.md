---
search:
   keywords: ['Java API', 'OVertex', 'vertex']
---

# Java API - OVertex

This class provides a standard interface for handling vertices.

## Managing Vertices

When using OrientDB as a Graph database, this class represents a vertex record.  It extends the [`OElement`](OElement.md) class.  Methods available to that class are also available to this class.

This class is available at `com.orientechnologies.orient.core.record`.  To import it, use the following line where necessary:

```java
import com.orientechnologies.orient.core.record.OVertex;
```

Once you've imported the class to your application, you can use it to build instances in your code.

>For more infomration on edges, see [`OEdge`](OEdge.md)

### Example

To create a new instance of this class, it is recommended that you use either the [`newInstance()`](ODatabaseDocument/newInstance.md) or [`newVertex()`](ODatabaseDocument/newVertex.md) methods on the [`ODatabaseDocument`](ODatabaseDocument.md) class interface.  This allows you to operate on the given record and to easily save it back to the database when you're ready.

[TBD]

## Methods

Once you've created or initialized an `OVertex` instance, you can begin to call methods on it to further define and read data from the vertex.  This method extends the [`OElement`](OElement.md) class.  Methods available to that class are also available to this one.

| Method | Return Type | Description |
|---|---|---|
| [**`addEdge()`**](OVertex/addEdge.md) | [`OEdge`](OEdge.md) | Adds an edge to the vertex |
| [**`getEdges()`**](OVertex/getEdges.md) | [`Iterable`]({{ book.javase }}/api/java/lang/Iterable.html)[`<OEdge>`](OEdge.md) | Retrieve connected edges |
| [**`getVertices()`**](OVertex/getVertices.md) | [`Iterable`]({{ book.javase }}/api/java/lang/Iterable.html)`<OVertex>` | Retrieve connected vertices |
| [**`save()`**](#saving-vertices) | `<RET extends ORecord> RET` | Saves changes to the database |

### Saving Vertices 

When you create or retrieve an `OVertex` instance, you create a snapshot of the record.  Any changes you make to the record remain in your application.  In order to make these changes persistent on the database, you need to call the `save()` method on the element.  For instance,

```java
// GLOBAL VARIABLES
private ODatabaseDocument db;

// CREATE NEW RECORD
public void newRecord(String name, String email){

   // Initialize Document
   OVertex person = db.newVertex("Person");
   person.setProperty("name", name);
   person.setProeprty("email", email);

   // Add Person to Database
   person.save();
}
```

