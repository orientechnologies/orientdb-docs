---
search:
   keywords: ['java', 'OElement', 'document', 'vertex', 'edge']
---

# Java API - OElement

This class provides a standard interface for handling documents, vertices and edges.


## Managing Elements

When using OrientDB as a Document database, this class represents a document record.  When using OrientDB as a Graph database, this is the superclass to the `OVertex` and `OEdge` classes, which represent vertices and edges in the database.

>**NOTE**: In older versions of OrientDB, documents were represented using the `ODocument` class.  While this class is still around and is the primary implementation of `OElement`, it is recommended that you do not use it directly.  Instead, moving forward use `OElement` for your documents.

This class is available at `com.orientechnologies.orient.core.record`.  To import it, use the following line where necessary:

```java
import com.orientechnologies.orient.core.record.OElement;
```

Once you've imported the class to your application, you can use it to build particular instances in your code.

### Example

In order to create a new instance of this class, it is recommended that you use either [`newInstance()`](Java-Ref-ODatabaseDocument-newInstance.md) or [`newElement()`](Java-Ref-ODatabaseDocument-newElement.md) methods on the [`ODatabaseDocument`](Java-Ref-ODatabaseDocument.md) class interface.  This allows you to operate on the given record and easily save it back to the database when you're ready. 

For instance, imagine you have a [`Map`]({{ book.javase }}/api/java/util/Map.html) of variables containing a address book, where the key is the person's name and the value their email address, both as [`string`]({{ book.javase }}/api/java/lang/String.html) values.  You might use a method like this to transfer that data into OrientDB documents.

```java
// INITIALIZE GLOBAL VARIABLES
private ODatabaseDocument db;
...

// ADD ENTRIES TO ADDRESSBOOK DATABASE
public void initAddressBook(Map<String, String> addressBook){

   // Loop Over Map
   for (Map.Entry<String, String> entry : addressBook.entrySet()){

      // Initialize Variables
	  String name = entry.getKey();
	  String email = entry.getKey();

	  // Create Person 
	  OElement person = db.newElement("Person");
	  person.setProperty("name", name);
	  person.setProperty("email", email);
	  
	  // Make Person Persistent
	  person.save();

   }
}
```

## Methods

Once you've created or initialized an `OElement` instance, you can begin to call methods on the instance to further define and read data from the record.

| Method | Return Type | Description |
|---|---|---|
| [**`asEdge()`**](Java-Ref-OElement-asEdge.md) | [`Optional`]({{ book.javase }}/api/java/util/Optional.html)`<OEdge>` | Returns record as an edge | 
| [**`asVertex()`**](Java-Ref-OElement-asVertex.md) | [`Optional`]({{ book.javase }}/api/java/util/Optional.html)`<OVertex>`| Returns record as a vertex |
| [**`getProperty()`**](Java-Ref-OElement-getProperty.md) | `<RET> RET` | Retrieves record data by property name |
| [**`getPropertyNames()`**](Java-Ref-OElement-getPropertyNames.md) | [`Set`]({{ book.javase }}/api/java/util/Set.html)[`<String>`]({{ book.javase }}/api/java/lang/String.html) | Retrieves defined property names |
| [**`getSchemaType()`**](Java-Ref-OElement-getSchemaType.md) | [`Optional`]({{ book.javase/api/java/util/Optional.html)`OClass` | Retrieves the type of the current element, (that is, class in the schema, if any) |
| [**`isEdge()`**](Java-Ref-OElement-isEdge.md) | [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Determines whether record is an edge |
| [**`isVertex()`**](Java-Ref-OElement-isVertex.md) | [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Determines whether record is a vertex |
| [**`removeProperty()`**](Java-Ref-OElement-removeProperty.md) | `<RET> RET` | Removes a property from the record |
| [**`save()`**](#saving-elements) | `<RET extends ORecord> RET` | Saves changes to OrientDB record |
| [**`setProperty()`**](Java-Ref-OElement-setProperty.md) | `void` | Sets data on record property |

### Saving Elements

When you create or retrieve an `OElement` instance, you create a snapshot of the record.  Any changes you make to the record remain in your application.  In order to make these changes persistent on the database, you need to call the `save()` method on the element.  For instance,

```java
// GLOBAL VARIABLES
private ODatabaseDocument db;

// CREATE NEW RECORD
public void newRecord(String name, String email){

   // Initialize Document
   OElement person = db.newElement("Person");
   person.setProperty("name", name);
   person.setProeprty("email", email);

   // Add Person to Database
   person.save();
}
```

