---
search:
   keywords: ['Java API', 'OVertex', 'vertex']
---

# Java API - OVertex

This class provides a standard interface for handling vertices.

## Managing Vertices

When using OrientDB as a Graph database, this class represents a vertex record.  It extends the [`OElement`](Java-Ref-OElement.md) class.  Methods available to that class are also available to this class.

This class is available at `com.orientechnologies.orient.core.record`.  To import it, use the following line where necessary:

```java
import com.orientechnologies.orient.core.record.OVertex;
```

Once you've imported the class to your application, you can use it to build instances in your code.

>For more infomration on edges, see [`OEdge`](Java-Ref-OEdge.md)

### Example

To create a new instance of this class, it is recommended that you use either the [`newInstance()`](Java-Ref-ODatabaseDocument-newInstance.md) or [`newVertex()`](Java-Ref-ODatabaseDocument-newVertex.md) methods on the [`ODatabaseDocument`](Java-Ref-ODatabaseDocument.md) class interface.  This allows you to operate on the given record and to easily save it back to the database when you're ready.

[TBD]

## Methods

Once you've created or initialized an `OVertex` instance, you can begin to call methods on it to further define and read data from the vertex.  This method extends the [`OElement`](Java-Ref-OElement.md) class.  Methods available to that class are also available to this one.

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

