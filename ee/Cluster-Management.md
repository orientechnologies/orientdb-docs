---
search:
   keywords: ['Studio', 'cluster', 'cluster management']
---

# Cluster Management
This is the section (available only for the Enterprise Edition) to work with OrientDB Cluster as DBA/DevOps.

>**NOTE**: This feature is available only in the [OrientDB Enterprise Edition](http://orientdb.com/orientdb-enterprise). If you are interested in a commercial license look at [OrientDB Subscription Packages](http://orientdb.com/support).

On the top of the page are reported the number of active nodes joining your cluster.

> Only users with grant `server.metrics` and `server.distributed` can see this section 

## Overview
This page summarizes all the most important information about all servers connected to the cluster:
- `CPU`, `RAM`, `DISK CACHE` and `DISK` used
- `Status`
- `Operations per second`
- `Active Connections`
- `Network Requests`
- `Live chart` with CRUD operations in real-time

It also contains stats about replication messages:

- `Replication Latency Average`: average replication latency between nodes
- `Replication Message Counters`: counters of messages exchanged between nodes;
- `Replication Message Coordinator Stats`: detailed counters of messagges grouped by type, sent by the coordinator.


![Overview](../images/studio-cluster-management-overview.png)

## Databases
In this panel you can see all databases present on each server joining your cluster.
Through the box above you can change in real time the current cluster configuration, without touching the `config/default-distributed-db-config.json` file content. You can set the following parameters:
- `Write Quorum`
- `Read Quorum`
- `Auto Deploy`
- `Hot Alignment`
- `Read your Writes`
- `Failure Available Nodes Less Quorum`
- `Server Roles`, roles may be "Master" or "Replica"

To learn more about these configuration parameters please visit the [Distributed Configuration](../../distributed/Distributed-Configuration.md) section.

![Databases](../images/studio-cluster-management-databases.png)
