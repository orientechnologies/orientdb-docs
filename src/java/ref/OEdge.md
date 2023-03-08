
# Java API - OEdge

This class provides a standard interface for handling edges.

## Managing Edges

When using OrientDB as a Graph database, this class represents an edge record.  It extends the [`OElement`](OElement.md) class.  Methods available to that class are also available to this class.

This class is available at `com.orientechnologies.orient.core.record`.  To import it, use the following line where necessary:

```java
import com.orientechnologies.orient.core.record.OEdge;
```

Once you've imported the class to your application, you can use it to build instances in your code.

>For more information on vertices, see [`OVertex`](OVertex.md)


### Example

To create a new instance of this class, it is recommended that you use either the [`newInstance()`](ODatabaseDocument/newInstance.md) or [`newEdge()`](ODatabaseDocument/newEdge.md) methods on the [`ODatabaseDocument`](ODatabaseDocument.md) class interface.  This allows you to operate on the given record and to easily save it back to the database when you're ready.

[TBD]

## Methods

Once you've created or initialized an `OEdge` instance, you can begin to call methods on it to further define and read data from the edge.  This method extends the [`OElement`](OElement.md) class.  Methods available to that class are also available to this one.

For information on methods specific to this class, see the table below.

| Method | Return Type | Description |
|---|---|---|
| [**`getFrom()`**](OEdge/getFrom.md) | [`OVertex`](OVertex.md) | Retrieves the from vertex |
| [**`getTo()`**](OEdge/getTo.md) | [`OVertex`](OVertex.md) | Retrieves the to vertex |
| [**`isLightweight()`**](OEdge/isLightweight.md) | [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Determines whether the edge is a Lightweight Edge |
| [**`save()`**](#saving-edges) | `<RET extends ORecord> RET` | Saves changes to the database |

### Saving Edges 

When you create or retrieve an `OEdge` instance, you create a snapshot of the record.  Any changes you make to the record remain in your application.  In order to make these changes persistent on the database, you need to call the `save()` method on the element.  For instance,

```java
// GLOBAL VARIABLES
private ODatabaseDocument db;

// CREATE NEW RECORD
public void newEdge(OVertex toPerson, OVertex fromPerson){

   // Initialize Document
   OEdge relationship = db.newEdge("Relationship");
   relationship.setProperty("out", toPerson);
   relationship.setProperty("in", fromPerson);

   // Add Relationship to Database 
   relationship.save();
}
```

