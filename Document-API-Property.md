# Properties

Properties are the fields in a class.  Generally, you can consider properties as synonymous with fields.

## Working with Properties

Much as you can define properties using SQL, you can also define them through the Document API.


### Creating Properties

Once you have created a class, you can create properties on that class.  For instance,

```java
OClass account = database.getMetadata().getschema()
   .createClass("Account");
account.createProperty("id", OType.INTEGER);
account.createProperty("birthDate", OType.DATE);
```

Bear in mind, the property must belong to a [Type](Types.md).


### Dropping Properties

To drop persistent class properties, use the `OClass.dropProperty(String)` method.  For instance,

```java
database.getMetadata().getSchema().getClass("Account)
   .dropProperty("name");
```

When you drop properties using this method, note that doing so does not result in your remvoing records unless you explicitly do so.  In order to do so, you need to issue an SQL command through the application to run an [`UPDATE...REMOVE`](SQL-Update.md) statement.  For instance,

```java
database.getMetadata().getSchema().getClass("Account")
   .dropProperty("name");
database.command(new OCommandSQL(
   "UPDATE Account REMOVE name")).execute();
```

## Working with Relationships

OrientDB supports two types of relations:

- Referenced Relationships

- Embedded Relationships

### Referenced Relationships

In a referenced relationship, OrientDB uses a direct link to the referenced records.  This removes the need for the computationally costly `JOIN` operation common in Relational Databases.  For instance,

```
            customer
 Record A  ----------->  Record B
CLASS=Invoice          CLASS=Customer
 RID=5:23                RID=10:2
```

Here, *Record A* contains a reference to *Record B* in the property `customer`,  Note that both records are accessible through any other record.  Each has a [Record ID](Concepts.md#record-id).

#### 1-1 and n-1 Referenced Relationships

In the case of one-to-one and many-to-one Referenced Relationships, you can express them through the `LINK` type.  For instance, using the Document API:

```java
OCLass customer = database.getMetadata().getSchema()
   .createClass("Customer");
customer.createProperty("name", OType.STRING);

OClass invoice = database.getMetadata().getSchema()
   .createClass("Invoice");
invoice.createProperty("id", OType.INTEGER);
invoice.createProperty("date", OType.DATE);
invoice.createProperty("customer", OType.LINK, customer);
```

Here, records of the class `Invoice` link to records of the class `Customer` using the field `customer`.


#### 1-n and n-M Referenced Relationships

In one-to-many and many-to-many Referenced Relationships, you can express the relationship using collections of links, such as:

- **`LINKLIST`** Ordered list of links, which can accept duplicates.
- **`LINKSET`** Unordered set of links, which doesn't accept duplicates.
- **`LINKMAP`** Ordered map of links, with a *String* key, which also doesn't accept duplicates.

For instance, in the case of a one-to-many relationship between the classes `Order` and `OrderItem`:

```java
OClass orderItem = db.getMetadata().getSchema
   .createClass("OrderItem");
orderItem.createProperty("id", OType.INTEGER);
orderItem.createProperty("animal", Otype.LINK, animal);

OClass order = db.getMetadata().getSchema()
   .createClass("Order");
order.createProperty("id", OType.INTEGER);
order.createProperty("date", OType.DATE);
order.createProperty("item", OType.LINKLIST, orderItem);

db.getMetadata().getSchema().save();
```



### Embedded Relationships

In the case of Embedded Relationships, the relationships are defined inside the records that embed them.  The relationship is stronger than the [Referenced Relationship](#referenced-relationships).  The embedded record does not have its own Record ID, which means that you cannot reference it directly through other records.  It's only accessible through the containing record.  If you delete the container record, the embedded record is remoed with it.  For instance,

```
               address
  Record A    <>-------->   Record B
CLASS=Account             CLASS=Address
  RID=5:23                 NO RECORD ID
```


Here, *Record A* contains the whole of *Record B* in the property `address`.  You can reach *Record B* only by traversing the container record.  For instance,

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM account WHERE address.city = 'Rome'</code>
</pre>

#### 1-1 and N-1 Embedded Relationships

In one-to-one and many-to-one relationships, use the `EMBEDDED` type.  For instance,

```java
OClass address = database.getMetadata().getSchema()
   .createClass("Address");

OClass account = database.getMetadata().gtschema()
   .createClass("Account");
account.createProperty("id", OType.INTEGER);
account.createProperty("birthDate", OType.DATE);
account.createProperty("address", OType.EMBEDDED, address);
```

Here, records of the class `Account` embed records of the class `Address`.

#### 1-n and n-M Embedded Relationships
