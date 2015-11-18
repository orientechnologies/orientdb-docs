# SQL - ALTER CLASS

The **Alter Class** command alters a class in the schema.

## Syntax

```sql
ALTER CLASS <class> <attribute-name> <attribute-value>
```

Where:
- **class** is the class name to change
- **attribute-name**, is the attribute name to alter. Supported attribute names are:
 - **NAME**, the class name. Accepts a string as the value.
 - **SHORTNAME**, a short name (alias) for the class. Accepts a string as the value. NULL to remove it.
 - **SUPERCLASS**, the superclasses to assign. Accepts a string as the value. NULL to remove it. Starting from v2.1 multiple inheritance is supported by passing a list of class names. To add a new class you can also use the syntax `+<class>` and `-<class>` to remove it. Look at the examples below.
 - **OVERSIZE**, the oversize factor. Accepts a decimal number as the value.
 - **ADDCLUSTER**, add a cluster to be part of the class. If the cluster doesn't exist, a physical cluster is created automatically. See also [Create Cluster](SQL-Create-Cluster.md) command. Adding clusters to classes is also useful to store records in distributed servers. Look at [Distributed Sharding](Distributed-Sharding.md)
 - **REMOVECLUSTER**, remove a cluster from a class. The cluster will be not deleted.
 - **STRICTMODE**, enable or disable the strict mode. With the strict mode enabled you work in schema-full mode and you can't add new properties to the record if they're in the class's schema definition.
 - **CLUSTERSELECTION** sets the strategy used on selecting the cluster where to create new records. On class creation the setting is inherited by the database's [cluster-selection property](SQL-Alter-Database.md). For more information look also at [Cluster Selection](Cluster-Selection.md).
 - **CUSTOM**, to set custom properties. Property name and value must be expressed using the syntax: "<code>&lt;name&gt;=&lt;value&gt;</code>" without spaces between name and value.
 -  **ABSTRACT** convert to an abstract class or opposite using true and false
- **attribute-value**, is the new attribute value to set.

## See also
- [create class](SQL-Create-Class.md)
- [drop class](SQL-Drop-Class.md)
- [alter cluster](SQL-Alter-Cluster.md)
- [SQL commands](SQL.md)
- [Console commands](Console-Commands.md)

## Examples

### Set the super class

```sql
ALTER CLASS Employee SUPERCLASS Person
```

### Set super classes
(Since v2.1)

```sql
ALTER CLASS Employee SUPERCLASS Person, ORestricted
```

### Add a super class
(Since v2.1)

```sql
ALTER CLASS Employee SUPERCLASS +Person
```

### Remove a super class
(Since v2.1)

```sql
ALTER CLASS Employee SUPERCLASS -Person
```

### Change the name of the class 'Account'

```sql
ALTER CLASS Account NAME Seller
```

### Change the oversize factor of the class 'Account'

```
ALTER CLASS Account OVERSIZE 2
```

### Add a cluster

To add a cluster by name to a class. If the cluster doesn't exist, it's created automatically:
```
ALTER CLASS Account ADDCLUSTER account2
```

### Remove a cluster

To remove a cluster by id to a class without dropping the cluster:
```
ALTER CLASS Account REMOVECLUSTER 34
```

## Add Custom properties

To add custom properties (in this case used in [Record level security](Security.md#record_level_security)):
```sql
ALTER CLASS Post CUSTOM onCreate.fields=_allowRead,_allowUpdate
ALTER CLASS Post CUSTOM onCreate.identityType=role
```

### Change the cluster selection strategy

To add a new cluster to a class and set its cluster-selection strategy as "balanced":

```sql
CREATE CLUSTER Employee_1
ALTER CLASS ADDCLUSTER Employee_1
ALTER CLASS CLUSTERSELECTION balanced
```

### Convert a class to ABSTRACT

```sql
ALTER CLASS TheClass ABSTRACT true
```

## History
### 1.7
- Added support for CLUSTERSELECTION that sets the strategy used on selecting the cluster to use when creating new records.
### 2.1
- Added support for multiple inheritance
