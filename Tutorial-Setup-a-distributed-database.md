# Setup a Distributed Database
OrientDB can run in a [Distributed Architecture](Distributed-Architecture.md) by sharing a database across multiple server instances.

For the purpose of this tutorial we're going to run two servers. There are two ways to share the same database across multiple nodes:
- Prior to startup, copy the specific database directory (under /databases) to all the servers.
- Alternately, keep the database on the first node running and then start up each subsequent database instance. The default configuration automatically shares the database with new servers that join.

## Start the first server node
To start OrientDB in distributed mode, don't use `bin/server.sh` (or `.bat` on Windows), but rather the `bin/dserver.sh` (or `bin\dserver.bat`) script:

```
> cd bin
> ./dserver.sh
```

Note that the same configuration file `orientdb-server-config.xml` is still used. For more information, look at [Distributed Configuration](Distributed-Configuration.md).

When starting the distributed server (dserver) for the first time, you will be prompted to enter the node name:

```
+---------------------------------------------------------------+
|         WARNING: FIRST DISTRIBUTED RUN CONFIGURATION          |
+---------------------------------------------------------------+
| This is the first time that the server is running as          |
| distributed. Please type the name you want to assign to the   |
| current server node.                                          |
|                                                               |
| To avoid this message set the environment variable or JVM     |
| setting ORIENTDB_NODE_NAME to the server node name to use.    |
+---------------------------------------------------------------+

Node name [BLANK=auto generate it]:
```

Once entered, the node name will be stored in the nodeName parameter of the OHazelcastPlugin in the orientdb-server-config.xml file.

Upon starting, OrientDB loads all the databases in the "databases" directory and configures them to run in distributed mode. For this reason, on the first load the default distributed configuration contained in `config/default-distributed-db-config.json` is copied into each database's directory and renamed `distributed-config.json`. On subsequent starts, the file `databases/GratefulDeadConcerts/distributed-config.json` (as an example) will be used instead of the default configuration. This is because the shape of the cluster of servers changes every time nodes join or leave, and the configuration is kept updated by OrientDB on each server node.

To know more about the meaning of the configuration contained in the `config/default-distributed-db-config.json` file look at [Distributed Configuration](Distributed-Configuration.md).

## Start the second server node
Now start the second server like the first one. Make sure that both servers have the same Hazelcast credentials to join the same cluster in the `config/hazelcast.xml` file. The fastest way to do this is to copy & paste the OrientDB directory from the first node to the other ones. If you run multiple server instances in the same host (makes sense only for testing purpose) remember to change the port in `config/hazelcast.xml`.

Once the other node is online, both nodes see each other and dump a message like this:

```
WARN [node1384014656983] added new node id=Member [192.168.1.179]:2435 name=null [OHazelcastPlugin]
INFO [192.168.1.179]:2434 [orientdb] Re-partitioning cluster data... Migration queue size: 135 [PartitionService]
INFO [192.168.1.179]:2434 [orientdb] All migration tasks has been completed, queues are empty. [PartitionService]
INFO [node1384014656983] added node configuration id=Member [192.168.1.179]:2435 name=node1384015873680, now 2 nodes are configured [OHazelcastPlugin]
INFO [node1384014656983] update configuration db=GratefulDeadConcerts from=node1384015873680 [OHazelcastPlugin]
INFO updated distributed configuration for database: GratefulDeadConcerts:
----------
{
  "replication":true,
  "autoDeploy":true,
  "hotAlignment":true,
  "resyncEvery":15,"clusters":{
    "internal":{
  "replication":false
},
    "index":{
  "replication":false
},
    "*":{
  "replication":true,
  "readQuorum":1,
  "writeQuorum":2,
  "failureAvailableNodesLessQuorum":false,
  "readYourWrites":true,"partitioning":{
    "strategy":"round-robin",
    "default":0,
    "partitions":["<NEW_NODE>","node1383734730415","node1384015873680"]("<NEW_NODE>","node1383734730415","node1384015873680".md)
    }
}
    },
  "version":1
}
---------- [OHazelcastPlugin]
WARN [node1383734730415]->[node1384015873680] deploying database GratefulDeadConcerts... [ODeployDatabaseTask]
WARN [node1383734730415]->[node1384015873680] sending the compressed database GratefulDeadConcerts over the network, total 339,66Kb [ODeployDatabaseTask]
```

In this case 2 server nodes were started on the same machine (ip=10.37.129.2) but with 2 different ports (2434 and 2435 where the current is "this"). The rest of the log is relative to the distribution of the database to the second server.

On the second server node output you'll see these messages:

```
WARN [node1384015873680]<-[node1383734730415] installing database GratefulDeadConcerts in databases/GratefulDeadConcerts... [OHazelcastPlugin]
WARN [node1384015873680] installed database GratefulDeadConcerts in databases/GratefulDeadConcerts, setting it online... [OHazelcastPlugin]
WARN [node1384015873680] database GratefulDeadConcerts is online [OHazelcastPlugin]
WARN [node1384015873680] updated node status to 'ONLINE' [OHazelcastPlugin]
INFO OrientDB Server v1.6.1-SNAPSHOT is active. [OServer]
```

This means that the database "GratefulDeadConcerts" has been correctly installed from the first node (node1383734730415) through the network.


