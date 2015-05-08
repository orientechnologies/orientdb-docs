# Schema

Although OrientDB can work in schema-less mode, sometimes you need to enforce your data model using a schema. OrientDB supports schema-full or schema-hybrid solutions where the latter means to set such constraints only for certain fields and to leave the user to add custom fields on the records. This mode is at a class level, so you can have an "Employee" class as schema-full and an "EmployeeInformation" class as schema-less.

- **Schema-Full**: enables the strict-mode at class level and sets all the fields as mandatory.
- **Schema-Less**: creates classes with no properties. Default mode is non strict-mode so records can have arbitrary fields.
- **Schema-Hybrid**, also called *Schema-Mixed* is the most used: creates classes and define some fields but allows the user to define custom fields.

NOTE: _Changes to the schema are not transactional, so execute them outside a transaction._

To access to the schema, you can use [SQL](SQL.md#query-the-schema) or API. Will follow examples using Java API.

To gain access to the schema APIs you get the OMetadata object from database instance you're using and then call its <code>getSchema()</code> method.

    OSchema schema = database.getMetadata().getSchema();

# Class
A Class is a concept taken from the Object Oriented paradigm. In OrientDB a class defines a type of record. It's the closest concept to a relational database table.  A Class can be schema-less, schema-full, or mixed.

A Class can inherit from another class. This [#Inheritance] means that the sub-class extends the parent class, inheriting all its attributes as if they were its own.

Each class has its own clusters that can be logical (by default) or physical. A class must have at least one cluster defined (as its default cluster), but can support multiple ones. In this case By default OrientDB will write new records in the default cluster, but reads will always involve all the defined clusters.

When you create a new class, by default, a new physical cluster is created with the same name as the class (in lowercase).

## Create a persistent class

Each class contains one or more properties (also called fields). This mode is similar to the classic relational DBMS approach where you define tables before storing records.

Here's an example of creating an Account class.  By default a new [Concepts#Physical_Cluster Physical Cluster] will be created to keep the class instances:

    OClass account = database.getMetadata().getSchema().createClass("Account");

To create a new Vertex or Edge type you have to extend the "V" and "E" classes, respectively. Example:

    OClass person = database.getMetadata().getSchema().createClass("Account",
           database.getMetadata().getSchema().getClass("V"));

Look at [Graph Schema](Graph-Schema.md) for more information.

## Get a persistent class

To retrieve a persistent class use the <code>getClass(String)</code> method. If the class does not exist then null is returned.

    OClass account = database.getMetadata().getSchema().getClass("Account");

## Drop a persistent class

To drop a persistent class use the <code>OSchema.dropClass(String)</code> method.

    database.getMetadata().getSchema().dropClass("Account");


The records of the removed class will not be deleted unless you explicitly delete them before dropping the class. Example:

    database.command( new OCommandSQL("DELETE FROM Account") ).execute();
    database.getMetadata().getSchema().dropClass("Account");

## Constraints
To work in schema-full mode set the strict mode at the class level by calling the <code>setStrictMode(true)</code> method. In this case, all the properties of the record must be predefined.

# Property
Properties are the fields of the class. In this guide a property is synonymous with a field.

## Create the Class property
Once the class has been created, you can define fields (properties). Below is an example:

    OClass account = database.getMetadata().getSchema().createClass("Account");
    account.createProperty("id", OType.INTEGER);
    account.createProperty("birthDate", OType.DATE);

Please note that each field must belong to one of these [Types](https://github.com/orientechnologies/orientdb/wiki/Types).

## Drop the Class property
To drop a persistent class property use the <code>OClass.dropProperty(String)</code> method.

    database.getMetadata().getSchema().getClass("Account").dropProperty("name");


The dropped property will not be removed from records unless you explicitly delete them using the [SQLUpdate SQL UPDATE + REMOVE statement]. Example:

    database.getMetadata().getSchema().getClass("Account").dropProperty("name");
    database.command(new OCommandSQL("UPDATE Account REMOVE name")).execute();

## Define relationships
OrientDB supports two types of relationships: *referenced* and *embedded*.

### Referenced relationships
OrientDB uses a direct **link** to the referenced record(s) without the need of a costly JOIN as does the relational world. Example:

                      customer
      Record A     ------------->    Record B
    CLASS=Invoice                 CLASS=Customer
      RID=5:23                       RID=10:2

*Record A* will contain the _reference_ to the *Record B* in the property called "customer". Note that both records are reachable by any other records since they have a [Concepts#RecordID RecordID].

#### 1-1 and N-1 referenced relationships

1-1 and N-1 referenced relationships are expressed using the *LINK* type.

    OClass customer= database.getMetadata().getSchema().createClass("Customer");
    customer.createProperty("name", OType.STRING);

    OClass invoice = database.getMetadata().getSchema().createClass("Invoice");
    invoice.createProperty("id", OType.INTEGER);
    invoice.createProperty("date", OType.DATE);
    invoice.createProperty("customer", OType.LINK, customer);

In this case records of class "Invoice" will link to a record of class "Customer" using the field "customer".

#### 1-N and N-M referenced relationships

1-N and N-M referenced relationships are expressed using the collection of links such as:
- **LINKLIST** as an ordered list of links
- **LINKSET** as an unordered set of links. It doesn't accept duplicates
- **LINKMAP** as an ordered map of links with *String* key. It doesn't accept duplicated keys

Example of a 1-N relationship between the classes Order and OrderItem:

    OClass orderItem = db.getMetadata().getSchema().createClass("OrderItem");
    orderItem.createProperty("id", OType.INTEGER);
    orderItem.createProperty("animal", OType.LINK, animal);

    OClass order = db.getMetadata().getSchema().createClass("Order");
    order.createProperty("id", OType.INTEGER);
    order.createProperty("date", OType.DATE);
    order.createProperty("items", OType.LINKLIST, orderItem);

    db.getMetadata().getSchema().save();

### Embedded relationships
Embedded records, instead, are contained inside the record that embeds them. It's a kind of relationship stronger than the [#Referenced_relationships reference]. The embedded record will not have its own [Concepts#RecordID RecordID] since it can't be directly referenced by other records. It's only accessible via the container record. If the container record is deleted, then the embedded record will be deleted too. Example:

                      address
      Record A     <>---------->   Record B
    CLASS=Account               CLASS=Address
      RID=5:23                     NO RID!

*Record A* will contain the entire *Record B* in the property called "address". *Record B* can be reached only by traversing the container record.

Example:

    SELECT FROM account WHERE address.city = 'Rome'

#### 1-1 and N-1 referenced relationships
1-1 and N-1 referenced relationships are expressed using the *EMBEDDED* type.

    OClass address = database.getMetadata().getSchema().createClass("Address");

    OClass account = database.getMetadata().getSchema().createClass("Account");
    account.createProperty("id", OType.INTEGER);
    account.createProperty("birthDate", OType.DATE);
    account.createProperty("address", OType.EMBEDDED, address);

In this case, records of class "Account" will embed a record of class "Address".

#### 1-N and N-M referenced relationships
1-N and N-M referenced relationships are expressed using the collection of links such as:
- **EMBEDDEDLIST**, as an ordered list of records.
- **EMBEDDEDSET**, as an unordered set of records. It doesn't accepts duplicates.
- **EMBEDDEDMAP**, as an ordered map with records as the value and *String* as the key. It doesn't accept duplicate keys.

Example of a 1-N relationship between the class Order and OrderItem:

    OClass orderItem = db.getMetadata().getSchema().createClass("OrderItem");
    orderItem.createProperty("id", OType.INTEGER);
    orderItem.createProperty("animal", OType.LINK, animal);

    OClass order = db.getMetadata().getSchema().createClass("Order");
    order.createProperty("id", OType.INTEGER);
    order.createProperty("date", OType.DATE);
    order.createProperty("items", OType.EMBEDDEDLIST, orderItem);

# Constraints
OrientDB supports a number of constraints for each field:
- **Minimum value**, accepts a string because it also works for date ranges ``setMin()``
- **Maximum value**, accepts a string because it also works for date ranges ``setMax()``
- **Mandatory**, must be specified ``setMandatory()``
- **Readonly**, may not be updated after record is created ``setReadonly()``
- **Not Null**, cannot be NULL ``setNotNull()``
- **Unique**, doesn't allow duplicates and speeds up searches.
- **Regexp**, must satisfy the [Regular expression](http://en.wikipedia.org/wiki/Regular_expression).

Example:

    profile.createProperty("nick", OType.STRING).setMin("3").setMax("30").setMandatory(true).setNotNull(true);
    profile.createIndex("nickIdx", OClass.INDEX_TYPE.UNIQUE, "nick"); // Creates unique constraint

    profile.createProperty("name", OType.STRING).setMin("3").setMax("30");
    profile.createProperty("surname", OType.STRING).setMin("3").setMax("30");
    profile.createProperty("registeredOn", OType.DATE).setMin("2010-01-01 00:00:00");
    profile.createProperty("lastAccessOn", OType.DATE).setMin("2010-01-01 00:00:00");


### Indexes as constraints
To ensure that a property value is UNIQUE use the UNIQUE index as a constraint:

    profile.createIndex("EmployeeId", OClass.INDEX_TYPE.UNIQUE, "id");

To ensure that a group of properties is UNIQUE create a composite index made of multiple fields:
Example of creating a composite index:

    profile.createIndex("compositeIdx", OClass.INDEX_TYPE.NOTUNIQUE, "name", "surname");


For more information about indexes look at [Indexes](Indexes.md).