
# OSchema - getClass()

Retrieves the class from the schema.

## Getting Classes

OrientDB has the concept of class within the database, which represents a broad grouping of records, similar to the table in relational contexts.  Internally, OrientDB represents a class as an [`OClass`](../OClass.md) instance.   Using this method you can retrieve the given class from the schema. 

### Syntax

```
OClass OSchema().getClass(String class)
```

| Argument | Type | Description |
|---|---|---|
| **`class`** | `String` | Defines name of class you want to get |

#### Return Type

This method returns the request [`OClass`](../OClass.md) instance.


