# Distributed Configuration Tuning

When you run [distributed](Distributed-Architecture.md) on multiple servers, you could face on a drop of performance you got with single node. While it's normal that replication has a cost, there are many ways to improve perormance on distributed configuration:
- [Use transactions](Distributed-Configuration-Tuning.md#use-transactions)

## Use transactions
Even though when you update graphs you should always work in transactions, OrientDB allows also to work outside of them. Common cases are read-only queries or massive and non concurrent operations can be restored in case of failure. When you run on distributed configuration, using transactions helps to reduce latency. This is because the distributed operation happens only at commit time. Distributing one big operation is much efficient than transfering small multiple operations, because the latency.

## Asynchronous replication
If you have a slow network and you have a synchronous (default) replication, you could pay the cost of latency. In facts when OrientDB runs synchronously, it waits at least for the `writeQuorum`. This means that if the  `writeQuorum` is 3, and you have 5 nodes, the coordinator server node (where the distributed operation is started) has to wait for the answer from at least 3 nodes in order to provide the answer to the client. 

To improve
