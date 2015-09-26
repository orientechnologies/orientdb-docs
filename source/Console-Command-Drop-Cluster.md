# Console - DROP CLUSTER

The **Drop Cluster** command definitely deletes a cluster. This will delete the cluster, all its records and will clear all caches.

>*NOTE: Unless you've made backups there is no way to restore a deleted cluster.*

## Syntax

```sql
DROP CLUSTER <cluster-name>
```

Where:
- **cluster-name** is the name of the cluster.

## Examples

Delete the current local database:

```sql
DROP CLUSTER Person
```

deletes the cluster named 'Person' with all Person records.

To create a new cluster use the [CREATE CLUSTER](Console-Command-Create-Cluster.md) command.

To know more about other SQL commands look at [SQL commands](SQL.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
