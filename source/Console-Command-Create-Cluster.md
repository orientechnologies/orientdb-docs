# Console - CREATE CLUSTER

Creates a new cluster in the current database. The cluster can be "physical" or "memory".

## Syntax

```
CREATE CLUSTER <cluster-name> <cluster-type> <data-segment> <location> <position>
```

Where:

- **cluster-name**   The name of the cluster to create
- **cluster-type**   Cluster type: 'PHYSICAL' or 'LOGICAL'
- **data-segment**   Data segment to use. 'DEFAULT' will use the default one
- **location**       Location where to place the new cluster files, if applicable. use 'DEFAULT' to leave into the database directory
- **position**       'APPEND' to add as last cluster, otherwise the empty position to replace

## Example

```sql
orientdb> CREATE CLUSTER documents PHYSICAL DEFAULT DEFAULT APPEND

Creating cluster [documents] of type 'PHYSICAL' in database demo as last one...
PHYSICAL cluster created correctly with id #68
```

## See also

To display all the cluster configured in the current database use the command [CLUSTERS](Console-Command-Clusters.md).

To delete a cluster use the command [DROP CLUSTER](Console-Command-Drop-Cluster.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
