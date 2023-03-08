---
search:
   keywords: ['java', 'oschema', 'getclassbyclusterid']
---

# OSchema - getClassByClusterId()

Retrieves a class from the schema by its associated cluster.

## Retrieving Classes

OrientDB has the concept of class within the database, which represents a broad grouping of records, similar to the table in relational contexts.  Internally, OrientDB represents a class as an [`OClass`](../OClass.md) instance.   Using this method you can retrieve a class from the schema by it associated cluster. 

### Syntax

```
OClass OSchema().getClassByClusterId(int clusterId)
```

| Argument | Type | Description |
|---|---|---|
| **`clusterId`** | `int` | Defines the Cluster ID |

#### Return Value

This method returns the [`OClass`](../OClass.md) instance that corresponds to the given Cluster ID.

