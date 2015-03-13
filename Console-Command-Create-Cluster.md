# Console - CREATE CLUSTER

Creates a new cluster in the current database. The cluster can be "physical" or "memory".

## Syntax

```
create cluster <cluster-name> <cluster-type> <data-segment> <location> <position>
```

Where:

- **cluster-name**   The name of the cluster to create
- **cluster-type**   Cluster type: 'physical' or 'logical'
- **data-segment**   Data segment to use. 'default' will use the default one
- **location**       Location where to place the new cluster files, if appliable. use 'default' to leave into the database directory
- **position**       'append' to add as last cluster, otherwise the empty position to replace

## Example

```java
orientdb> create cluster documents physical default default append

Creating cluster [documents] of type 'physical' in database demo as last one...
PHYSICAL cluster created correctly with id #68
```

## See also

To display all the cluster configured in the current database use the command [clusters](Console-Command-Clusters.md).

To delete a cluster use the command [Drop Cluster](Console-Command-Drop-Cluster.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
