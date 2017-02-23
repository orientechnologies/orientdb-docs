# Java Query API 
 
**(since v 3.0)**


### Querying the database in SQL

ODatabaseDocument provides some methods interact with the database via SQL statements and scripts:

```java
  OResultSet query(String query, Object... positionalParamas)
  OResultSet query(String query, Map namedParams);

  OResultSet command(String query, Object... positionalParams);
  OResultSet command(String query, Map namedParams);
  
  OResultSet execute(String language, String script, Object... positionalParams);
  OResultSet execute(String language, String script, Map namedParams);
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


### Query parameters

Building SQL statements as a string concatenation is universally recognized as a dangerous practice.
 
See an example:

```java
String name = ...
String stm = "SELECT FROM V WHERE name = '"+name+"'";
OResultSet rs = db.query(statement);
```

Apart from being hard to read, this query could also lead to SQL injection, based on the value of the `name` variable.

OrientDB allows to avoid string concatenation for parameter values, using named or positional parameters.
 
####Named Parameters

A named parameter is defined as an identifier preceded by a colon, eg. `:parameter1`  

An example is following:
```java
String stm = "SELECT FROM V WHERE name = :name and surname = :surname";
```

The named parameters have to passed to the query API (`command()` or `query()`) as a `Map<String, Object>`, where the key is the
parameter name (without the colon) and the value is the parameter value, eg.

```java
Map<String, Object> params = new HashMap<>();
params.put("name", "John");
params.put("surname", "Smith");

String stm = "SELECT FROM V WHERE name = :name and surname = :surname";
OResultSet rs = db.query(stm, params);
```

The same named parameter can be used muliple times in the same statement, eg. the following is valid:

```java
Map<String, Object> params = new HashMap<>();
params.put("name", "John");

String stm = "SELECT FROM V WHERE name = :name and surname = :name";
OResultSet rs = db.query(stm, params);
```


####Positional Parameters

A positional parameter is identified by a `?`, eg.

```java
String stm = "SELECT FROM V WHERE name = ? and surname = ?";
```

Positional parameters are passed to the query API as an `Object[]` or simply as java varArgs, eg.
 
```java
String stm = "SELECT FROM V WHERE name = ? and surname = ?";
OResultSet rs = db.query(stm, "John", "Smith");
```

The order of the parameters is defined as the exact order as they appear in the string.
If you have subqueries, the order of the parameters is still defined by the order in the string, eg.

```java
String stm = "SELECT FROM V WHERE name = ? and city in (SELECT FROM CITY WHERE cityName = ?) and surname = ?";
OResultSet rs = db.query(stm, "John", "London", "Smith");
```

In this query the first parameter refers to `name = ?`, the second one refers to `cityName = ?` and the third one refers to 
`surname = ?`
 


### OResult

The OResult interface represents a row in the result-set.

An OResult instance can represent an element with an identity (a document, a vertex or an edge) 
or a projection.


The content (the properties) of an OResult can be retrieved using `getProperty(String)`. OResult also
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
- toElement() acts the same as getElement() (apart from the Optional) when the result of getElement() is not empty. In case it's not true,
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

It is important to always close result sets, even when they are converted to streams (after the stream is consumed).



### Batch Scripts

The `db.execute()` API is intended to execute scripts (SQL by default, but it can be extended to other languages - like Gremiln - 
with external plugins).
 
Here is an example on how to run a SQL script from Java API:

```java
ODatabaseDocument db;
...
String script = 
"BEGIN;"+
"LET $a = CREATE VERTEX V SET name = 'a';"+
"LET $b = CREATE VERTEX V SET name = 'b';"+
"LET $edge = CREATE EDGE E from $a to $b;"+
"COMMIT;"+
"RETURN $edge;";

OResultSet rs = db.execute("sql", script);
while(rs.hasNext()){
  OResult row = rs.next();
  ...
}
rs.close();

```

> IMPORTANT: the semicolon (`;`) at the end of each SQL statement is **mandatory**  

> IMPORTANT: if you are migrating from previous versions, please consider that until v 2.2 the newline was a valid delimiter for SQL statements in a script (the semicolon was not mandatory); in v 3.0 a single statement in a script can be split on multiple lines. 


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



