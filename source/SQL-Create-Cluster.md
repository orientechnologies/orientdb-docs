# SQL - CREATE CLUSTER

The **Create Cluster** command creates a new cluster in database. Once created, the cluster can be used to save records by specifying its name during save. If you want to add the cluster to a class, use rather the [Alter Class](SQL-Alter-Class.md) command using ADDCLUSTER property. 

## Syntax

```sql
CREATE CLUSTER <name> [POSITION <position>|append]
```

Where:
- *name* is the cluster name to create. The first character must be alphabetic and others can be any alphanumeric characters plus underscore _ and dash -.
- *position*, optional, is the position where to add the cluster. If omitted or it's equals to 'default' the cluster is appended at the end

## Examples

Create the cluster 'Account':
```java
CREATE CLUSTER account
```

To remove a cluster use the [Drop Cluster](SQL-Drop-Cluster.md) command.

To know more about other SQL commands look at [SQL commands](SQL.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
