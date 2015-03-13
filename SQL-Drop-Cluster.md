# SQL - DROP CLUSTER

The **Drop Cluster** command removes a cluster and all its content. This operation cannot be rollbacked.

## Syntax

```sql
DROP CLUSTER <cluster-name>|<cluster-id>
```

Where:
- **cluster-name** is the cluster name as string
- **cluster-id** is the cluster id as integer

## See also
- [create cluster](SQL-Create-Cluster.md)
- [alter cluster](SQL-Alter-Cluster.md)
- [drop class](SQL-Drop-Class.md)
- [SQL commands](SQL.md)
- [Console commands](Console-Commands.md)

## Examples

Remove the cluster 'Account':
```sql
DROP CLUSTER Account
```
