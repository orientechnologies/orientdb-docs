# SQL - TRUNCATE CLASS

The **Truncate Class** command deletes the records of all the clusters defined as part of the class. By default every class has one cluster associated with the same name. This command acts at lower level then [SQL Delete Command](SQL-Delete.md).

## Syntax

```
TRUNCATE CLASS <class-name>
```

Where:
- **class-name** is the name of the class

## Examples

Remove all the record of class "Profile":
```java
TRUNCATE CLASS Profile
```

See also [SQL Delete Command](SQL-Delete.md) and [SQL Truncate Cluster Command](SQL-Truncate-Cluster.md). To create a new class use the [Create Class](SQL-Create-Class.md) command.

To know more about other SQL commands look at [SQL commands](SQL.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
