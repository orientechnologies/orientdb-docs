---
search:
   keywords: ['Document API', 'schema']
---

# Schema

While you can use OrientDB in schema-less mode, there are times in which you need to enforce your own data model using a schema.  OrientDB supports schema-full, schema-less and schema hybrid modes.

- **Schema Full** Enables the strict-mode at a class-level defining all fields as mandatory.
- **Schema Less**: Enables the creation of classes with no properties.  This non-strict mode is the default in OrientDB and allows records to have arbitrary fields.
- **Schema Hybrid**: Enables a mix of classes that are schema-full and schema-less.


>Bear in mind, changes made to the schema are not transactional.  You must execute these operations outside of a transaction.

To access the schema through the Console, use [`SELECT`](../sql/SQL-Metadata.md#querying-the-schema).  

In order to access and work with the schema through the Java API, you need to get the `OMetadata` object from the database, then call the `getSchema()` method. For instance,

```java
OSchema schema = database.getMetadata().getSchema();
```

This sets the object `schema`, which you can then use to further define classes and properties:

- [**Document Database Classes**](Document-API-Class.md)
- [**Document Database Properties**](Document-API-Property.md)


>For more information on how to access the schema through SQL or the Console, see [Querying the Schema](../sql/SQL-Metadata.md#querying-the-schema).


