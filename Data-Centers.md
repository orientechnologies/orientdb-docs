---
search:
   keywords: ['distributed architecture', 'data center']
---

# Data Centers

Starting from [OrientDB Enterprise Edition](http://orientdb.com/orientdb-enterprise) v2.2.4, you can define how your servers are deployed in multiple **Data Centers**.

![Studio-Data-Centers](images/studio-data-centers.png)

All you need is to use the tag `"dataCenters"` in your [`default-distributed-config.json`](Distributed-Configuration.html#default-distributed-db-configjson) configuration file. This is the format:

```json
  "dataCenters": {
    "<data-center1-name>": {
      "writeQuorum": "<data-center1-quorum>",
      "servers": [ "<data-center1-server1>", "<data-center1-server2>", "<data-center1-serverN>" ]
    },
    "<data-center2-name>": {
      "writeQuorum": "<data-center2-quorum>",
      "servers": [ "<data-center2-server1>", "<data-center2-server2>", "<data-center2-serverN>" ]
    },
  },
```

NOTE: _This feature is available only in the [OrientDB Enterprise Edition](http://orientdb.com/orientdb-enterprise). If you are interested in a commercial license look at [OrientDB Subscription Packages](http://orientdb.com/support)_.

Example:

```json
  "dataCenters": {
    "usa": {
      "writeQuorum": "majority",
      "servers": [ "<austin>", "<paloalto>", "<newyork>" ]
    },
    "europe": {
      "writeQuorum": "majority",
      "servers": [ "<rome>", "<dublin>", "<london>" ]
    },
    "asia": {
      "writeQuorum": "majority",
      "servers": [ "<tokyo>", "<singapore>", "<hongkong>" ]
    }
  },
```

![DC](http://orientdb.com/wp-content/uploads/2016/07/orientdb-dc1.png)

## Write Quorum

The most common reason for defining data centers is to be able to set the consistency level per data center.  A typical scenario is to have synchronous replication between the servers in the same data center where the coordinator server is located and then to propagate changes to the other data centers asynchronously. In this way you can avoid the cost of the replication latency of the servers located at different data centers. In order to activate this mode, set the global `"writeQuorum": "localDataCenter"` and then specify a writeQuorum per data center.

For example, if a write operation is executed by a server where its data center's write quorum setting is `majority`, then the used quorum will be `majority` between only the servers located in the same data center.

Example about the configuration of 2 data centers, "rome" and "austin", with respectively 3 and 2 servers.

```json
{
  "autoDeploy": true,
  "readQuorum": 1,
  "writeQuorum": "localDataCenter",
  "readYourWrites": true,
  "dataCenters": {
    "rome": {
      "writeQuorum": "majority",
      "servers": [ "europe-0", "europe-1", "europe-2" ]
    },
    "austin": {
      "writeQuorum": "majority",
      "servers": [ "usa-0", "usa-1" ]
    }
  },
  "servers": { "*": "master" },
  "clusters": {
    "internal": {},
    "*": { "servers": [ "<NEW_NODE>" ] }
  }
}
```

If a write operation is executed on the server "europe-0", the quorum used will be `majority`, but only between the servers located in the same data center: namely "europe-0" (the coordinator), "europe-1", and "europe-2". Since the coordinator writes in the database before distributing the operation, the write operation succeeds as soon as at least one other local server ("europe-1" or "europe-2") responds with the same result. The rest of the replication to the other data centers will be executed asynchronously.

## Consistency

Since multiple data centers can have a local quorum, it is possible to have **Eventual Consistency** between them. It's always suggested to keep the number of servers odd, so you can, eventually, always be consistent. Example of 2 data centers with an equal number of servers:

```json
  "dataCenters": {
    "rome": {
      "writeQuorum": "all",
      "servers": [ "europe-0", "europe-1", "europe-2" ]
    },
    "austin": {
      "writeQuorum": "all",
      "servers": [ "usa-0", "usa-1", "usa-2" ]
    }
```

In this case if an UPDATE operation is executed by the server "usa-0" (the coordinator), it will reach the quorum only if `all` the servers in the "austin" data center provide the same result. Let's say the result for all these 2 servers was `5` (in the UPDATE operation the result is the updated version of the record). But what happens if all the other 3 servers in "rome" return the version `6`? You have no majority in this case (3 against 3), so the coordinator cannot establish who is the winner. The database become inconsistent.

In order to automatically manage conflicts, the suggested configuration is always to keep an **odd number** of servers whether you use multiple data centers or not.

## Conflict Resolution Policy

In case of an even number of servers or when database are not aligned, OrientDB uses a Conflict Resolution Strategy chain. This default chain is defined as a global setting (`distributed.conflictResolverRepairerChain`):

`-Ddistributed.conflictResolverRepairerChain=majority,content,version`

The Conflict Resolution Strategy implementation are called in chain until a winner is selected. In the default configuration (above):
- is first checked if there is a **strict majority** for the record in terms of record versions. If the majority exists, the winner is selected
- if no strict majority was found, the **record content** is analyzed. If the majority is reached by founding a record with different versions but equal content, then that record will be the winner by using the higher version between them
- if no majority has been found with the content, then the higher version wins (supposing an higher version means the most update record)

At the end of the chain, if no winner is found, the records are untouched and only a manual intervention can decide who is the winner.
