---
search:
   keywords: ['SQL', 'command', 'alter', 'property', 'properties', 'ALTER PROPERTY']
---

# SQL - `ALTER PROPERTY`

Updates attributes on the existing property and class in the schema.

**Syntax**

```xml
ALTER PROPERTY <class>.<property> <attribute-name> <attribute-value>
```

- **`<class>`** Defines the class to which the property belongs.
- **`<property>`** Defines the property you want to update.
- **`<attribute-name>`** Defines the attribute you want to change.
- **`<attribute-value>`** Defines the value you want to set on the attribute.



**Examples**

- Change the name of the property `age` in the class `Account` to `born`:

  <pre>
  orientdb> <code class="lang-sql userinput">ALTER PROPERTY Account.age NAME born</code>
  </pre>

- Update a property to make it mandatory:

  <pre>
  orientdb><code class="lang-sql userinput">ALTER PROPERTY Account.age MANDATORY TRUE</code>
  </pre>

- Define a Regular Expression as constraint:

  <pre>
  orientdb> <code class="lang-sql userinput">ALTER PROPERTY Account.gender REGEXP "[M|F]"</code>
  </pre>

- Define a field as case-insensitive to comparisons:

  <pre>
  orientdb> <code class="lang-sql userinput">ALTER PROPERTY Employee.name COLLATE ci</code>
  </pre>

- Define a custom field on a property:

  <pre>
  orientdb> <code class="lang-sql userinput">ALTER PROPERTY Foo.bar1 custom stereotype="visible"</code>
  </pre>

- Set the default value for the current date:

  <pre>
  orientdb> <code class="lang-sql userinput">ALTER PROPERTY Client.created DEFAULT "sysdate()"</code>
  </pre>

- Define a unqiue id that cannot be changed after creation:

  <pre>
  orientdb> <code class="lang-sql userinput">ALTER PROPERTY Client.id DEFAULT "uuid()" READONLY</code>
  orientdb> <code class="lang-sql userinput">ALTER PROPERTY Client.id READONLY TRUE</code>
  </pre>





## Supported Attributes

|Attribute|Type|Support|Description|
|---|---|---|---|
| `LINKEDCLASS` | String | | Defines the linked class name.  Use `NULL` to remove an existing value.|
| `LINKEDTYPE` | String | | Defines the [link type](Types.md).  Use `NULL` to remove an existing value.|
| `MIN` | Integer | | Defines the minimum value as a constraint.  Use `NULL` to remove an existing constraint.  On String attributes, it defines the minimum length of the string.  On Integer attributes, it defines the minimum value for the number.  On Date attributes, the earliest date accepted.  For multi-value attributes (lists, sets and maps), it defines the fewest number of entries.|
| `MANDATORY` | Boolean | | Defines whether the property requires a value. |
| `MAX` | Integer | | Defines the maximum value as a constraint.  Use `NULL` to remove an existing constraint.  On String attributes, it defines the greatest length of the string.  On Integer attributes, it defines the maximum value for the number.  On Date attributes, the last date accepted.  For multi-value attributes (lists, sets and maps), it defines the highest number of entries.|
| `NAME` | String || Defines the property name.|
| `NOTNULL` | Boolean || Defines whether the property can have a null value. |
| `REGEX` | String || Defines a Regular Expression as constraint.  Use `NULL` to remove an existing constraint.|
| `TYPE` | String || Defines a [property type](Types.md).|
| `COLLATE` | String || Sets collate to one of the defined comparison strategies.  By default, it is set to case-sensitive (`cs`).  You can also set it to case-insensitive (`ci`).|
| `READONLY` | Boolean || Defines whether the property value is immutable.  That is, if it is possible to change it after the first assignment.  Use with `DEFAULT` to have immutable values on creation.|
| `CUSTOM` | String || Defines custom properties.  The syntax for custom properties is `<custom-name> = <custom-value>`, such as `stereotype = icon`. The custom name is an identifier, so it has to be back-tick quoted if it contains special characters (eg. dots); the value is a string, so it has to be quoted with single or double quotes.|
| `DEFAULT` | || Defines the default value or function.  Feature introduced in version 2.1, (see the section above for examples). Use `NULL` to remove an existing constraint.|

When altering `NAME` or `TYPE` this command runs a data update that may take some time, depending on the amount of data.  Don't shut the database down during this migration. When altering property name, the old value is copied to the new property name.



>To create a property, use the [`CREATE PROPERTY`](SQL-Create-Property.md) command, to remove a property the [`DROP PROPERTY`](SQL-Drop-Property.md) command.  For more information on other commands, see [Console](Console-Commands.md) and [SQL](SQL.md) commands.
