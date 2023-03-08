---
search:
   keywords: ['java', 'oschema', 'getorcreateclass']
---

# OSchema - getOrCreteClass()

Retrieves the given class or creates and retrieves it from the schema.

## Retrieving or Creating Classes

OrientDB has the concept of class within the database, which represents a broad grouping of records, similar to the table in relational contexts.  Internally, OrientDB represents a class as an [`OClass`](../OClass.md) instance.   Using this method you can retrieve the given class if exists in the schema, if it does not exist it create the class and returns it. 

### Syntax

```
OClass OSchema().getOrCreateClass(String class)

OClass OSchema().getOrCreateClass(String class, OClass... superClass)
```

| Argument | Type | Description |
|---|---|---|
| **`class`** | `String` | Defines the logical name of the class|
| **`superClass`** | [`OClass`](../OClass.md) | Defines the superclass |

#### Return Type

This method returns the requested [`OClass`](../OClass.md) instance.  It returns an existing class if it already existed in the database and the newly created class if it did not exist in the database.

