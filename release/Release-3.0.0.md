# Release 3.0.x

| | |
|----|-----|
|![](../images/warning.png)|OrientDB {{book.currentVersion}} is still in development. Please do not use it in production.|

## What's new?

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

![AddVertex1](../images/ORecordHierarchy.png)


### New execution plan based query engine

### Support for query on remote transactions

### Support straming of query result set

### Integration with Tinker Pop 3.x

### Integration with Tinker Pop 2.x

### Externalization of object API

### Improvements of storage caching for reduce latency


### New Demo DB 'Social Travel Agency'

Starting with OrientDB v.3.0 a new demo database is included. More information on the new demo database can be found [here](../gettingstarted/demodb/README.md).


## API Changes


 
**ODatabase hierarchy and factories**

TODO


**OProperty**

`OProperty.getFullName()` now returns ``` "`ClassName`.`propertyName`" ``` instead of ```"ClassName.propertyName"```


**OrientBaseGraph**

`setUseVertexFieldsForEdgeLabels(boolean)` is now deprecated and has no effect. All the edge labels are represented as edge classes.


## SQL Changes

### DISTINCT keyword

In v 2.2 the only way to have distinct values from a SELECT statement was using the `distinct()` function. 
In v 3.0 we introduced `DISTINCT` operator, that is much more flexible than `distinct()` function.
The following query is valid in v 3.0
 
```sql
SELECT DISTINCT name, surname from Person
```

`distinct()` function is still allowed, but it's deprecated

### eval() and mathematical expressions
 
Until v 2.2 the only way to execute mathematical operations in SQL was to use `eval(expression)` function:

```select
SELECT eval(' 3 + 2 ') as sum
```

In v 3.0 mathematical expressions are allowed in both projections and WHERE conditions, eg.

```select
SELECT 3 + 2 as sum

SELECT FROM V WHERE theNumber > 3 + 3
```

Please refer to [SQL syntax](../sql/SQL-Syntax.md) page for all the details 


### MATCH and DISTINCT

In v.2.2 the MATCH statement automatically filters duplicate result rows and there is no way
to specify a different behavior.

In v 3.0 the MATCH by default ALLOWS duplicate results, if you want only distinct results you have
to explicitly declare `RETURN DISTINCT ...`

The following statement in v.2.2

```
MATCH 
  {class:Person, as:a} -FriendOf-> {as:b}
RETURN a.name, b.name
```

is equivalent to v. 3.0

```
MATCH 
  {class:Person, as:a} -FriendOf-> {as:b}
RETURN DISTINCT a.name, b.name
```

### Changes in the CREATE INDEX statement
```sql
CREATE INDEX T.id UNIQUE
``` 
is not allowed anymore, please use 
```
CREATE INDEX T.id ON T(id) UNIQUE
``` 

instead

### Changes in the way batch script commands are separated

In v. 2.2 the newline is a valid statement separator in batch scripts.
Since 3.0 the only valid statement separator is the semicolon `;`.

In v 3.0 the following script is invalid

```sql
SELECT FROM V
SELECT FROM E
```

The following script is valid as well

```sql
SELECT FROM V
WHERE name = 'foo';
SELECT FROM E;
```

Please note that the first statement is split on two rows.

### EXPLAIN
BREAKING CHANGE: in v. 3.0 the EXPLAIN statement does not execute the statement anymore and does not
return information about execution statistics.

The EXPLAIN statement in v 3.0 returns details about the execution planning for the query, ie. all the steps
that the query executor will execute to calculate the query result.

### Changes in the CREATE EDGE statement

Starting from 3.0, it is mandatory to create the Edge class before executing the CREATE EDGE statement. If the Edge class does not exist the CREATE EDGE statement will fail (previously it was creating the Edge class automatically)


## Known Issues

- The 'Neo4j to OrientDB Importer' plugin has not been refactored to be compatible with OrientDB 3.0 yet.


## Migrating to 3.0.x

General information on how to upgrade OrientDB can be found in the [Upgrade](Upgrade.md) Chapter.

You may also be interested in checking the [Release Notes](Release-Notes.md).