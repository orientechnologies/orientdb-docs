# SQL - DROP PROPERTY

The **Drop Property** command removes a property from the schema. This doesn't remove the property values in records, but just change the schema information. Records will continue to have the property values if any.

## Syntax

```xml
DROP PROPERTY <class>.<property>
```

Where:
- **class** is the class of the schema
- **property**, is the property created into the **class**

## Examples

Remove the property 'name' in class 'User':

```java
DROP PROPERTY user.name
```

To create a new property use the [Create Property](SQL-Create-Property.md) command.

To know more about other SQL commands look at [SQL commands](SQL.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
