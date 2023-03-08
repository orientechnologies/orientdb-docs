---
search:
   keywords: ['java', 'oschema', 'createclass']
---

# OSchema - createClass()

Creates a new class in the schema.

## Creating Classes

OrientDB has the concept of class within the database, which represents a broad grouping of records, similar to the table in relational contexts.  Internally, OrientDB represents a class as an [`OClass`](../OClass.md) instance.  Using this method you can create a new class in the schema.  Database classes are also polymorphic, you can assign an existing class as a superclass to the new class.

### Syntax

```
OClass OSchema().createClass(String class)

OClass OSchema().createClass(String class, OClass... superclasses)

OClass OSchema().createClass(String class, int[] clusterIds, OClass... superClasses)
```

| Argument | Type | Description |
|---|---|---|
| **`class`** | `String` | Defines the name of the new database class |
| **`superClasses`** | [`OClass`](../OClass.md) | Defines superclass |
| **`clusterIds`** | `int[]` | Defines the Cluster ID's for clusters you want the class to use |

#### Return Type

This method returns the newly created [`OClass`](../OClass.md) instance.
