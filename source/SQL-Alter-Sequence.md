# SQL - ALTER PROPERTY

The **Alter Property** command alters a class's property in the schema.  
 

## Syntax

```xml
ALTER PROPERTY <class>.<property> <attribute-name> <attribute-value>
```

Where:
- **class** is the class owner of the property to change
- **property** is the property name to change
- **attribute-name**, is the attribute name to alter
- **attribute-value**, is the new attribute value to set

Supported attribute names are:
- **LINKEDCLASS**, the linked class name. Accepts a string as value. NULL to remove it
- **LINKEDTYPE**, the linked type name between those supported:[Types](Types.md). Accepts a string as value. NULL to remove it
- **MIN**, the minimum value as constraint. NULL to remove it. Accepts strings, numbers or dates as value depending on the type:
 - `String` set the minimum length of the string
 - `Numbers` set the minimum value for the number
 - `Date` set the minimum date accepted
 - `Multi-Value` (List, Set, Maps) set the minimum number of entries
- **MANDATORY**, true if the property is mandatory. Accepts "true" or "false"
- **MAX**, the maximum value as constraint. NULL to remove it. Accepts strings, numbers or dates as value depending on the type:
 - `String` set the maximum length of the string
 - `Numbers` set the maximum value for the number
 - `Date` set the maximum date accepted
 - `Multi-Value` (List, Set, Maps) set the maximum number of entries
- **NAME**, the property name. Accepts a string as value
- **NOTNULL**, the property can't be null. Accepts "true" or "false"
- **REGEXP** the regular expression as constraint. Accepts a string as value. NULL to remove it
- **TYPE**, the type between those supported:[Types](Types.md) Accepts a string as value
- **COLLATE**, sets the collate to define the strategy of comparison. By default is case sensitive. By setting it yo "ci", any comparison will be case-insensitive
- **READONLY** the property value is immutable: it can't be changed after the first assignment. Use this with DEFAULT to have immutable values on creation. Accepts "true" or "false"
- **CUSTOM** Set custom properties. Syntax is <code>&lt;name&gt; = &lt;value&gt;</code>. Example: stereotype = icon
- **DEFAULT** (Since 2.1) set the default value. Default value can be a value or a function. See below for examples

In case of alter of **NAME** or **TYPE** this command will run a data update that may take some time, depends on the amount of data, don't shutdown the database while this migration is running.

## Examples

### Change the name of the property 'age' in class 'Account' in 'born'

```java
ALTER PROPERTY Account.age NAME born
```

### Set a property as mandatory

```java
ALTER PROPERTY Account.age MANDATORY true
```

### Set a regexp

```java
ALTER PROPERTY Account.gender REGEXP [M|F]
```


### Set a field as case insensitive to comparison

```java
ALTER PROPERTY Employee.name COLLATE ci
```


### Set a custom field on property

```java
ALTER PROPERTY Foo.bar1 custom stereotype = visible
```

### Set default value to current date

```java
ALTER PROPERTY Client.created default sysdate()
```

### Set a unique id can never change
```java
ALTER PROPERTY Client.id default uuid() readonly
ALTER PROPERTY Client.id readonly true
```

To create a property use the [Create Property](SQL-Create-Property.md) command, to remove a property use the [Drop Property](SQL-Drop-Property.md) command.

To know more about other SQL commands look at [SQL commands](SQL.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
