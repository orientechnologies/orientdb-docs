
# OSchema - existsClass()

Checks whether the given class exists in the schema.

## Checking Class Existence

OrientDB has the concept of class within the database, which represents a broad grouping of records, similar to the table in relational contexts.  Internally, OrientDB represents a class as an [`OClass`](../OClass.md) instance.   Using this method you can check whether the given class exists in the schema. 

### Syntax

```
boolean OSchema().existsClass(String class)
```

| Argument | Type | Description |
|---|---|---|
| **`class`** | `String` | Defines name of class you want to check |

#### Return Type

This method returns a `boolean` instance.  A value of `true` indicates that the given class exists in the schema.


