# Graph Database Properties

Fields in classes are called properties.  In this guide, you can consider properties synonymous with fields.


## Working with Properties

In order to use properties in your application, you first need to create the class and set an instance.  Once you have the class set, you can begin to work with properties on that class.


### Creating Properties

You can define properties for that class.  For instance,

```java
// Retrieve Vertex
OrientVertexType accountVertex = graph.getVertexType("Account");

// Create Properties
accountVertex.createProperty("id", OType.INTEGER);
accountVertex.createProperty("birthDate", OType.DATE);
```

Bear in mind, each field must belong to a [Type](Types.md).

### Dropping Properties

To drop a persisten class property, use the `OClass.dropProperty()` method.  For instance,

```java
accountVertex.dropProperty("name");
```

This drops the property `name`.  OrientDB does not remove dropped properties from the record unless you delete them explicitly using the SQL [`UPDATE`](SQL-Update.md) command with the `REMOVE` clause.

```java
// Drop the Property
accountVertex.dropProperty("name");

// Remove the Records
database.command(new OCommandSQL("UPDATE Account REMOVE name").execute();
```

## Using Constraints

| | |
|----|-----|
|![](images/warning.png)| Using constraints with a distributed database may cause unexpected results.  Some operations execute in two steps: create and update, such as when creating an edge and then updating the vertex.  Constraints like `MANDATORY` and `NOTNULL` against fields would fail on distributed databases during the creation phase.|

OrientDB supports a number of constraints for each field:

| Constraint | Method | Description |
|---|---|---|
| **Minimum Value** | `setMin()` | Defines the minimum value.  Property accepts strings and also works on date ranges.|
| **Maximum Value** | `setMax()` | Defines the maximum value.  Property accepts strings and also works on date ranges.|
| **Mandatory** | `setMandatory()` | Defines whether the property must be specified. |
| **Read Only** | `setReadonly()` | Defines whether you can update the property after creating the record.|
| **Not Null** | `setNotNull()` | Defines whether the property accepts null values.|
| **Unique** | | Defines whether the property must be unique.|
| **Regex** | | Defines whether the property must satisfy a Regular Expressions value.|
| **Ordered** | `setOrdered()` | Defines whether the edge list must be ordered, ensuring that a `List` is not used in place of a `Set`.|

For example,

```java
// Create Unique Nickname
profile.createProperty("nick", OType.STRING).setMin("3").setMax("30")
	.setMandatory(true).setNotNull(true);
profile.createIndex("nickIdx", OClass.INDEX_TYPE.UNIQUE, "nick");

// Create User Properties
profile.createProperty("name", OType.STRING).setMin("3").setMax("30");
profile.createProperty("surname", OType.STRING).setMin("3").setMax("30");
profile.createProperty("registeredOn", OType.DATE).setMin("2010-01-01 00:00:00");
profile.createProperty("lastAccessOn", OType.DATE).setMin("2010-01-01 00:00:00");
```

### Indexes as Constraints

In order to set the property value to unique, use the `UNIQUE` index as a constraint by passing a `Parameter` object with the key `type`.  For instance,

```java
graph.createKeyIndex("id", Vertex.class, new Parameter("type", "UNIQUE"));
```

OrientDB applies this constraint to all vertex and subclass instances.  To specify an index against a custom type, use the `class` parameter.

```java
graph.createKeyIndex("name", Vertex.class, new Parameter("class", "Member"));
```

You can also define a unique index against a custom type:

```java
graph.createKeyIndex("id", Vertex.class, new Parameter("type", "UNIQUE"), 
	new Parameter("class", "Member"));
```

You can then retrieve a vertex or an edge by key prefixing the class name to the field.  For instance, using the about `Member.name` in place of only `name`, which allows you to use the index created against the filed `name` in the class `Member`.

```java
for( Vertex v : graph.getVertices("Member.name", "Jay")) {
	System.out.println("Found vertex: " + v)
}
```

If the class name is not passed, then it uses `V` for the vertices and `E` for edges.

```java
graph.getVertices("name", "Jay");
graph.getEdges("age", 20);
```
>For more information, see
>
>- [Indexes](Indexes.md)
>- [Graph Schema](Graph-Schema.md)
>- [Graph Database](Graph-Database-Tinkerpop.md)
