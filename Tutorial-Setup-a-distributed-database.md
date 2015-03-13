# Setup a Distributed Database
OrientDB can run in a [Distributed Architecture](Distributed-Architecture.md) by sharing a database across multiple server instances.

For the purpose of this tutorial we're going to run 2 servers. There are 2 ways to share the same database across multiple nodes:
- Prior to startup, the database directory must be copied to all the servers. Copy & Paste-ing the database directory under the "databases" folder is enough.
- Alternately, keep the database on the first node running. The default configuration automatically shares the database with new servers that join.

## Start the first server node
To start OrientDB in distributed mode, don't use `bin/server.sh` (or `.bat` on Windows), but rather the `bin/dserver.sh` (or `bin/dserver.bat`) script:

```
> cd bin
> ./dserver.sh

INFO OrientDB Server v1.6 (build 897) is starting up... [OServer]
INFO Databases directory: ./databases [OServer]
INFO Listening binary connections on 0.0.0.0:2424 (protocol v.18) [OServerNetworkListener]
INFO Listening http connections on 0.0.0.0:2480 (protocol v.10) [OServerNetworkListener]
INFO Installing dynamic plugin 'studio-1.6.zip'... [OServerPluginManager]
INFO Installing GREMLIN language v.2.5.0-SNAPSHOT - graph.pool.max=20 [OGraphServerHandler]
```

Note that the configuration file isn't `orientdb-server-config.xml` but the distributed version of it: `orientdb-dserver-config.xml`. For more information, look at [Distributed Configuration](Distributed-Configuration.md).

The rest of the server startup log is below:

```
INFO Starting distributed server 'node1383734730415'... [OHazelcastPlugin]
INFO Configuring Hazelcast from ./config/hazelcast.xml'. [FileSystemXmlConfig]
INFO [10.1.28.101]:2434 [orientdb]
Members [1] {
    Member [10.1.28.101]:2434 this
}
[MulticastJoiner]
WARN [node1383734730415] opening database 'GratefulDeadConcerts'... [OHazelcastPlugin]
INFO [node1383734730415] loaded database configuration from disk: ./config/default-distributed-db-config.json [OHazelcastPlugin]
---------- [OHazelcastPlugin]
INFO [node1383734730415] adding node 'node1383734730415' in partition: GratefulDeadConcerts.*.0 [OHazelcastDistributedDatabase]
INFO updated distributed configuration for database: GratefulDeadConcerts:
----------
{
  "replication":true, "autoDeploy":true, "hotAlignment":true, "resyncEvery":15,
  "clusters":{
    "internal":{ "replication":false },
    "index":{ "replication":false },
    "*":{ "replication":true,
      "readQuorum":1,
      "writeQuorum":2,
      "failureAvailableNodesLessQuorum":false,
      "readYourWrites":true,
      "partitioning":{
        "strategy":"round-robin",
        "default":0,
        "partitions":["<NEW_NODE>","node1383734730415"]("<NEW_NODE>","node1383734730415".md)
      }
    }
  }
}
```

By reading the last piece of log we should notice that by default the `nodeId` is empty in `config/orientdb-dserver-config.xml`, so it's automatically assigned to random value: "node1383734730415" in this case. You should set a more familiar name like "europe0" or "production1".

Upon starting, OrientDB loads all the databases in the "databases" directory and configures them to run in distributed mode. For this reason, on the first load the default distributed configuration contained in `config/default-distributed-db-config.json` is copied into the database's directory. On subsequent starts, the file `databases/GratefulDeadConcerts/default-distributed-db-config.json` will be used instead of default configuration. This is because the shape of the cluster of servers changes every time nodes join or leave, and the configuration is kept updated by OrientDB on each server node.

To know more about the meaning of the configuration contained in the `config/default-distributed-db-config.json` file look at [Distributed Configuration](Distributed-Configuration.md).

## Start the second server node
Now start the second server like the first one. Make sure that both servers have the same Hazelcast's credentials to join the same cluster in the `config/hazelcast.xml` file. The fastest way to do this is to copy & paste the OrientDB directory from the first node to the other ones. If you run multiple server instances in the same host (makes sense only for testing purpose) remember to change the port in `config/hazelcast.xml`.

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

In this case 2 server nodes were started on the same machine (ip=10.37.129.2), but with 2 different ports (2434 and 2435 where the current is "this"). The rest of the log is relative to the distribution of the database to the second server.

On the second server node output you'll see these messages:

```
WARN [node1384015873680]<-[node1383734730415] installing database GratefulDeadConcerts in databases/GratefulDeadConcerts... [OHazelcastPlugin]
WARN [node1384015873680] installed database GratefulDeadConcerts in databases/GratefulDeadConcerts, setting it online... [OHazelcastPlugin]
WARN [node1384015873680] database GratefulDeadConcerts is online [OHazelcastPlugin]
WARN [node1384015873680] updated node status to 'ONLINE' [OHazelcastPlugin]
INFO OrientDB Server v1.6.1-SNAPSHOT is active. [OServer]
```

This means that the database "GratefulDeadConcerts" has been correctly installed from the first node (node1383734730415) through the network.


