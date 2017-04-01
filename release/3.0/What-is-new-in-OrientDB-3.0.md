
{% include "./include-warning-3.0.md" %}

## What's new in OrientDB 3.0?

### New database administration API

### New database access and pooling API

### Graph-document concepts unification in core API

**ODocument vs. OElement**

OrientDB v 3.0 has a new interface called OElement whose goal si to replace ODocument class as "the" public API for documents.
> We decided to leave ODocument as it is - a class, not an interface - to make migration easier, but we would have really liked to 
have ODocument interface

ODocument is still there, but now it implements OElement.

PLEASE, DO NOT USE ODocument, USE OElement instead

ODocument access API (`field(...)`) is now deprecated and replaced by a new API:
 
- `doc.getProperty(name)`: retrieves a property value
- `doc.setProperty(name, value)`: sets a property value
- `doc.getPropertyNames()`: returns all the property names for current document

Main differences with legacy API:

- characters allowed in property names: any character is allowed as a valid character in property names. 
  ```java
  doc.setProperty("foo.bar", "aaa"); //sets 'aaa' as a value of the property "foo.bar"
  doc.getProperty("foo.bar"); //retrieves the value of "foo.bar" property
  ```
  
  while in the legacy API the dot had the specific meaning of embedded field traversal
  
  ```java
  doc.field("foo.bar", "aaa"); //sets the "bar" property on "foo" embedded property, if any. Otherwise it does nothing
  doc.field("foo.bar"); //retrieves the value of "bar" property of the embedded property "foo"
  ```
  
  The same is for square brackets
  

**Core Graph API**

In v 3.0 TinkerPop is just an alternative graph API. The main graph API provided by OrientDB is in the Core module:

![AddVertex1](../../images/ORecordHierarchy.png)


### New execution plan based query engine

### Support for query on remote transactions

### Support straming of query result set

### Integration with Tinker Pop 3.x

### Integration with Tinker Pop 2.x

### Externalization of object API

### Improvements of storage caching for reduce latency


### New Demo DB 'Social Travel Agency'

Starting with OrientDB v.3.0 a new demo database is included. More information on the new demo database can be found [here](../../gettingstarted/demodb/README.md).
