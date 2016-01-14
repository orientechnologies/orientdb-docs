# SQL - `CREATE PROPERTY`

Creates a new property in the schema.  It requires that the class for the property already exist on the database.

**Syntax**

```
CREATE PROPERTY <class>.<property> <type> [<link-type>|<link-class>] [UNSAFE]
```

- **`<class>`** Defines the class for the new property.
- **`<property>`** Defines the logical name for the property.
- **`<type>`** Defines the property data type.  For supported types, see the table below.
- **`<link-type>`** Defines the contained type for container property data types.  For supported link types, see the table below.
- **`<link-class>`** Defines the contained class for container property data types.  For supported link types, see the table below.
- **`UNSAFE`** Defines whether it checks existing records.  On larger databases, with millions of records, this could take a great deal of time.  Skip the check when you are sure the property is new.  Introduced in version 2.0.


>When you create a property, OrientDB checks the data for property and type.  In the event that persistent data contains incompatible values for the specified type, the property creation fails.  It applies no other constraints on the persistent data.

**Examples**

- Create the property `name` of the string type in the class `User`:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE PROPERTY User.name STRING</code>
  </pre>

- Create a property formed from a list of strings called `tags` in the class `Profile`:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE PROPERTY Profile.tags EMBEDDEDLIST STRING</code>
  </pre>

- Create the property `friends`, as an embedded map in a circular reference:

  <pre>
  orientdb> <code class='lang-sql userinput'>CREATE PROPERTY Profile.friends EMBEDDEDMAP Profile</code>
  </pre>


>For more information, see
>
>- [`DROP PROPERTY`](SQL-Drop-Property.md)
>- [SQL Commands](SQL.md)
>- [Console Commands](Console-Commands.md)


## Supported Types

OrientDB supports the following data types for standard properties:

|||||
|---|---|---|---|
| `BOOLEAN` | `SHORT` | `DATE` | `BYTE`|
| `INTEGER` | `LONG` | `STRING` | `LINK` |
| `DOUBLE` | `FLOAT` | `BINARY` | `EMBEDDED` |

It supports the following data types for container properties.  

||||
|---|---|---|
| `EMBEDDEDLIST` | `EMBEDDEDSET` | `EMBEDDEDMAP` |
| `LINKLIST` | `LINKSET` | `LINKMAP` |

For these data types, you can optionally define the contained type and class.  The supported link types are the same as the standard property data types above.


