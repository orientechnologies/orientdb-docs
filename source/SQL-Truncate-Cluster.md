# SQL - TRUNCATE CLUSTER

The **Truncate Cluster** command deletes all the records of a cluster. This command acts at lower level then [SQL Delete Command](SQL-Delete.md).

## Syntax

```
TRUNCATE CLUSTER <cluster-name>
```

Where:
- **cluster-name** is the name of the cluster

## Examples

Remove all the records in the cluster "Profile":

```java
TRUNCATE CLUSTER Profile
```

See also [SQL Delete Command](SQL-Delete.md) and [SQL Truncate Class](SQL-Truncate-Class.md) commands.

To know more about other SQL commands look at [SQL commands](SQL.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
