
# Properties in the Document Database

Properties are the fields in a class.  Generally, you can consider properties as synonymous with fields.

## Working with Properties

### Creating Properties

Once you have created a class, you can create properties on that class.  For instance,

```java
OClass account = database.createClass("Account");
account.createProperty("id", OType.INTEGER);
account.createProperty("birthDate", OType.DATE);
```

Bear in mind, the property must belong to a [Type](../general/Types.md).


### Dropping Properties

To drop persistent class properties, use the [`OClass.dropProperty(String)`](ref/OClass/dropProperty.md) method.  For instance,

```java
database.getClass("Account).dropProperty("name");
```

When you drop properties using this method, note that doing so does not result in your removing records unless you explicitly do so.  In order to do so, you need to issue an SQL command through the application to run an [`UPDATE...REMOVE`](../sql/SQL-Update.md) statement.  For instance,

```java
database.getClass("Account").dropProperty("name");
database.command("UPDATE Account REMOVE name");
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

Here, *Record A* contains a reference to *Record B* in the property `customer`,  Note that both records are accessible through any other record.  Each has a [Record ID](../datamodeling/Concepts.md#record-id).

#### 1-1 and n-1 Referenced Relationships

In the case of one-to-one and many-to-one Referenced Relationships, you can express them through the `LINK` type.  For instance, using the Document API:

```java
OCLass customer = database.createClass("Customer");
customer.createProperty("name", OType.STRING);

OClass invoice = database.createClass("Invoice");
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
OClass orderItem = db.createClass("OrderItem");
orderItem.createProperty("id", OType.INTEGER);
orderItem.createProperty("animal", Otype.LINK, animal);

OClass order = db.createClass("Order");
order.createProperty("id", OType.INTEGER);
order.createProperty("date", OType.DATE);
order.createProperty("item", OType.LINKLIST, orderItem);

```



### Embedded Relationships

In the case of Embedded Relationships, the relationships are defined inside the records that embed them.  The relationship is stronger than the [Referenced Relationship](#referenced-relationships).  The embedded record does not have its own Record ID, which means that you cannot reference it directly through other records.  It's only accessible through the containing record.  If you delete the container record, the embedded record is removed with it.  For instance,

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
OClass address = database.createClass("Address");

OClass account = database.createClass("Account");
account.createProperty("id", OType.INTEGER);
account.createProperty("birthDate", OType.DATE);
account.createProperty("address", OType.EMBEDDED, address);
```

Here, records of the class `Account` embed records of the class `Address`.

#### 1-n and n-M Embedded Relationships

In the cases of one-to-many and many-to-many relationships , use embedded link collections types:

- **`EMBEDDEDLIST`** Ordered list of embedded links to records.
- **`EMBEDDEDSET`** Unordered set of records, which doesn't accept duplicates.
- **`EMBEDDEDMAP`** Ordered map with records as the value and a String instance as the key, which doesn't accept duplicates.

For instance, consider a one-to-many relationship between `Order` and `OrderItem`:

```java
OClass orderItem = db.createClass("OrderItem");
orderItem.createProperty("id", OType.INTEGER);
orderITem.createProperty("animal", OType.LINK, animal);

OClass order = db.createClass("Order");
order.createProperty("id", OType.INTEGER);
order.createProperty("date", OType.DATE);
order.createProperty("items", OType.EMBEDDEDLIST, orderItem);
```

## Working with Constraints

OrientDB supports a number of constrains on each property:

- **Minimum Value**: `setMin()` Defines the smallest acceptable value for the property.  Works with strings and in date ranges.
- **Maximum Value**: `setMax()` Defines the largest acceptable value for the property.  Works with strings and in date ranges.
- **Mandatory**: `setMandatory()` Defines a required property.
- **Read Only**: `setReadonly()` Defines whether you can update the property after creating it.
- **Not Null**: `setNotNull()` Defines whether property can receive null values.
- **Unique**: `setUnique()` Defines whether property rejects duplicate values.  Note: Using this constraint can speed up searches made against this property.
- **Regular Expression** `setRegexp()` Defines whether the property must satisfy the given regular expression.

For instance, consider the properties you might set on the `Profile` class for a social networking service.

```java
profile.createProperty("nick", OType.STRING).setMin("3")
   .setMax("30").setMandatory(true).setNotNull(true);
profile.createIndex("nickIdx", OClass.INDEX_TYPE
   .UNIQUE, "nick");

profile.createProperty("name", OType.STRING).setMin("3")
   .setMax("30");
profile.createProperty("surname", OType.STRING)
   .setMin("3").setMax("30");
profile.createProperty("registeredOn" OType.DATE)
   .setMin("2010-01-01 00:00:00");
profile.createProperty("lastAccessOn", OType.DATE)
   .setMin("2010-01-01 00:00:00");
```

### Indexes as Constraints


To ensure that a property value remains unique, use the `UNIQUE` index constraint:

```java
profile.createIndex("EmployeeId", OClass.INDEX_TYPE
   .UNIQUE, "id");
```

To ensure that a group of properties remains unique, create a composite index from multiple fields:

```java
profile.createIndex("compositeIdx", OClass.INDEX_TYPE
   .NOTUNIQUE, "name", "surname");
```

For more information on indexes, see [Indexes](../indexing/Indexes.md).
