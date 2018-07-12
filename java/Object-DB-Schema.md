# Schema 

You can use the Object API in schema-less or in schema-full mode, provided the requirements given in [POJO](Object-DB-POJO.md) are followed. Schema-less means that you can create the class without defining properties.

For instance,

```java
OrientDBObject orientDB = new OrientDBObject("remote:localhost",OrientDBConfig.defaultConfig());
ODatabaseObject db = orientDB.open("petshop","admin", "admin_passwd");

db.getEntityManager().registerEntityClass(Person.class);

Person p = db.newInstance(Person.class);
p.setName("Luca");
p.setSurname("Garulli");
p.setCity(new City("Rome", "Italy"));

db.save(p);
db.close();
```

Note in the above example that the class Person is not declared before it gets used. Despite this, OrientDB is able to recognize the new object and save it in a persistent way.

In schema-full mode, you need to declare the classes you're using. Each class contains one or more properties. The mode is similar to the classic Relational database approach, where you need to create tables before storing records.

>For more information on schemas in the Java API, see [Schemas](../general/Schema.md).


## Schema Generation

Beginning in version 1.5, the Object Database provides support for automatic [schema](../general/Schema.md) generation based on registered entities.  This operation can be

- [Manual](#manual-schema-generation)
- [Automatic](#automatic-schema-generation)

The Object API generates class properties based on field declarations where necessary.

>**NOTE**: When modifying class fields, such as changing or renaming types, the Object API doesn't update types.  You must manually perform this operation.

### Manual Schema Generation

Schema can be generated manually for single classes or entire packages.  The syntax varies depending on which version you're using:

- Versions 1.6 and newer:

  ```java
  // GENERATE SCHEMA FOR Foo CLASS
  db.getMetadata().getSchema().generateSchema(Foo.class);

  // GENERATE SCHEMA FROM ALL CLASSES IN PACKAGE
  db.getMetadata().getSchema().generateSchema("com.mycompany.myapp.mydomainpackage");
  ```
- Version 1.5

  ```java
  // GENERATE SCHEMA FOR Foo CLASS
  db.generateSchema(Foo.class);

  // GENERATE SCHEMA FROM ALL CLASSES IN PACKAGE
  db.generateSchema("com.mycompany.myapp.mydomainpackage");
  ```

### Automatic Schema Generation

By setting the `automaticSchemaGeneration` property to true the schema will be generated automatically on every class [declaration](Object-2-Record-Java-Binding.md#declare-persistent-classes).

```java
db.setAutomaticSchemaGeneration(true);
db.getEntityManager().registerClass(Foo.class); // Generates the schema for Foo class after registering.
db.getEntityManager().registerEntityClasses("com.mycompany.myapp.mydomainpackage"); // Generates the schema for all classes contained in the given package after registering.
```

Here, the class `Foo` might look like this, generating one field of the Integer type and ignoring the String field.

```java
public class Foo {
   // INITIALIZE STRING FIELD (IGNORED BY ORIENTDB)
   private transient String field1;

   // INITIALIZE INTEGER FIELD (CREATED BY ORIENTDB)
   private Integer field2; 
}
```

### Standard Schema Management Equivalent

As an example, consider the class `Foo` defined as follows:

```java
public class Foo{
   private String text;
   private Child reference;
   private int number;

   // getters and setters
}
```

The schema generation creates `text`, `reference` and `number` properties as, respectively, `STRING`, `LINK`, and `INTEGER` types.  The default schema management API equivalent would be:

```java
OClass foo = db.getMetadata().getSchema().getClass(Foo.class);
OClass child = db.getMetadata().getSchema().getClass(Child.class)
foo.createProperty("text",OType.STRING);
foo.createProperty("number",OType.INTEGER);
foo.createProperty("text",OType.LINK, child);
db.getMetadata().getSchema().save();
```

## Schema Synchronization

For synchronize the schema for all registered entities you can use.

```java
db.getMetadata().getSchema().synchronizeSchema();
```

By calling this API the Object database checks all registered entities and generates the schema, if one has not yet been generated. This management is useful on multi-database environments.
