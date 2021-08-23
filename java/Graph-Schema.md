
# Graph Schema

In OrientDB you can use a Graph Database in schema-less mode, or you can enforce strict data model through a schema.  When using a schema, you can use it on all data or only define constraints on certain fields, allowing users to add custom fields to records.

The schema mode you use is defined at a class-level.  So, for instance you might have a class `Employee` that is schema-full with a class `EmployeeInformation` that is schema-less.

- **Schema-Full**: Enables the strict-mode at a class level and sets all fields to mandatory.
- **Schema-Less**: Creates classes with no properties.  By default, this is non-strict-mode, allowing records to have arbitrary fields.
- **Schema-Hybrid**: Creates classes and defines some of the fields, while leaving the records to define custom fields.  Sometimes, this is also called **Schema-Hybrid**.

>**NOTE**: Bear in mind that any changes you make to the class schema are not transactional.  You must execute them outside of a transaction.

To access the schema, you can use either [SQL](../sql/SQL-Metadata.md#querying-the-schema) or the API.  The examples in the following pages use the Java API.

- [**Graph Database Classes**](Graph-Schema-Class.md)
- [**Graph Database Properties**](Graph-Schema-Property.md)

>For more information, see [Blog: Using Schema with Graphs](http://orientechnologies.blogspot.it/2013/08/orientdb-using-schema-with-graphs.html)

