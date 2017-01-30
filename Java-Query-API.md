# Java Query API 
 
**(since v 3.0)**


### Querying the database in SQL

ODatabaseDocument provides four methods to query the database:

```java
  OResultSet query(String query, Object... positionalParamas)
  OResultSet query(String query, Map namedParams);
  OResultSet command(String query, Object... positionalParams);
  OResultSet command(String query, Map namedParams);
```

`query()` methods are inteded to execute idempotent statements only (eg. SELECT, MATCH, TRAVERSE).

`command()` methods can execute any type of statements, idempotent (SELECT, MATCH...), non idempotent (INSERT, UPDATE, DELETE...) and
DDL (CREATE CLASS, CREATE PROPERTY...)

### Sample usage

The typical usage can be described with an exmaple

```java
ODatabaseDocument db;
...
String statement = "SELECT FROM V WHERE name = ? and surnanme = ?";
OResultSet rs = db.query(statement, "John", "Smith");
while(rs.hasNext()){
  OResult row = rs.next();
  Date birthDate = row.getProperty("birthDate");
  ...
}
rs.close();

```

### OResult

The OResult interface represents a row in the result-set.

An OResult instance can represent an element with an identity (a document, a vertex or an edge) 
or a projection.


The content (the properties) of an OResult can be retrieved using `getProperty()`. OResult also
provides a `getPropertyNames()` method that returns all the property names in current row.

You can extract a persistent entity from an OResult (in case it actyally represents a vertex, an edge or a document)
 using the following methods

```java
Optional<OElement> getElement()
Optional<OVertex> getVertex()
Optional<OEdge> getEdge()
```
All these methods return a Java Optional that will be empty if the OResult does not represent the specified type.

You can also transform any OResult in an OElement invoking 
```java
OElement toElement()
``` 
There is an important difference between `getElement()` and `toElement()`:
- getElement() returns a non-empty Optional<OElement> only if the OResult represents a persistent entity
- toElement() acts the same as getElement() when the result of getElement() is not empty. In case it's not true,
it returns a new (not yet persisted) OElement with the same properties as the OResult.


You can safely use OElement/Vertex/Edge instances to update data, as long as you have an open db connection, eg.

```java
ODatabaseDocument db;
...
String statement = "SELECT FROM V WHERE name = ? and surnanme = ?";
OResultSet rs = db.query(statement, "John", "Smith");
while(rs.hasNext()){
  rs.next().getVertex().ifPresent(x->{
                   x.setProperty("age", 40);
                   x.save();
                 });
}
rs.close();
```

### Streamin API
 
OResultSet provides an API to convert it to a Java 8 stream:

```
Stream<OResult> stream() 
Stream<OElement> elementStream()
Stream<OVertex> vertexStream()
Stream<OEdge> edgeStream()
```

IMPORTANT: please consider that the resulting streams **consume** the OResultSet.

`elementStream()`, `vertexStream()` and `edgeStream()` filter the stream returning only
the elements for which the corresponding `isElement/Vertex/Edge()` returns true;
  
Sample usage:
 
```java
ODatabaseDocument db;
...
String statement = "SELECT FROM V WHERE name = ? and surnanme = ?";
OResultSet rs = db.query(statement, "John", "Smith");
rs.stream().forEach(x -> System.out.println(x.getProperty("age")));
rs.close();
```
 
 
### Closing the OResultSet

OResultSet is implemented as a paginated structure, that holds some iterators open during the iteration.
This is true both in remote and in embedded usage.

You should always invoke OResultSet.close() at the end of the execution, to free resources.

OResultSet instances are automatically closed when you close the ODatabase that returned them.


###Legacy API

The legacy API is still there, but the methods are deprecated. It will be removed in 
next versions. 
It is available only in the ODatabaseDocumentTx implementation, with the following methods

```java
@deprecated
public <RET extends OCommandRequest> RET command(OCommandRequest iCommand)
@deprecated
public <RET extends List<?>> RET query(OQuery<?> iCommand, Object... iArgs)
```



