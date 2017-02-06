# Manipulating MultiModel Data in Java 

**(since v 3.0)** 

### Basic Data Model

This is the basic data hierarchy in OrientDB. Each document, vertex, edge or BLOB in the database
will be represented in Java as an object in this hierarchy.

![AddVertex1](images/ORecordHierarchy.png)

- **ORecord**: this is a pre-existing interface, common to all the persistent records.
  Its main goal is to provide an abstraction to obtain low level information (eg. identity) and behavior 
  (eg. save and delete) for persistent entries  
- **OBlob**: represents BLOB (binary) records
- **OElement**: represents plain documents (so also vertices and edges). It includes methods
  to manipulate properties and to check if current element is a vertex or an edge.
  
  *Attention: until v 2.2 the Document API relied on ODocument class only. ODocument is still there
  as the main implementation of OElement, but please don't use it directly, always use OElement instead*
- **OVertex**: is the basic interface for vertices, it includes methods to manipulate and traverse connected edges and vertices
- **OEdge**: is the basic interface for edges, it includes methods to retrieve info regarding connected vertices

An ORecord has an identity and a version number, for the basic details see [Basic Concepts](Concepts.md)


### Creating a document

`ODatabaseDocument` class provides the following methods to create plain documents:

- `newInstance(String)`: creates a basic OElement of a given class.
- `newInstance()`: creates a basic OElement, with no schema associated (no Class). This method 
 should be used only to create embedded documents, not to create stand-alone documents.

To make the element persistent, you have to invoke the save() method on it. 

If you are NOT in a transaction, the document will be made persistent IMMEDIATELY when you call the `save()` method.
 
If you are in a transaction, you have to invoke `save()` and then `commit()` to make the document persistent.  

##### Basic usage:

```java
ODatabaseDocument db = ... 
OElement element = db.newInstance("Person");
element.setProperty("name", "John");
element.save();
```

##### Document lifecycle - non transactional:

```java
ODatabaseDocument db = ... //transaction not begun

OElement element = db.newInstance("Person");

//at this stage the record is not yet persistent

System.out.println(element.getIdentity()); //this will print a temporary RID (negative cluster position)

element.save();

//the element is now persistent

System.out.println(element.getIdentity()); //this will print the valid, final RID for that document.

```

##### Document lifecycle - transactional:


example 1:

```java
ODatabaseDocument db = ... 
db.begin()

OElement element = db.newInstance("Person");

//at this stage the record is not yet persistent

System.out.println(element.getIdentity()); //this will print a temporary RID (negative cluster position)

element.save();

//at this stage the record is not yet persistent

System.out.println(element.getIdentity()); //this will print a temporary RID 

db.commit();

//the element is now persistent

System.out.println(element.getIdentity()); //this will print the valid, final RID for that document.

```


example 2:

```java
ODatabaseDocument db = ... 
db.begin()

OElement element = db.newInstance("Person");

//at this stage the record is not yet persistent

System.out.println(element.getIdentity()); //this will print a temporary RID (negative cluster position)

// element.save(); FORGET TO SAVE

//at this stage the record is not yet persistent

System.out.println(element.getIdentity()); //this will print a temporary RID 

db.commit();

//The record is STILL NOT PERSISTENT, you forgot to invoke element.save();

System.out.println(element.getIdentity()); //This still returns a temporary RID

```


##### Links, document trees and save()

Documents can be linked together, ie. a property of a document can be a link to another document:

```java
OElement doc1 = db.newInstance("Person");
OElement doc2 = db.newInstance("Person");
doc1.setProperty("theLink", doc2);    
```

When doing save/commit operations, OrientDB manages a tree of connected documents as a single persistent entity.

When you invoke the save() method on a document, OrientDB will save all the documents that are in the same tree. In the example above
  both `doc1` and `doc2` will be saved. If you change the example as follows:
  
```java
OElement doc1 = db.newInstance("Person");
OElement doc2 = db.newInstance("Person");
doc2.setProperty("theLink", doc2); //see doc2.save() instead of doc1.save()    
```

the result will be exactly the same, both documents will be saved


### Loading and Reloading documents

You can load one or more documents from the database in two different ways:
- executing a query (see [Query API](Java-Query-API.md))
- using the `db.load(RID)` API

If you know the RID of a document, you can load it from the DB as follows:

```java
ORID theRid = new ORecordId("#12:0");
OElement doc = db.load(theRid);
```

Sometimes you can have a reference to a document that, in the meantime, was modified by another user/process.

You can reload the record from the database (ie. fetch its updated state) using the `reload()` method:

