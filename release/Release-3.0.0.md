# Release 3.0.x

## What's new?

### New database administration API

### New database access and pooling API

### Graph-document concepts unification in core API

### New execution plan based query engine

### Support for query on remote transactions

### Support straming of query result set

### Integration with Tinker Pop 3.x

### Integration with Tinker Pop 2.x

### Externalization of object API

### Improvements of storage caching for reduce latency


### New Demo DB `Demo-DB-SocialTravelAgency`

TODO

## API Changes

**OElement hierarchy**

TODO

**ODatabase hierarchy and factories**

TODO

**ODocument**

New APIs `ODocument.getProperty(name)` and `ODocument.setProperty(name, value)`  do not interprete the field name as an expression. 
Any character is allowed.

eg.

```java
ODocument doc = new ODocument();
doc.setProperty("foo.bar", 15); 

ODocument foo = new ODocument();
doc.setProperty("foo", foo);
foo.setProperty("bar", 30);

Integer thisIs15 = doc.getProperty("foo.bar"); //this evaluates the field whose name is `foo.bar`
Integer thisIs30 = doc.eval("foo.bar");  //this evaluates the expression `foo`.`bar`

```

IMPORTANT: in the near future `ODocument.field()` methods will be deprecated and replaced with `ODocument.get/setProperty()`


**OProperty**

`OProperty.getFullName()` now returns ``` "`ClassName`.`propertyName`" ``` instead of ```"ClassName.propertyName"```


**OrientBaseGraph**

`setUseVertexFieldsForEdgeLabels(boolean)` is now deprecated and has no effect. All the edge labels are represented as edge classes.


## SQL Changes

CREATE INDEX T.id UNIQUE won't work anymore --> CREATE INDEX T.id ON T(id) UNIQUE is needed

batch

statement1
statement2

wont' work anymore --> add ; after a statement

## Migration from 2.2.x to 3.0.x
