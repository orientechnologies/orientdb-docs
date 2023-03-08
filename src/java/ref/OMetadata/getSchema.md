---
search:
   keywords: ['java', 'ometadata', 'oschema', 'getschema']
---
# OMetadata - getSchema()

Retrieves the database schema from the database metadata.

## Retrieving Schemas

OrientDB supports multiple implementations of schemas.  A database can strictly enforce schema, not use schema or use a mix of the two.  The schema itself is stored in the database metadata as an [`OSchema`](../OSchema.md) instance.  Using this method you can retrieve the schema from the database metadata to read or administer.

### Syntax

```
OSchema OMetadata().getSchema()
```

#### Return Type

This method returns an [`OSchema`](../OSchema.md) instance, which represents the schema available on the database.


