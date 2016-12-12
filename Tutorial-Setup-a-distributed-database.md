---
search:
   keywords: ["tutorial", "distributed database"]
---

# Setting up a Distributed Graph Database

In addition to the standard deployment architecture, where it runs as a single, standalone database instance, you can also deploy OrientDB using [Distributed Architecutre](Distributed-Architecture.md).  In this environment, it shares the database across multiple server instances.

## Launching Distributed Server Cluster

There are two ways to share a database across multiple server nodes:

- Prior to startup, copy the specific database directory, under `$ORIENTDB_HOME/database` to all servers.

- Keep the database on the first running server node, then start every other server node.  Under the default configurations, OrientDB automatically shares the database with the new servers that join.

This tutorial assumes that you want to start a distributed database using the second method.

_NOTE: When you run in distributed mode, OrientDB needs more RAM. The minimum is 2GB of heap, but we suggest to use at least 4GB of heap memory. To change the heap modify the Java memory settings in the file `bin/server.sh` (or server.bat on Windows)._

### Starting the First Server Node

Unlike the standard standalone deployment of OrientDB, there is a different script that you need to use when launching a distributed server instance.  Instead of `server.sh`, you use `dserver.sh`.  In the case of Windows, use `dserver.bat`.  Whichever you need, you can find it in the `bin` of your installation directory.

<pre>
$ <code class="lang-sh userinput">./bin/dserver.sh</code>
</pre>

Bear in mind that OrientDB uses the same `orientdb-server-config.xml` configuration file, regardless of whether it's running as a server or distributed server.  For more information, see [Distributed Configuration](Distributed-Configuration.md).

The first time you start OrientDB as a distributed server, it generates the following output:

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

You need to give the node a name here.  OrientDB stores it in the `nodeName` parameter of `OHazelcastPlugin`.  It adds the variable to your `orientdb-server-config.xml` configuration file.

#### Distributed Startup Process

When OrientDB starts as a distributed server instance, it loads all databases in the `database` directory and configures them to run in distributed mode.  For this reason, the first load, OrientDB copies the default distributed configuration, (that is, the `default-distributed-db-config.json` configuration file), into each database's directory, renaming it `distributed-config.json`.  On subsequent starts, each database uses this file instead of the default configuration file.  Since the shape of the cluster changes every time nodes join or leave, the configuration is kept up to date by each distributed server instance.

For more information on working with the `default-distributed-db-config.json` configuration file, see [Distributed Configuration](Distributed-Configuration.md).

### Starting Additional Server Nodes

When you have the first server node running, you can begin to start the other server nodes.  Each server requires the same Hazelcast credentials in order to join the same cluster.  You can define these in the `hazelcast.xml` configuration file.

The fastest way to initialize multiple server nodes is to copy the OrientDB installation directory from the first node to each of the subsequent nodes.  For instance,

<pre>
$ <code class="lang-sh userinput">scp user@ip_address $ORIENTDB_HOME</code>
</pre>

This copies both the databases and their configuration files onto the new distributed server node.

>Bear in mind, if you run multiple server instances on the same host, such as when testing, you need to change the port entry in the `hazelcast.xml` configuration file.

For the other server nodes in the cluster, use the same `dserver.sh` command as you used in starting the first node.  When the other server nodes come online, they begin to establish network connectivity with each other.  Monitoring the logs, you can see where they establish connections from messages such as this:

<pre>
WARN [node1384014656983] added new node id=Member [192.168.1.179]:2435 name=null
     [OHazelcastPlugin]
INFO [192.168.1.179]:2434 [orientdb] Re-partitioning cluster data... Migration
	 queue size: 135 [PartitionService]
INFO [192.168.1.179]:2434 [orientdb] All migration tasks has been completed,
	 queues are empty. [PartitionService]
INFO [node1384014656983] added node configuration id=Member [192.168.1.179]:2435
     name=node1384015873680, now 2 nodes are configured [OHazelcastPlugin]
INFO [node1384014656983] update configuration db=GratefulDeadConcerts
     from=node1384015873680 [OHazelcastPlugin]
INFO updated distributed configuration for database: GratefulDeadConcerts:
----------
<code class="lang-json">{
   "replication": true,
   "autoDeploy": true,
   "hotAlignment": true,
   "resyncEvery": 15,
   "clusters": {
      "internal": {
         "replication": false
      },
      "index": {
         "replication": false
      },
      "*": {
         "replication": true,
         "readQuorum": 1,
         "writeQuorum": 2,
         "failureAvailableNodesLessQuorum": false,
         "readYourWrites": true,
		 "partitioning":{
            "strategy": "round-robin",
            "default":0,
            "partitions": ["<NEW_NODE>","node1383734730415","node1384015873680"]("<NEW_NODE>","node1383734730415","node1384015873680".md)
         }
      }
   },
   "version": 1
}</code>
---------- [OHazelcastPlugin]
WARN [node1383734730415]->[node1384015873680] deploying database
     GratefulDeadConcerts...[ODeployDatabaseTask]
WARN [node1383734730415]->[node1384015873680] sending the compressed database
     GratefulDeadConcerts over the network, total 339,66Kb [ODeployDatabaseTask]
</pre>

In the example, two server nodes were started on the same machine.  It has an IP address of 10.37.129.2, but is using OrientDB on two different ports: 2434 and 2435, where the current is called `this`.  The remainder of the log is relative to the distribution of the database to the second server.

On the second server node output, OrientDB dumps messages like this:

```
WARN [node1384015873680]<-[node1383734730415] installing database
     GratefulDeadConcerts in databases/GratefulDeadConcerts... [OHazelcastPlugin]
WARN [node1384015873680] installed database GratefulDeadConcerts in
     databases/GratefulDeadConcerts, setting it online... [OHazelcastPlugin]
WARN [node1384015873680] database GratefulDeadConcerts is online [OHazelcastPlugin]
WARN [node1384015873680] updated node status to 'ONLINE' [OHazelcastPlugin]
INFO OrientDB Server v1.6.1-SNAPSHOT is active. [OServer]
```


What these messages mean is that the database `GratefulDeadConcerts` was correctly installed from the first node, that is `node1383734730415` through the network.

## Migrating from standalone server to a cluster
If you have a standalone instance of OrientDB and you want to move to a cluster you should follow these steps:
* Install OrientDB on all the servers of the cluster and configure it (according to the sections above)
* Stop the standalone server
* Copy the specific database directories under `$ORIENTDB_HOME/database` to all the servers of the cluster
* Start all the servers in the cluster using the script `dserver.sh` (or  `dserver.bat` if on Windows)

If the standalone server will be part of the cluster, you can use the existing installation of OrientDB; you don't need to copy the database directories since they're already in place and you just have to start it before all the other servers with `dserver.sh`.



