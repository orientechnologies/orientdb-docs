
# OSchema - createAbstractClass()

Creates a new class in the schema.

## Creating Classes

OrientDB has the concept of class within the database, which represents a broad grouping of records, similar to the table in relational contexts.  Internally, OrientDB represents a class as an [`OClass`](../OClass.md) instance.  Using this method you can create a new class in the schema.  Database classes are also polymorphic, you can assign an existing class as a superclass to the new class.

### Syntax

```
OClass OSchema().createAbstractClass(String class)

OClass OSchema().createAbstractClass(String class, Oclass superClass)

OClass OSchema().createAbstractClass(
   String class, OClass superClass, OClass superclass ...)
```

| Argument | Type | Description |
|---|---|---|
| **`class`** | `String` | Defines the name of the new database class |
| **`superClass`** | [`OClass`](../OClass.md) | Defines superclass |

#### Return Type

This method returns the newly created [`OClass`](../OClass.md) instance.
