
# OSchema - dropClass()

Removes class from the schema.

## Removing Classes

OrientDB has the concept of class within the database, which represents a broad grouping of records, similar to the table in relational contexts.  Internally, OrientDB represents a class as an [`OClass`](../OClass.md) instance.  Using this method, you can remove the given class from the schema.

### Syntax

```
void OSchema().dropClass(String class)
```

| Argument | Type | Description |
|---|---|---|
| **`class`** | `String` | Defines name of class you want to remove |


