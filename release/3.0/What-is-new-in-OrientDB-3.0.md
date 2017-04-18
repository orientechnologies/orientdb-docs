
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

### Support streaming of query result set

### Integration with Tinker Pop 3.x

OrientDB v3.0 is compliant with TinkerPop 3.x through an external plugin.

### Integration with Tinker Pop 2.x

OrientDB v3.0 is backward compatible with TinkerPop 2.6.x API through an external plugin. If you built your application with OrientDB 2.2 or minor and you don't want to migrate to the new API (the new Multi-Model or the new TinkerPop 3.x APIs), then download the version with TP2 plugin included.

### Externalization of object API

The Object Database API are now part of a separate module. If your existent application is using it, please include this module. For new application we don't suggest to use the Object Database API, but rather the new Multi-Model API.

### Improvements of storage caching for reduce latency


### New Demo DB 'Social Travel Agency'

Starting with OrientDB v.3.0 a new demo database is included. More information on the new demo database can be found [here](../../gettingstarted/demodb/README.md).