```java
OElement doc =  ... // an old version of the record
doc.reload();
```


### Properties

A document can have properties. A property is a key/value pair, where the key is a string and the value is one of the [Supported Types](Types.md) 

OElement interface provides methods to set and retrieve property values and names.

##### Property name syntax

Any string is a valid property name, except:
- `@rid` (upper or lowercase) 
- `@class` (upper or lowercase)
- `@version` (upper or lowercase)
- empty string

A string name can also contain numbers, blank spaces, punctation and special characters.

> IMPORTANT: please refer to [SQL Syntax](SQL-Syntax.md) for details on how to escape property names including special characters when
writing SQL statements

The following are valid instructions:

```java
OElement doc = db.newInstance("Person");
doc.setProperty("name", "John");
doc.setProperty("12", "foo");
doc.setProperty("foo.bar", "baz");
doc.setProperty("foo", "zzz");

System.out.println(doc.getProperty("name")); //prints "John"
```

> IMPORTANT: **Lecagy ODocument API** and differences with current API.

> Until v 2.2 ODocument had a differt API to set and access property values:
   ```java
   ODocument doc = ...
   doc.field("name", "John");
   String value = doc.field("name");
   ```
> That API did not allow to have special characters in property names, in particular, dot notation was used to traverse links
  or to retrieve values from embedded documents. 
> See this example to understand the difference:
   ```java
   //LEGACY API
   ODocument doc = ...
   doc.field("foo.bar", "value1");
   System.out.println(doc.field("foo.bar")); // prints nothing - fails silently
   
   ODocument embedded = new ODocument();
   embedded.field("bar", "value2");
   doc.field("foo", embedded);
   System.out.println(doc.field("foo.bar")); // prints "value1"
   ```
   
   ```java
   // NEW API
   OElement element = ...
   element.setProperty("foo.bar", "value1");
   System.out.println(doc.getProperty("foo.bar")); // "value1"
   
   OElement embedded = db.newInstance();
   embedded.setProperty("bar", "value2");
   doc.setProperty("foo", embedded);
   
   System.out.println(doc.getProperty("foo.bar")); // still prints "value1"
   System.out.println(((OElement)doc.getProperty("foo")).getProperty("bar")); // prints "value2"
   ```

  
##### Setting a property value

The basic way to set a property value on a document is using `setProperty(String, Object)` method:

```java
OElement doc = db.newInstance("Person");
doc.setProperty("name", "John");
doc.setProperty("age", 35);
doc.setProperty("tags", new String[]{"foo", "bar", "baz"});
```

Setting a property value multiple times, just overwrites the property value.

When working schemaless (see [Schema](Schema.md)), property values are saved without conversion:
- basic types (numbers, strings, boolean) are save as is
- document properties (eg. `doc1.setProperty("parent", doc2);`) are saved as links
- collections and maps of basic types are saved as is
- collections and maps of documents are saved as link lists or link sets (based on the collection type)

When working schemaful, OrientDB will try to do a conversion of types to fit the schema type. Eg. if you have a property defined as 
LONG in the schema and you set an Integer value on it, the Integer will be converted to Long. If a proprety is defined as EMBEDDED,
setting a document as its value will result in saving the document as an embedded document. 
If for some reason the conversion cannot be applied, at save time OrientDB will throw an `OValidationException`

##### Setting a property value with explicit type

OElement also provides a method to explicitly control the type of the property value:  `setProperty(String, Object, OType)`.
This is particularly useful when you do not have a schema but you want to perform specific checks or you want to save embedded
documents.

Eg. to set a property value as an embedded document, without definint the schema, you have to do the following:

```java
OElement doc = db.newInstance("Person");
doc.setProperty("name", "John");

OElement address = db.newInstance();
address.setProperty("city", "London");
address.setProperty("street", "Foo");

doc.setProperty("address", address, OType.EMBEDDED);
```

##### Getting document content

You can retrieve document property values using `getProperty(String)` method. eg.

```java
OElement doc = ...
String name = doc.getProperty("name");
```

If you don't know which properties are defined for a specific document, you can use `getPropertyNames()` to retrieve all their names.


```java
OElement doc = ...
for(String propertyName: doc.getPropertyNames()){
  Object value = doc.getProperty(propertyName);
  ...
}  
```

`getPropertyNames()` returns only the properties that are defined (ie. that have a value) for a specific document. It does not
rely on the schema, so if you have a property defined in the schema for that particular document, but that document does not have
a value for that specific property, it won't be returned by `getPropertyNames()`.


### Vertices and Edges

