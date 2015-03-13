# Distributed Architecture

OrientDB can be distributed across different servers and used in different ways to achieve the maximum of performance, scalability and robustness.

OrientDB uses the [Hazelcast Open Source project](http://www.hazelcast.com) to manage the clustering. Many of the references in this page are linked to the Hazelcast official documentation to get more information about such topic.

## Presentation 
<div>
<iframe src="http://www.slideshare.net/slideshow/embed_code/38975360" width="760px" height="570px" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:none;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>
</div>

## Main topics
- [Distributed Architecture Lifecycle](Distributed-Architecture-Lifecycle.md)
- [Configure the Cluster of servers](Distributed-Configuration.md)
- [Replication](Replication.md) of databases
- [Sharding](Distributed-Sharding.md)
- [Distributed Cache](Distributed-Cache.md)
- [Tutorial to setup a distributed database](Tutorial-Setup-a-distributed-database.md)

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

## Limitations
OrientDB v 2.0.x has some limitations you should notice when you work in Distributed Mode:
- `hotAlignment:true` could bring the database status as inconsistent. Please set it always to 'false`, the default
- creation of a database on multiple nodes could cause synchronization problems when clusters are automatically created. Please create the databases before to run in distributed mode
- split network case: this is not well managed and in case you setup 4 nodes and the network is split between 2 nodes on the left, and 2 nodes on the right, each partition will think to be the only survived and on rejoin database could be inconsistent. Please always setup an odd number of nodes, so there will always be a majority in quorum
- if an error happen during CREATE RECORD, the operation is fixed across the entire cluster, but some node could have a wrong RID upper bound (the created record, then deleted as fix operation). In this case a new database deploy operation must be executed
- Constraints with distributed databases could cause problems because some operations are executed at 2 steps: create + update. For example in some circumstance edges could be first created, then updated, but constraints like MANDATORY and NOTNULL against fields would fail at the first step making the creation of edges not possible on distributed mode.