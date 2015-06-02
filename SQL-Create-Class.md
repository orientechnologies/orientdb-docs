# SQL - CREATE CLASS

The **Create Class** command creates a new class in the schema. *NOTE: If a cluster with the same name exists in the database will be used as default cluster.*

## Syntax

```sql
CREATE CLASS <class> [EXTENDS <super-class>] [CLUSTER <clusterId>*] [CLUSTERS <total-cluster-number>] [ABSTRACT]
```

Where:
- **class** is the class name to create. The first character must be alphabetic and others can be any alphanumeric characters plus underscore _ and dash -.
- **super-class**, optional, is the super-class to extend
- **clusterId** can be a list separated by comma (,)
- **total-cluster-number** is the number of clusters to create. Default is 1. Since 2.1.
- **ABSTRACT** set the class as abstract in the Object Oriented meaning, so no instances of this class can be created

By default OrientDB creates 1 cluster per class with the same name of the class in lowercase. If you work with multiple cores, we suggest to use multiple clusters to improve concurrency on insert. To change the number of clusters you can set the property ```minimumclusters``` at [database level](SQL-Alter-Database.md) or you can use the `CLUSTERS <total-cluster-number>` syntax (since 2.1).

## Cluster selection strategy
OrientDB, by default, inherits the cluster selection by the [database](SQL-Alter-Database.md). By default is round-robin, but you can always change it after creation with [alter class command](SQL-Alter-Class.md). The supported strategies are:
- **default**, uses always the Class's ```defaultClusterId``` property. This was the default before 1.7
- **round-robin**, put the Class's configured clusters in a ring and returns a different cluster every time restarting from the first when the ring is completed
- **balanced**, checks the records in all the clusters and returns the smaller cluster. This allows the cluster to have all the underlying clusters balanced on size. On adding a new cluster to an existent class, the new empty cluster will be filled before the others because more empty then the others. In distributed configuration when configure clusters on different servers this setting allows to keep the server balanced with the same amount of data. Calculation of cluster size is made every 5 or more seconds to avoid to slow down insertion

## See also
- [alter class](SQL-Alter-Class.md)
- [drop class](SQL-Drop-Class.md)
- [create cluster](SQL-Create-Cluster.md)
- [SQL commands](SQL.md)
- [Console commands](Console-Commands.md)

## Examples

Create the class 'Account':
```sql
CREATE CLASS Account
```

Create the class 'Car' that extends 'Vehicle':
```sql
CREATE CLASS Car extends Vehicle
```

Create the class 'Car' with clusterId 10:
```sql
CREATE CLASS Car CLUSTER 10
```

## Abstract class

Create the class 'Person' as [ABSTRACT](Concepts.md#abstract-class):
```sql
CREATE CLASS Person ABSTRACT
```
