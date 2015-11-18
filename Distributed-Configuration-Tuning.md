# Distributed Configuration Tuning

When you run [distributed](Distributed-Architecture.md) on multiple servers, you could face on a drop of performance you got with single node. While it's normal that replication has a cost, there are many ways to improve performance on distributed configuration:
- [Use transactions](Distributed-Configuration-Tuning.md#use-transactions)
- [Replication vs Sharding](Distributed-Configuration-Tuning.md#replication-vs-sharding)
- [Scale up on writes](Distributed-Configuration-Tuning.md#scale-up-on-writes)
- [Scale up on reads](Distributed-Configuration-Tuning.md#scale-up-on-reads)
- [Replication vs Sharding](Distributed-Configuration-Tuning.md#replication-vs-sharding)

## Generic advice

### Load Balancing
Active [load balancing](Distributed-Configuration.md#load-balancing) to distribute the load across multiple nodes.

### Use transactions
Even though when you update graphs you should always work in transactions, OrientDB allows also to work outside of them. Common cases are read-only queries or massive and non concurrent operations can be restored in case of failure. When you run on distributed configuration, using transactions helps to reduce latency. This is because the distributed operation happens only at commit time. Distributing one big operation is much efficient than transfering small multiple operations, because the latency.

### Replication vs Sharding
OrientDB [distributed configuration](Distributed-Configuration.md) is set to full replication. Having multiple nodes with the very same copy of database is important for HA and scale reads. In facts, each server is independent on executing reads and queries. If you have 10 server nodes, the read throughput is 10x.

With writes it's the opposite: having multiple nodes with full replication slows down operations if the replication is synchronous. In this case [Sharding](Distributed-Sharding.md) the database across multiple nodes allows you to scale up writes, because only a subset of nodes are involved on write. Furthermore you could have a database bigger than one server node HD.

## Scale up on writes
If you have a slow network and you have a synchronous (default) replication, you could pay the cost of latency. In facts when OrientDB runs synchronously, it waits at least for the `writeQuorum`. This means that if the `writeQuorum` is 3, and you have 5 nodes, the coordinator server node (where the distributed operation is started) has to wait for the answer from at least 3 nodes in order to provide the answer to the client. 

In order to maintain the consistency, the `writeQuorum` should be set to the majority. If you have 5 nodes the majority is 3. With 4 nodes is still 3. Setting the `writeQuorum` to 3 instead of 4 or 5 allows to reduce the latency cost and still maintain the consistency.

### Asynchronous replication
To speed up things, you can setup [Asynchronous Replication](Distributed-Configuration.html#asynchronous-replication-mode) to remove the latency bottleneck. In this case the coordinator server node execute the operation locally and gives the answer to the client. The entire replication will be in background. In case the quorum is not reached, the changes will be rollbacked transparently.

## Scale up on reads
If you already set the `writeQuorum` to the majority to the nodes, you can leave the `readQuorum` to 1 (the default). This speeds up all the reads.