Vertices and Edges in OrientDB are just plain documents, with the addition of particular capabilities to enforce a graph structure.

An `OVertex` represents a node in the graph, while an `OEdge` represents a connection between exactly two vertices.
 
##### Creating a Vertex
 
ODatabaseDocument provides a specific API to create vertices, that is `newVertex(String)`. The String parameter represents a class 
name (the type of the vertex). There is also a short version,  `newVertex()`, that is an alias for `newVertex("V")`.

> IMPORTANT: the class passed as parameter to `newVertex()` has to be V or a subclass of V.

Here is an example on how to create a vertex
```java
ODatabaseDocument db ...
OVertex v = db.newVertex("Person");
```


##### Creating an Edge

Creating an edge means connecting two vertices together, so the entry point API to create an edge is `OVertex.addEdge()`.

Here is an example on how to use it:

```java
OVertex v1 = ...
OVertex v2 = ...
v1.addEdge(v2);
```

This will create an edge of type `E`, that is the base class for edges. If you want to create an edge of a specific class, you can use
`addEdge(OVertex, String)` where the String parameter is the class name, or `addEdge(OVertex, OClass)`, eg.

```java
OVertex v1 = ...
OVertex v2 = ...
v1.addEdge(v2, "FriendOf");
```

> IMPORTANT: the class passed as parameter to `addEdge()` has to be E or a subclass of E.


##### Vertex and Edge lifecycle

Vertices and edges are just plain documents; each vertex links to its edges and each edge links to the two connected vertices. 
This said the normal document save lifecycle applies, ie. when you have a graph of vertices and edges connected together, if you
invoke save() method on one of the elements, all the connected graph is saved.
 
##### Deleting vertices and edges

A graph is considered consistent all the edges are connected to exactly two vertices (from/to). This means that you cannot have edges that have one or both ends
disconnected from valid vertices.

OrientDB will manage graph consistency for you, that means that if you delete a vertex, all the connected edges will be deleted as well;
if you delete an edge, all the connected vertices will be updated to remove the references to that edge.

To delete a graph element, you can just use the `OElement` `delete()` method.


##### Traversing the graph

`OVertex` and `OEdge` classes provide methods to traverse the graph, ie. to access adjacent vertices and edges

Given an OVertex, you can retrieve all the connected **edges** using `getEdges(ODirection)`, `getEdges(ODirection, String...)` methods. The 
`ODirection` can be `ODirection.OUT` (outgoing edges), `ODirection.IN` (incoming edges), `ODirection.BOTH` (all the edges, regardless
the direction). The String parameter allows to filter on **edge** class names; you can specify multiple edge class names, you will
traverse all the edges that belong to at least one of the classes you specified.

```java
OVertex v = ...

Iterable<OEdge> edges = v.getEdges(ODirection.OUT, "FriendOf");
for(OEdge friendship: edges){
  Date friendsSince = friendship.getProperty("since");
}
```

Given an OVertex, you can retrieve all the connected **vertices** using `getVertices(ODirection)`, `getVertices(ODirection, String...)` methods. The 
`ODirection` can be `ODirection.OUT` (traverse outgoing edges), `ODirection.IN` (traverse incoming edges), `ODirection.BOTH` (traverse all the edges, regardless
the direction). The String parameter allows to filter on **edge** class names; you can specify multiple edge class names, you will
traverse all the edges that belong to at least one of the classes you specified.


```java
OVertex v = ...

Iterable<OVertex> friends = v.getVertices(ODirection.OUT, "FriendOf");
for(OVertex friend: friends){
  String friendName = friend.getProperty("name");
}
```

The OEdge interface provides methods to retrieve the connected vertices: 
- the entry point of the edge: `getFrom()`
- the end point of the edge: `getTo()`

```java
OEdge e = ...

OVertex from = e.getFrom();
OVertex to = e.getTo();

System.out.println("the edge starts from "+from+ " and ends to "+to);
```


##### Checking document/graph type

`OElement` interface provides methods to check whether current document is also a vertex (`isVertex()`)or an edge (`isEdge()`). It 
also provides methods to obtain an OVertex (`asVertex()`) or OEdge (`asEdge()`) instance from an OElement. These methods return
a Java `Optional<?>` that is empty if the element is not a vertex or an edge.


```java
OElement elem = ...
if(elem.isVetrtex()){
  Optional<OVertex> v = element.asVertex();
  System.out.println("The element "+v.get()+" is a vertex!");  
}

```
or, with a Java 8 lambda:

```java
OElement elem = ...
elem.asVertex().ifPresent(v -> System.out.println("The element "+v+" is a vertex!"));
```