<!-- proofread 2015-01-07 SAM -->

# Console - `CREATE PROPERTY`

Creates a new property on the given class. The class must already exist.

**Syntax**

```sql
CREATE PROPERTY <class-name>.<property-name> <property-type> [<linked-type>][ <linked-class>]
```

- **`<class-name>`** Defines the class you want to create the property in.
- **`<property-name>`** Defines the logical name of the property.
- **`<property-type>`** Defines the type of property you want to create.  Several options are available:
 - **`<linked-type>`** Defines the container type, used in container property types.
 - **`<linked-class>`** Defines the container class, used in container property types.

>**NOTE**: There are several property and link types available. 

**Examples**

- Create the property `name` on the class `User`, of the string type:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE PROPERTY User.name STRING</code>
  </pre>

- Create a list of strings as the property `tags` in the class `Profile`, using an embedded list of the string type.

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE PROPERTY Profile.tags EMBEDDEDLIST STRING</code>
  </pre>

- Create the embedded map property `friends` in the class `Profile`, link it to the class `Profile`.

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE PROPERTY Profile.friends EMBEDDEDMAP Profile</code>
  </pre>

  This forms a circular reference.


>To remove a property, use the [`DROP PROPERTY`](SQL-Drop-Property.md) command.  

## Property Types

When creating properties, you need to define the property type, so that OrientDB knows the kind of data to expect in the field.  There are several standard property types available:

| | | |
|---|---|---|---|
|`BOOLEAN`|`INTEGER`|`SHORT`|`LONG`|
|`FLOAT`|`DATE`|`STRING`|`EMBEDDED`|
|`LINK`|`BYTE`|`BINARY`|`DOUBLE`|

In addition to these, there are several more property types that function as containers. These form lists, sets and maps. Using container property types requires that you also define a link type or class.

|||
|---|---|---|
|`EMBEDDEDLIST`|`EMBEDDEDSET`|`EMBEDDEDMAP`|
|`LINKLIST`|`LINKSET`|`LINKMAP`| 

### Link Types

The link types available are the same as those available as the standard property types:

||||
|---|---|---|---|
|`BOOLEAN`|`INTEGER`|`SHORT`|`LONG`|
|`FLOAT`|`DOUBLE`|`DATE`|`STRING`|
|`BINARY`|`EMBEDDED`|`LINK`|`BYTE`|


>For more information, see [SQL Commands](Commands.md) and [Console Commands](Console-Commands.md).


