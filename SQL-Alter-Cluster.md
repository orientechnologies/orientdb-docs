# SQL - ALTER CLUSTER

The **Alter Cluster** command updates a cluster.

## Syntax

```sql
ALTER CLUSTER <cluster-name>|<cluster-id> <attribute-name> <attribute-value>
```

Where:
- **cluster-name** name of the cluster to modify. Starting form v2.2, wildcard `*` is accepted at the end of the name to change multiple clusters all together. Example: `alter cluster employee* status offline` to put offline all the cluster with name start starts with employee
- **cluster-id** id of the cluster to modify
- **attribute-name** between those supported:
 - **NAME** cluster's name
 - **STATUS** change the cluster's status. Allowed values: ONLINE, OFFLINE. By default clusters are ONLINE. To put  cluster offline, change it status to OFFLINE. Once offline, the physical files of the cluster will be not open by OrientDB. This feature is useful when you want to archive old data elsewhere and restore when needed
 - **COMPRESSION** compression used between: nothing, snappy, gzip and any other compression registered in OCompressionFactory class. OrientDB calls the compress() method every time it saves a record to the storage, and uncompress() every time it loads a record from the storage. You can also use the OCompression interface to manage encryption
 - **USE_WAL** use the Journal (Write Ahead Log) when OrientDB operates against the cluster
 - **RECORD_GROW_FACTOR** grow factor to save more space on record creation. This is useful when you plan to update the record with additional information. Bigger record avoids defragmentation because OrientDB has not to find a new space in case of update with more data
 - ** RECORD_OVERFLOW_GROW_FACTOR** like RECORD_GROW_FACTOR, but on update. When the size limit is reached this setting is considered to get more space (factor > 1)
 - **CONFLICTSTRATEGY**, (since 2.0) is the name of the strategy used to handle conflicts when OrientDB's MVCC finds an update or delete operation executed against an old record. If not defined a strategy at cluster level, the database configuration is taken (use [ALTER DATABASE](SQL-Alter-Database.md) command for this). While it's possible to inject custom logic by writing a Java class, the out of the box modes are:
  - `version`, the default, throws an exception when versions are different
  - `content`, in case the version is different, it checks if the content is changed, otherwise use the highest version and avoid throwing exception
  - `automerge`, merges the changes
- **attribute-value** attribute's value to set

## See also
- [create cluster](SQL-Create-Cluster.md)
- [drop cluster](SQL-Drop-Cluster.md)
- [alter class](SQL-Alter-Class.md)
- [SQL commands](SQL.md)
- [Console commands](Console-Commands.md)

## Examples

```sql
ALTER CLUSTER profile NAME profile2
```

```sql
ALTER CLUSTER 9 NAME profile2
```

```sql
ALTER CLUSTER V CONFLICTSTRATEGY automerge
```

### Put a cluster offline
```sql
ALTER CLUSTER V_2012 STATUS OFFLINE
```


To know more about other SQL commands, take a look at [SQL commands](SQL.md).
