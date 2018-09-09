---
search:
   keywords: ['java', 'oschema', 'getclasses']
---

# OSchema - getClasses()

Retrieves the classes from the schema.

## Getting Classes

OrientDB has the concept of class within the database, which represents a broad grouping of records, similar to the table in relational contexts.  Internally, OrientDB represents a class as an [`OClass`](../OClass.md) instance.   Using this method you can retrieve a set of all the classes in the schema. 

### Syntax

```
Set<OClass> OSchema().getClasses()
```

#### Return Type

This method returns a `Set` of the given [`OClass`](../OClass.md) instances in the schema.


