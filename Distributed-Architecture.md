# Distributed Architecture

OrientDB can be distributed across different servers and used in different ways to achieve the maximum of performance, scalability and robustness.

OrientDB uses the [Hazelcast Open Source project](http://www.hazelcast.com) to manage the clustering. Many of the references in this page are linked to the Hazelcast official documentation to get more information about such topic.

## Presentation 
<div>
<iframe src="https://www.slideshare.net/slideshow/embed_code/38975360" width="760px" height="570px" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:none;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>
</div>

## Main topics
- [Distributed Architecture Lifecycle](Distributed-Architecture-Lifecycle.md)
- [Configure the Cluster of servers](Distributed-Configuration.md)
- [Replication](Replication.md) of databases
- [Sharding](Distributed-Sharding.md)
- [Distributed Cache](Distributed-Cache.md)
- [Tutorial to setup a distributed database](Tutorial-Setup-a-distributed-database.md)
- [Tuning](Distributed-Configuration-Tuning.md)

## Server roles
OrientDB has a multi-master distributed architecture (called also as "master-less") where each server can read and write. Starting from v2.1, OrientDB support the role of "REPLICA", where the server is in read-only mode, accepting only idempotent commands, like Reads and Query. Furthermore when the server joins the distributed cluster as "REPLICA", own record clusters are not created like does the "MASTER" nodes.

## Creation of records (documents, vertices and edges)

In distributed mode the [RID](Concepts.md#rid) is assigned with cluster locality. If you have class `Customer` and 3 nodes (node1, node2, node3), you'll have these clusters:
- `customer` with id=#15 (this is the default one, assigned to node1)
- `customer_node2` with id=#16
- `customer_node3` with id=#17

So if you create a new Customer on node1, it will get the [RID](Concepts.md#rid) with cluster-id of "customer" cluster: #15. The same operation on node2 will generate a [RID](Concepts.md#rid) with cluster-id=16 and 17 on node3.

In this way [RID](Concepts.md#rid) never collides and each node can be a master on insertion without any conflicts.

## Distributed transactions

Starting from v1.6, OrientDB supports distributed transactions. When a transaction is committed, all the updated records are sent across all the servers, so each server is responsible to commit the transaction. In case one or more nodes fail on commit, the quorum is checked. If the quorum has been respected, then the failing nodes are aligned to the winner nodes, otherwise all the nodes rollback the transaction.

### What about the visibility during distributed transaction?

During the distributed transaction, in case of rollback, there could be an amount of time when the records appear changed before they are rollbacked.

# Split brain network problem
OrientDB guarantees strong consistency if it's configured to have a `writeQuorum` set to a value as the majority of the number of nodes. I you have 5 nodes, it's 3, but if you have 4 nodes, it's still 3 to have a majority. While `writeQuorum` setting can be configured at database and cluster level too, it's not suggested to set a value minor than the majority of nodes, because in case of re-merge of the 2 split networks, you'd have both network partitions with updated data and OrientDB doesn't support (yet) the merging of 2 non read-only networks. So the suggestion is to always provide a `writeQuorum` with a value to, at least, the majority of the nodes.

## Limitations
OrientDB v2.1.x has some limitations you should notice when you work in Distributed Mode:
- `hotAlignment:true` could bring the database status as inconsistent. Please set it always to 'false', the default
- Creation of a database on multiple nodes could cause synchronization problems when clusters are automatically created. Please create the databases before to run in distributed mode
- If an error happen during CREATE RECORD, the operation is fixed across the entire cluster, but some node could have a wrong RID upper bound (the created record, then deleted as fix operation). In this case a new database deploy operation must be executed
- Constraints with distributed databases could cause problems because some operations are executed at 2 steps: create + update. For example in some circumstance edges could be first created, then updated, but constraints like MANDATORY and NOTNULL against fields would fail at the first step making the creation of edges not possible on distributed mode.
- Auto-Sharding is not supported in the common meaning of Distributed Hash Table (DHT). Selecting the right shard (cluster) is up to the application. This will be addressed by next releases
- Sharded Indexes are not supported
- If hotAlignment=false is set, when a node re-joins the cluster (after a failure or simply unreachability) the full copy of database from a node could have no all information about the shards
- Hot change of distributed configuration not available. This will be introduced at release 2.0 via command line and in visual way in the Workbench of the Enterprise Edition (commercial licensed)
- Not complete merging of results for all the projections when running on sharder configuration. Some functions like AVG() doesn’t work on map/reduce
