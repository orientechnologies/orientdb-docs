---
search:
   keywords: ['distributed', 'architecture', 'configuration']
---

# Distributed Configuration

The distributed configuration consists of 3 files under the **config/** directory:
- [orientdb-server-config.xml](Distributed-Configuration.md#orientdb-server-configxml)
- [default-distributed-db-config.json](Distributed-Configuration.md#default-distributed-db-configjson)
- [hazelcast.xml](#hazelcastxml)

Main topics:
- [Replication](Replication.md)
- [Asynchronous replication mode](Distributed-Configuration.md#asynchronous-replication-mode)
- [Return distributed configuration at run-time](Distributed-Runtime.md)
- [Load Balancing](Distributed-Configuration.md#load-balancing) 
- [Data Center support](Data-Centers.md)
- [Cloud support](Distributed-Configuration.md#cloud-support)

## orientdb-server-config.xml

To enable and configure the clustering between nodes, add and enable the **OHazelcastPlugin** plugin. It is configured as a [Server Plugin](../internals/DB-Server.md#plugins). The default configuration is reported below.

File **orientdb-server-config.xml**:
```xml
<handler class="com.orientechnologies.orient.server.hazelcast.OHazelcastPlugin">
  <parameters>
    <!-- NODE-NAME. IF NOT SET IS AUTO GENERATED THE FIRST TIME THE SERVER RUN -->
    <!-- <parameter name="nodeName" value="europe1" /> -->
    <parameter name="enabled" value="true" />
    <parameter name="configuration.db.default"
               value="${ORIENTDB_HOME}/config/default-distributed-db-config.json" />
    <parameter name="configuration.hazelcast"
               value="${ORIENTDB_HOME}/config/hazelcast.xml" />
  </parameters>
</handler>
```
Where:

| Parameter | Description |
|-----------|-----------|
|enabled|To enable or disable the plugin: <code>true</code> to enable it, <code>false</code> to disable it. By default is <code>true</code>|
|nodeName|An optional alias identifying the current node within the cluster. When omitted, a default value is generated as node<random-long-number>, example: "node239233932932". By default is commented, so it's automatic generated|
|configuration.db.default|Path of default [distributed database configuration](#default-distributed-db-configjson). By default is <code>${ORIENTDB_HOME}/config/default-distributed-db-config.json</code>|
|configuration.hazelcast|Path of [Hazelcast](http://www.hazelcast.com/docs/3.1/manual/multi_html/ch14.html) configuration file, default is <code>${ORIENTDB_HOME}/config/hazelcast.xml</code>|

## default-distributed-db-config.json

This is the JSON file containing the default configuration for distributed databases. The first time a database run in distributed version this file is copied in the database's folder with name `distributed-config.json`. Every time the cluster shape changes the database specific file is changed. To restore distributed database settings, remove the file `distributed-config.json` from the database folder, and the `default-distributed-db-config.json` file will be used.

Default **default-distributed-db-config.json** file content:
```json
{
    "autoDeploy": true,
    "executionMode": "undefined",
    "readQuorum": 1,
    "writeQuorum": "majority",
    "readYourWrites": true,
    "newNodeStrategy": "static",
    "dataCenters": {
      "rome": {
        "writeQuorum": "majority",
        "servers": [ "europe-0", "europe-1", "europe-2" ]
      },
      "denver": {
        "writeQuorum": "majority",
        "servers": [ "usa-0", "usa-1", "usa-2" ]
      }
    },
    "servers": {
        "*": "master"
    },
    "clusters": {
        "internal": {
        },
        "product": {
          "servers": ["usa", "china"]
        },
        "employee_usa": {
          "owner": "usa",
          "servers": ["usa", "<NEW_NODE>"]
        },
        "*": { "servers" : [ "<NEW_NODE>" ] }
    }
}
```

Where:

|Parameter|Description|Default value|
|---------|-----------|-------------|
|**autoDeploy**|Whether to deploy the database to any joining node that does not have it. It can be <code>true</code> or <code>false</code>|<code>true</code>|
|**executionMode**|It can be <code>undefined</code> to let to the client to decide per call execution between synchronous (default) or asynchronous. <code>synchronous</code> forces synchronous mode, and  <code>asynchronous</code> forces asynchronous mode|<code>undefined</code>|
|**readQuorum**|On "read" operation (record read, query and traverse) this is the number of responses to be coherent before sending the response to the client. Set to 1 if you don't want this check at read time|<code>1</code>|
|**writeQuorum**|On "write" operation (any write on database) this is the number of responses to be coherent before sending the response to the client. Set to 1 if you don't want this check at write time. Suggested value is "majority", the default, that means N/2+1 where N is the number of available nodes. In this way the quorum is reached only if the majority of nodes are coherent. "all" means all the available nodes. Starting from v2.2, N represent the MASTER only servers. For more information look at [Server Roles](Distributed-Architecture.md#server-roles).|<code>"majority"</code>|
|**readYourWrites**|Whether the write quorum is satisfied only when also the local node responded. This assures current the node can read its writes. Disable it to improve replication performance if such consistency is not important. Can be <code>true</code> or <code>false</code>|<code>true</code>|
|**newNodeStrategy**|Strategy to use when a new node joins the cluster. Default is `static` that means the server is automatically registered under `servers` list in configuration. If it is `dynamic`, then the node is not registered. This affects the strategy when a node is unreachable. If it is not registered (dynamic), it is removed from the configuration, so it does not concur in the quorum. Available since v2.2.13|<code>static</code>|
|**dataCenters**|(Since v2.2.4) Optional (and only available in the [Enterprise Edition](http://orientdb.com/orientdb-enterprise), contains the definition of the data centers. For more information look at [Data Centers](Data-Centers.md)|-|
|**servers**|(Since v2.1) Optional, contains the map of server roles in the format <code>server-name</code> : <code>role</code>. <code>*</code> means any server. Available roles are "MASTER" (default) and "REPLICA". For more information look at [Server roles](Distributed-Architecture.md#server-roles)|-|
|**clusters**|if the object containing the clusters' configuration as map <code>cluster-name</code> : <code>cluster-configuration</code>. <code>*</code> means all the clusters and is the cluster's default configuration|-|

The **cluster** configuration inherits database configuration, so if you declare "writeQuorum" at database level, all the clusters will inherit that setting unless they define your own. Settings can be:

|Parameter|Description|Default value|
|---------|-----------|-------------|
|**readQuorum**|On "read" operation (record read, query and traverse) is the number of responses to be coherent before to send the response to the client. Set to 1 if you don't want this check at read time|<code>1</code>|
|**writeQuorum**|On "write" operation (any write on database) is the number of responses to be coherent before to send the response to the client. Set to 1 if you don't want this check at write time. Suggested value is "majority", the default, that means N/2+1 where N is the number of available nodes. In this way the quorum is reached only if the majority of nodes are coherent. "all" means all the available nodes. Starting from v2.2, N represent the MASTER only servers. For more information look at [Server Roles](Distributed-Architecture.md#server-roles).|<code>"majority"</code>|
|**readYourWrites**|The write quorum is satisfied only when also the local node responded. This assure current the node can read its writes. Disable it to improve replication performance if such consistency is not important. Can be <code>true</code> or <code>false</code>|<code>true</code>|
|**owner**|By default the cluster owner is assigned at run-time and it's placed as first server in the `servers` list. If `owner` field is defined, the server owner is statically assigned to that server, no matter if the server is available or not.||
|**servers**|Is the array of servers where to store the records of cluster|empty for internal and index clusters and ```[ "<NEW_NODE>" ]``` for cluster * representing any cluster|

```"<NEW_NODE>"``` is a special tag that put any new joining node name in the array.

### Default configuration

In the default configuration all the record clusters are replicated, but <code>internal</code>. Every node that joins the cluster shares all the rest of the clusters ("*" settings). Since "readQuorum" is 1 all the reads are executed on the first available node where the local node is preferred if own the requested record. "writeQuorum" to "majority" means that all the changes are in at least N/2+1 nodes, where N is the number of available nodes. Using "majority" instead of a number, allows you to have an elastic configuration where nodes can join and left without the need to rebalance this value manually.

### 100% Asynchronous Writes

By default writeQuorum is "majority". This means that it waits and checks the answer from at least N/2+1 (where N is the number of available nodes) nodes before to send the ACK to the client. After the quorum is reached, the responses are managed asyncrhonously. For example, with 3 nodes and `writeQuorum: "majority"`, then after the 2nd node's answer, the collecting and check of the 3rd node answer is managed asynchronously. You could also set this to 1 to have all the writes asynchronous.

### Full Consistency

To avoid experiencing any dirty reads during the replication, you can setup the writeQuorum to "all", that means all the available nodes. Example: `writeQuorum: "all". Setting writeQuorum to "all" means each replication operation will take the time of the slowest node in the cluster.

## hazelcast.xml

A OrientDB cluster is composed by two or more servers that are the **nodes** of the cluster. All the server nodes that want to be part of the same cluster must to define the same [Cluster Group](http://docs.hazelcast.org/docs/3.5/manual/html/createclustergroups.html). By default "orientdb" is the group name. Look at the default **config/hazelcast.xml** configuration file reported below:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<hazelcast xsi:schemaLocation="http://www.hazelcast.com/schema/config hazelcast-config-3.0.xsd"
           xmlns="http://www.hazelcast.com/schema/config" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <group>
    <name>orientdb</name>
    <password>orientdb</password>
  </group>
  <network>
    <port auto-increment="true">2434</port>
    <join>
      <multicast enabled="true">
        <multicast-group>235.1.1.1</multicast-group>
        <multicast-port>2434</multicast-port>
      </multicast>
    </join>
  </network>
  <executor-service>
    <pool-size>16</pool-size>
  </executor-service>
</hazelcast>
```

*NOTE: Change the name and password of the group to prevent foreign nodes from joining it!*

### Network configuration

#### Automatic discovery in LAN using Multicast

OrientDB by default uses TCP Multicast to discover nodes. This is contained in **config/hazelcast.xml** file under the **network** tag. This is the default configuration:

```xml
<hazelcast>
  ...
  <network>
    <port auto-increment="true">2434</port>
    <join>
      <multicast enabled="true">
        <multicast-group>235.1.1.1</multicast-group>
        <multicast-port>2434</multicast-port>
      </multicast>
     </join>
  </network>
  ...
</hazelcast>
```

#### Manual IP

When Multicast is disabled or you prefer to assign Hostnames/IP-addresses manually use the TCP/IP tag in configuration. Pay attention to disable the **multicast**:

```xml
<hazelcast>
  ...
  <network>
    <port auto-increment="true">2434</port>
    <join>
      <multicast enabled="false">
        <multicast-group>235.1.1.1</multicast-group>
        <multicast-port>2434</multicast-port>
      </multicast>
      <tcp-ip enabled="true">
        <member>europe0:2434</member>
        <member>europe1:2434</member>
        <member>usa0:2434</member>
        <member>asia0:2434</member>
        <member>192.168.1.0-7:2434</member>
      </tcp-ip>
     </join>
  </network>
  ...
</hazelcast>
```

For more information look at: [Hazelcast Config TCP/IP](http://docs.hazelcast.org/docs/3.5/manual/html/tcp.html).

#### Cloud support

Since multicast is disabled on most of the Cloud stacks, you have to change the **config/hazelcast.xml** configuration file based on the Cloud used.

##### Amazon EC2
OrientDB supports natively [Amazon EC2](http://aws.amazon.com/ec2/) through the Hazelcast's Amazon discovery plugin. In order to use it include also the **hazelcast-cloud.jar** library under the **lib/** directory.

```xml
<hazelcast>
  ...
    <join>
      <multicast enabled="false">
        <multicast-group>235.1.1.1</multicast-group>
        <multicast-port>2434</multicast-port>
      </multicast>
      <aws enabled="true">
        <access-key>my-access-key</access-key>
        <secret-key>my-secret-key</secret-key>
        <region>us-west-1</region>                               <!-- optional, default is us-east-1 -->
        <host-header>ec2.amazonaws.com</host-header>             <!-- optional, default is ec2.amazonaws.com. If set region
                                                                      shouldn't be set as it will override this property -->
        <security-group-name>hazelcast-sg</security-group-name>  <!-- optional -->
        <tag-key>type</tag-key>                                  <!-- optional -->
        <tag-value>hz-nodes</tag-value>                          <!-- optional -->
      </aws>
    </join>
  ...
</hazelcast>
```

For more information look at [Hazelcast Config Amazon EC2 Auto Discovery](http://docs.hazelcast.org/docs/3.5/manual/html/ec2.html).

##### Other Cloud providers
Uses manual IP like explained in [Manual IP](Distributed-Configuration.md#manual-ip).

## Asynchronous replication mode

If you are replication OrientDB database across multiple Data Centers, look at [Data Centers Configuration](Data-Centers.md) available only with the [Enterprise Edition](http://orientdb.com/orientdb-enterprise).

If you are using the Community Edition or if you don't have multiple data centers, but just a network with high latency, in order to reduce the impact of the latency in the replication, the suggested configuration is to set `executionMode` to "asynchronous". In asynchronous mode any operation is executed on local node and then replicated. In this mode the client doesn't wait for the quorum across all the servers, but receives the response immediately after the local node answer. Example:

```json
{
    "autoDeploy": true,
    "executionMode": "asynchronous",
    "readQuorum": 1,
    "writeQuorum": "majority",
    "readYourWrites": true,
    "newNodeStrategy": "static",
    "servers": {
        "*": "master"
    },
    "clusters": {
        "internal": {
        },
        "*": {
            "servers" : [ "<NEW_NODE>" ]
        }
    }
}
```

Starting from v2.1.6 is possible to catch events of command during asynchronous replication, thanks to the following method of OCommandSQL:
- `onAsyncReplicationOk()`, to catch the event when the asynchronous replication succeed
- `onAsyncReplicationError()`, to catch the event when the asynchronous replication returns error

Example retrying up to 3 times in case of concurrent modification exception on creation of edges:
```java
g.command( new OCommandSQL("create edge Own from (select from User) to (select from Post)")
 .onAsyncReplicationError(new OAsyncReplicationError() {
  @Override
  public ACTION onAsyncReplicationError(Throwable iException, int iRetry) {
    System.err.println("Error, retrying...");
    return iException instanceof ONeedRetryException && iRetry<=3 ? ACTION.RETRY : ACTION.IGNORE;
  }
})
 .onAsyncReplicationOk(new OAsyncReplicationOk() {
   System.out.println("OK");
 }
).execute();
```


## Load Balancing
(Since v2.2)
OrientDB allows to do load balancing when you have multiple servers connected in cluster. Below are the available connection strategies:
- `STICKY`, the default, where the client remains connected to a server until the close of database
- `ROUND_ROBIN_CONNECT`, at each connect, the client connects to a different server between the available ones
- `ROUND_ROBIN_REQUEST`, at each request, the client connects to a different server between the available ones. Pay attention on using this strategy if you're looking for strong consistency. In facts, in case the writeQuorum is minor of the total nodes available, a client could have executed an operation against another server and current operation cannot see updates because wasn't propagated yet.

Once a client is connected to any server node, it retrieves the list of available server nodes. In case the connected server becomes unreachable (crash, network problem, etc.), the client automatically connects to the next available one.

To setup the strategy using the Java Document API:
```java
OrientDB orientDB = new OrientDB("remote:localhost", OrientDBConfig.defaultConfig());
OrientDBConfig config = OrientDBConfig.builder().addConfig(CLIENT_CONNECTION_STRATEGY, "ROUND_ROBIN_CONNECT").build();
final ODatabaseDocument db = orientDB.open("demo", user, password, config);
```

To setup the strategy using the Java Graph API:

```java
final OrientGraphFactory factory = new OrientGraphFactory("remote:localhost/demo");
factory.setConnectionStrategy(OStorageRemote.CONNECTION_STRATEGY.ROUND_ROBIN_CONNECT.toString());
OrientGraphNoTx graph = factory.getNoTx();
```

### Use multiple addresses
If the server addresses are known, it is good practice to connect the clients to a set of URLs, instead of just one. You can separate hosts/addresses by using a semicolon (;). OrientDB client will try to connect to the addresses in order. Example: `remote:server1:2424;server2:8888;server3/mydb`. 

### Use the DNS

Before v2.2, the simplest and most powerful way to achieve load balancing seems to use some hidden (to some) properties of DNS. The trick is to create a TXT record listing the servers.

The format is:
```
v=opf<version> (s=<hostname[:<port>]> )*
```

Example of TXT record for domain **dbservers.mydomain.com**:
```
v=opf1 s=192.168.0.101:2424 s=192.168.0.133:2424
```

In this way if you open a database against the URL <code>remote:dbservers.mydomain.com/demo</code> the OrientDB client library will try to connect to the address **192.168.0.101** port 2424. If the connection fails, then the next address **192.168.0.133:** port 2424 is tried.

To enable this feature in Java Client driver set ```network.binary.loadBalancing.enabled=true```:

```
java ... -Dnetwork.binary.loadBalancing.enabled=true
```
or via Java code:

```java
OGlobalConfiguration.NETWORK_BINARY_DNS_LOADBALANCING_ENABLED.setValue(true);
```

## Troubleshooting
### Hazelcast Monitor
Users reported that Hazelcast Health Monitoring could cause problem with a JVM kill (OrientDB uses Hazelcast to manage replication between nodes). By default this setting is OFF, so if you are experiencing this kind of problem assure this is set:  `hazelcast.health.monitoring.level=OFF`

### Extraction Directory
OrientDB extract the database form the network to the temporary directory set in the JVM by `java.io.tmpdir` setting. To change the temporary directory used to store the temporary database, overwrite the default setting at JVM startup (or even at run-time from Java). Example:

    java ... -Djava.io.tmpdir=/myfolder/server1

OrientDB will create the temporary database under the folder `/myfolder/server1/orientdb`.


## History

### v2.2.13
New setting `newNodeStrategy` to specify what happens when a new node joins. This affects the behaviour when a node is unreachable. If it is not present under the `servers` list, then it's removed from the configuration and it doesn't concur in the quorum anymore.

### v2.2
The intra-node communication is not managed with Hazelcast Queues anymore, but rather through the OrientDB binary protocol. This assure better performance and avoid the problem of locality of the Hazelcast queues. Release v2.2 also supported the wildcard "majority" and "all" for the read and write quorums. Introduced also the concept of static cluster owner. Furthermore nodes are not removed by configuration when they are offline.

Introduced Load balancing at client level. For more information look at [load balancing](Distributed-Configuration.md#load-balancing).

### v1.7
Simplified configuration by moving. Removed some flags (replication:boolean, now it’s deducted by the presence of “servers” field) and settings now are global (autoDeploy, hotAlignment, offlineMsgQueueSize, readQuorum, writeQuorum, failureAvailableNodesLessQuorum, readYourWrites), but you can overwrite them per-cluster.

For more information look at [News in 1.7](http://www.orientechnologies.com/distributed-architecture-sharding/).
