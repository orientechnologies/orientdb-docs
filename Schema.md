# Schema

Although OrientDB can work in schema-less mode, sometimes you need to enforce your data model using a schema. OrientDB supports schema-full or schema-hybrid solutions where the second one means to set such constraints only for certain fields and leave the user to add custom fields to the records. This mode is at class level, so you can have the `Employee` class as schema-full and `EmployeeInformation` class as schema-less.

- **Schema-Full**: enable the strict-mode at class level and set all the fields as mandatory
- **Schema-Less**: create classes with no properties. Default mode is non strict-mode so records can have arbitrary fields
- **Schema-Hybrid**, called also **Schema-Mixed** is the most used: create classes and define some fields but leave the record to define own custom fields

> **NOTE**: Changes to the schema are not transactional, so execute them outside a transaction.

To access to the schema, you can use [SQL](SQL.md#query-the-schema) or API. Will follow examples using Java API.

To gain access to the schema APIs you need in the Schema instance of the database you're using.

```java
OSchema schema = database.getMetadata().getSchema();
```

## Class

A Class is a concept taken from the Object Oriented paradigm. In OrientDB defines a type of record. It's the closest concept to a Relational DBMS Table. Class can be schema-less, schema-full or mixed.

A class can inherit from another, shaping a tree of classes. This means that the sub-class extends the parent one inheriting all the attributes.

Each class has its clusters that can be logical (by default) or physical. A class must have at least one cluster defined (as its default cluster), but can support multiple ones. In this case by default OrientDB will write new records in the default cluster, but reads will always involve all the defined clusters.

When you create a new class by default a new physical cluster is created with the same name of the class in lower-case.

### Create a persistent class

Each class contains one or more properties. This mode is similar to the classic Relational DBMS approach where you define tables before storing records.

Example of creation of Account class. By default a new [Cluster](Concepts#cluster] will be created to keep the class instances:

```java
OClass account = database.getMetadata().getSchema().createClass("Account");
```

### Get a persistent class

To retrieve a persistent class use the `getClass(String)` method. If the class not exists NULL is returned.

```java
OClass account = database.getMetadata().getSchema().getClass("Account");
```

### Drop a persistent class

To drop a persistent class use the `OSchema.dropClass(String)` method.

```java
database.getMetadata().getSchema().dropClass("Account");
```

The records of the removed class will be not deleted unless you explicitly delete them before to drop the class. Example:

```java
database.command( new OCommandSQL("DELETE FROM Account") ).execute();
database.getMetadata().getSchema().dropClass("Account");
```

### Constraints

To work in schema-full mode set the strict mode at class level by calling the `setStrictMode(true)` method. In this case record of that class can't have not-defined properties.

## Property

Properties are the fields of the class. In this guide Property is synonym of Field.

### Create the Class property

Once the class has been created, you can define fields (properties). Below an example:

```java
OClass account = database.getMetadata().getSchema().createClass("Account");
account.createProperty("id", OType.INTEGER);
account.createProperty("birthDate", OType.DATE);
```
Please note that each field must belong to one of [supported types](Types.md).

### Drop the Class property

To drop a persistent class property use the `OClass.dropProperty(String)` method.

```java
database.getMetadata().getSchema().getClass("Account").dropProperty("name");
```

The dropped property will not be removed from records unless you explicitly delete them using the [SQL UPDATE + REMOVE statement](SQL-Update.md). Example:

```java
database.getMetadata().getSchema().getClass("Account").dropProperty("name");
database.command(new OCommandSQL("UPDATE Account REMOVE name")).execute();
```

### Define relationships

OrientDB supports two types of relationships: **referenced** and **embedded**.

#### Referenced relationships

OrientDB uses a direct **link** to the referenced record(s) without the need of costly `JOIN`s of the Relational world. Example:

```
                  customer
  Record A     ------------->    Record B
CLASS=Invoice                 CLASS=Customer
  RID=5:23                       RID=10:2
```
**Record A** will contain the *reference* to the **Record B** in the property called `customer`. Note that both records are reachable by any other records since they have a [RecordID](Concepts.md#recordid).

#### 1-1 and N-1 referenced relationships

1-1 and N-1 referenced relationships are expressed using the **LINK** type.

```java
OClass customer= database.getMetadata().getSchema().createClass("Customer");
customer.createProperty("name", OType.STRING);

OClass invoice = database.getMetadata().getSchema().createClass("Invoice");
invoice.createProperty("id", OType.INTEGER);
invoice.createProperty("date", OType.DATE);
invoice.createProperty("customer", OType.LINK, customer);
```

In this case records of class `Invoice` will link to a record of class `Customer` using the field `customer`.

#### 1-N and N-M referenced relationships

1-N and N-M referenced relationships are expressed using the collection of links such as:

- **LINKLIST** as an ordered list of links
- **LINKSET** as an unordered set of links. It doesn't accept duplicates
- **LINKMAP** as an ordered map of links with **String** key. It doesn't accept duplicated keys

Example of a 1-N relationship between the classes `Order` and `OrderItem`:

```java
OClass orderItem = db.getMetadata().getSchema().createClass("OrderItem");
orderItem.createProperty("id", OType.INTEGER);
orderItem.createProperty("animal", OType.LINK, animal);

OClass order = db.getMetadata().getSchema().createClass("Order");
order.createProperty("id", OType.INTEGER);
order.createProperty("date", OType.DATE);
order.createProperty("items", OType.LINKLIST, orderItem);
```

#### Embedded relationships

Embedded records, instead, are contained inside the record that embeds them. It's a kind of relationship stronger than the reference. The embedded record will not have a own [RecordID](Concepts.md#recordid) since it can't be directly referenced by other records. It's only accessible via the container record. If the container record is deleted, then the embedded record will be deleted too. Example:

```
                  address
  Record A     <>---------->   Record B
CLASS=Account               CLASS=Address
  RID=5:23                     NO RID!
```

**Record A** will contain the entire **Record B** in the property called `address`. **Record B** can be reached only by traversing the container record.

Example:

```java
SELECT FROM account WHERE address.city = 'Rome'
```

#### 1-1 and N-1 embedded relationships

1-1 and N-1 embedded relationships are expressed using the `EMBEDDED` type.

```java
OClass address = database.getMetadata().getSchema().createClass("Address");

OClass account = database.getMetadata().getSchema().createClass("Account");
account.createProperty("id", OType.INTEGER);
account.createProperty("birthDate", OType.DATE);
account.createProperty("address", OType.EMBEDDED, address);
```

In this case, records of class `Account` will embed a record of class `Address`.

#### 1-N and N-M embedded relationships

1-N and N-M embedded relationships are expressed using the collection of links such as:

- **EMBEDDEDLIST**, as an ordered list of records
- **EMBEDDEDSET**, as an unordered set of records. It doesn't accepts duplicates
- **EMBEDDEDMAP**, as an ordered map of records as value with key a **String**. It doesn't accepts duplicated keys

Example of a 1-N relationship between the class `Order` and `OrderItem`:

```java
OClass orderItem = db.getMetadata().getSchema().createClass("OrderItem");
orderItem.createProperty("id", OType.INTEGER);
orderItem.createProperty("animal", OType.LINK, animal);

OClass order = db.getMetadata().getSchema().createClass("Order");
order.createProperty("id", OType.INTEGER);
order.createProperty("date", OType.DATE);
order.createProperty("items", OType.EMBEDDEDLIST, orderItem);
```

### Constraints

OrientDB supports a number of constrains for each field:

- **Minimum value**, accepts a string because works also for date ranges `setMin()`
- **Maximum value**, accepts a string because works also for date ranges `setMax()`
- **Mandatory**, it must be specified `setMandatory()`
- **Readonly**, it may not be updated after record is created `setReadonly()`
- **Not Null**, can't be NULL `setNotNull()`
- **Unique**, doesn't allow duplicates and speedup searches.
- **Regexp**, it must satisfy the [Regular expression](http://en.wikipedia.org/wiki/Regular_expression).

```java
profile.createProperty("nick", OType.STRING).setMin("3").setMax("30").setMandatory(true).setNotNull(true);
profile.createIndex("nickIdx", OClass.INDEX_TYPE.UNIQUE, "nick"); // Creates unique constraint

profile.createProperty("name", OType.STRING).setMin("3").setMax("30");
profile.createProperty("surname", OType.STRING).setMin("3").setMax("30");
profile.createProperty("registeredOn", OType.DATE).setMin("2010-01-01 00:00:00");
profile.createProperty("lastAccessOn", OType.DATE).setMin("2010-01-01 00:00:00");
```

#### Indexes as constraints

To let a property value to be `UNIQUE` use the `UNIQUE` index as constraint:

```java
profile.createIndex("EmployeeId", OClass.INDEX_TYPE.UNIQUE, "id");
```

To let to a group of properties to be `UNIQUE` create a composite index made of multiple fields:

Creation of composite index:

```java
profile.createIndex("compositeIdx", OClass.INDEX_TYPE.NOTUNIQUE, "name", "surname");
```

For more information about indexes look at [Index guide](Indexes.md).
