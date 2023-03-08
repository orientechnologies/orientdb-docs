---
search:
   keywords: ['Java API', 'OElement', 'schema', 'get schema type', 'getSchemaType']
---

# OElement - getSchemaType()

This method retrieves the schema type for the record.

## Retrieving Schema Types

OrientDB can run schema-less, schema-full or it can use a schema in some cases and not use one in others.  In cases where the record has a schema, that is when it is defined as a particular class on the OrientDB database, this method retrieves the [`OClass`](../OClass.md) instance to which it belongs.

### Syntax

```
Optional<OClass> OElement.getSchemaType()
```

#### Return Value

When the record corresponding to this [`OElement`](../OElement.md) instance has a schema class, this method returns an [`OClass`](../OClass.md) instance. In the event that the record does not enforce a schema, it returns an empty [`Optional`]({{ book.javase }}/api/java/util/Optional.html) instance.

