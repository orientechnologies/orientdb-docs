---
search:
   keywords: ['distributed', 'architecture', 'distributed architecture']
---

# Distributed Architecture

OrientDB can be distributed across different servers and used in different ways to achieve the maximum of performance, scalability and robustness.

OrientDB uses the [Hazelcast Open Source project](http://www.hazelcast.com) for auto-discovering of nodes, storing the runtime cluster configuration and synchronize certain operations between nodes. Some of the references in this page are linked to the Hazelcast official documentation to get more information about such topic.

_NOTE: When you run in distributed mode, OrientDB needs more RAM. The minimum is 2GB of heap, but we suggest to use at least 4GB of heap memory. To change the heap modify the Java memory settings in the file `bin/server.sh` (or server.bat on Windows)._

## Presentation 

Below you can find a presentation of the OrientDB replication. _NOTE: Starting from v2.2, OrientDB uses internal binary protocol for replication and not Hazelcast queues anymore_.
<div>
<iframe src="https://www.slideshare.net/slideshow/embed_code/38975360" width="760px" height="570px" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:none;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>
</div>

## Main topics
- [Distributed Architecture Lifecycle](Distributed-Architecture-Lifecycle.md)
- [Configure the Cluster of servers](Distributed-Configuration.md)
- [Replication](Replication.md) of databases
- [Sharding](Distributed-Sharding.md)
- [Data Centers](Data-Centers.md)
- [Tutorial to setup a distributed database](Tutorial-Setup-a-distributed-database.md)
- [Tuning](Distributed-Configuration-Tuning.md)

## Basic concepts
### Server roles
OrientDB has a multi-master distributed architecture (called also as "master-less") where each server can read and write. Starting from v2.1, OrientDB support the role of "REPLICA", where the server is in read-only mode, accepting only idempotent commands, like Reads and Query. Furthermore when the server joins the distributed cluster as "REPLICA", own record clusters are not created like does the "MASTER" nodes.

Starting from v2.2, the biggest advantage of having many REPLICA servers is that they don't concur in `writeQuorum`, so if you have 3 MASTER servers and 100 REPLICA servers, every write operation will be replicated across 103 servers, but the majority of the `writeQuorum` would be just 2, because given N/2+1, N is the number of MASTER servers. In this case after the operation is executed locally, the server coordinator of the write operation has to wait only for one more MASTER server.

### Cluster Ownership

When new records (documents, vertices and edges) are created in distributed mode, the [RID](Concepts.md#record-id) is assigned by following the "cluster locality", where every server defines a "own" record cluster where it is able to create records. If you have the class `Customer` and 3 server nodes (node1, node2, node3), you'll have these clusters (names can be different):
- `customer` with id=#15 (this is the default one, assigned to node1)
- `customer_node2` with id=#16
- `customer_node3` with id=#17

So if you create a new Customer on node1, it will get the [RID](Concepts.md#record-id) with cluster-id of "customer" cluster: #15. The same operation on node2 will generate a [RID](Concepts.md#record-id) with cluster-id=16 and 17 on node3. In this way [RID](Concepts.md#record-id) never collides and each node can be a master on insertion without any conflicts, because each node manages own [RIDs](Concepts.md#record-id). Starting from v2.2, if a node has more than one cluster per class, a round robin strategy is used to balance the assignment between all the available local clusters.

Ownership configuration is stored in the [default-distributed-db-config.json](Distributed-Configuration.md#default-distributed-db-configjson) file. By default the server owner of the cluster is the first in the list of servers. For example with this configuration:
```json
"client_usa": {
  "servers" : [ "usa", "europe", "asia" ]
},
"client_europe": {
  "servers" : [ "europe", "asia", "usa" ]
}
```

The server node "usa" is the owner for cluster `client_usa`, so "usa" is the only server can create records on such cluster. Since every server node has own cluster per class, every node is able to create records, but on different clusters. Since the record clusters are part of a class, when the user executes a `INSERT INTO client SET name = "Jay"`, the local cluster is selected automatically by OrientDB to store the new "client" record. If this INSERT operation is executed on the server "usa", the "client_usa" cluster is selected. If the sam eoperation is executed on the server "europe", then the cluster "client_europe" would be selected. The important thing is that from a logical point of view, both records from clusters "client_usa" and "client_europe" are always instances of "client" class, so if you execute the following query `SELECT * FROM client`, both record would be retrieved.

#### Static Owner

Starting from v2.2, you can stick a node as owner, no matter the runtime configuration. We call this "static owner". For this purpose use the `"owner" : "<NODE_NAME>"`. Example:

```json
"client_usa": {
  "owner": "usa",
  "servers" : [ "usa", "europe", "asia" ]
}
```

With the configuration above, if the "usa" server is unreachable, the ownership of the cluster "client_usa" is not reassigned, so you can't create new records on that cluster until the server "usa" is back online. The static owner comes useful when you want to partition your database to be sure all the inserts come to a particular node.

### Distributed transactions

OrientDB supports distributed transactions. When a transaction is committed, all the updated records are sent across all the servers, so each server is responsible to commit the transaction. In case one or more nodes fail on commit, the quorum is checked. If the quorum has been respected, then the failing nodes are aligned to the winner nodes, otherwise all the nodes rollback the transaction.

When running distributed, the transactions use a 2 phase lock like protocol, with the cool thing that everything is optimistic, so no locks between the begin and the commit, but everything is executed at commit time only.

During the commit time, OrientDB acquires locks on the touched records and check the version of records (optimistic MVCC approach). At this point this could happen:
- All the record can be locked and nobody touched the records since the beginning of the tx, so the transaction is committed. Cool.
- If somebody modified any of the records that are part of the transaction, the transaction fails and the client can retry it
- If at commit time, another transaction locked any of the same records, the transaction fails, but the retry in this case is automatic and configurable

If you have 5 servers, and writeQuorum is the majority (N/2+1 = 3), this could happen:
- All the 5 servers commit the TX: cool
- 1 or 2 servers report any error, the TX is still committed (quorum passes) and the 1 or 2 servers will be forced to have the same result as the others
- 3 servers or more have different results/errors, so the tx is rollbacked on all the servers to the initial state


#### What about the visibility during distributed transaction?

During the distributed transaction, in case of rollback, there could be an amount of time when the records appear changed before they are rollbacked.

## Split brain network problem
OrientDB guarantees strong consistency if it's configured to have a `writeQuorum` set to a value as the majority of the number of nodes. If you have 5 nodes, it's 3, but if you have 4 nodes, it's still 3 to have a majority. While `writeQuorum` setting can be configured at database and cluster level too, it's not suggested to set a value minor than the majority of nodes, because in case of re-merge of the 2 split networks, you'd have both network partitions with updated data and OrientDB doesn't support (yet) the merging of 2 non read-only networks. So the suggestion is to always provide a `writeQuorum` with a value to, at least, the majority of the nodes.

## Limitations
OrientDB v2.2.x has some limitations you should notice when you work in Distributed Mode:
- In memory database is not supported.
- Importing a database while running distributed is not supported. Import the database in non-distributed mode and then run the OrientDB in distributed mode.
- With releases < v2.2.6 the creation of a database on multiple nodes could cause synchronization problems when clusters are automatically created. Please create the databases before to run in distributed mode.
- Constraints with distributed databases could cause problems because some operations are executed at 2 steps: create + update. For example in some circumstance edges could be first created, then updated, but constraints like MANDATORY and NOTNULL against fields would fail at the first step making the creation of edges not possible on distributed mode.
- Auto-Sharding is not supported in the common meaning of Distributed Hash Table (DHT). Selecting the right shard (cluster) is up to the application. This will be addressed by next releases.
- Sharded Indexes are not supported yet, so creating a UNIQUE index against a sharded class doesn't guarantee a key to be unique. This will be addressed with Auto-sharding in the further releases.
- Hot change of distributed configuration is available only in Enterprise Edition (commercial licensed).
- Not complete merging of results for all the projections when running on sharder configuration. Some functions like AVG() doesn’t work on map/reduce.
