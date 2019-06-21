---
search:
   keywords: ['distributed', 'architecture', 'lifecycle', 'distributed architecture']
---

# Distributed Architecture Lifecycle

In OrientDB Distributed Architecture all the nodes are masters (Multi-Master), while in most DBMS the replication works in Master-Slave mode where there is only one Master node and N Slaves that are use only for reads or when the Master is down. Starting from OrientDB v2.1, you can also assign the role of [REPLICA](Distributed-Architecture.md#server-roles) to some nodes.

When start a OrientDB server in distributed mode (```bin/dserver.sh```) it looks for an existent cluster. If exists the starting node joins the cluster, otherwise creates a new one. You can have [multiple clusters](Distributed-Architecture-Lifecycle.md#multiple-clusters) in your network, each cluster with a different "group name".

## Joining a cluster

### Auto discovering

At startup each Server Node sends an IP Multicast message in broadcast to discover if an existent cluster is available to join it. If available the Server Node will connect to it, otherwise creates a new cluster.

![image](http://www.orientdb.org/images/cluster-autodiscovering.png)

This is the default configuration contained in ```config/hazelcast.xml``` file. Below the multicast configuration fragment:

```xml
<hazelcast>
  <network>
    <port auto-increment="true">2434</port>
      <join>
        <multicast enabled="true">
          <multicast-group>235.1.1.1</multicast-group>
          <multicast-port>2434</multicast-port>
       </multicast>
     </join>
  </network>
</hazelcast>
```

If multicast is not available (typical on Cloud environments), you can use:
- [Direct IPs](http://docs.hazelcast.org/docs/3.6/manual/html-single/index.html#discovering-members-by-tcp)
- [Amazon EC2 Discovering](http://docs.hazelcast.org/docs/3.6/manual/html-single/index.html#discovering-members-within-ec2-cloud)

For more information look at [Hazelcast documentation about configuring network](http://docs.hazelcast.org/docs/3.6/manual/html-single/index.html#network-configuration).

### Security

To join a cluster the Server Node has to configure the cluster group name and password in hazelcast.xml file. By default these information aren't encrypted. If you wan to encrypt all the distributed messages, configure it in hazelcast.xml file:

```xml
<hazelcast>
    ...
    <network>
        ...
        <!--
            Make sure to set enabled=true
            Make sure this configuration is exactly the same on
            all members
        -->
        <symmetric-encryption enabled="true">
            <!--
               encryption algorithm such as
               DES/ECB/PKCS5Padding,
               PBEWithMD5AndDES,
               Blowfish,
               DESede
            -->
            <algorithm>PBEWithMD5AndDES</algorithm>

            <!-- salt value to use when generating the secret key -->
            <salt>thesalt</salt>

            <!-- pass phrase to use when generating the secret key -->
            <password>thepass</password>

            <!-- iteration count to use when generating the secret key -->
            <iteration-count>19</iteration-count>
        </symmetric-encryption>
    </network>
    ...
</hazelcast>
```

All the nodes in the distributed cluster must have the same settings.

![image](http://www.orientdb.org/images/cluster-security.png)

For more information look at: [Hazelcast Encryption](https://docs.hazelcast.org/docs/latest/manual/html-single/#encryption).

### Join to an existent cluster

You can have multiple OrientDB clusters in the same network, what identifies a cluster is it’s name that must be unique in the network. By default OrientDB uses "orientdb", but for security reasons change it to a different name and password. All the nodes in the distributed cluster must have the same settings.

```xml
<hazelcast>
  <group>
    <name>orientdb</name>
    <password>orientdb</password>
  </group>
</hazelcast>
```

In this case Server #2 joins the existent cluster.

![image](http://www.orientdb.org/images/cluster-join.png)

When a node joins an existent cluster, the most updated copy of the database is downloaded to the joining node if the distributed configuration has `autoDeploy:true`. If the node is rejoining the cluster after a disconnection, a delta backup is requested first. If not available a full backup is sent to the joining server. If it has been configured a sharded configuration, the joining node will ask for separate parts of the database to multiple available servers to reconstruct the own database copy. If any copy of database was already present, that is moved under `backup/databases` folder.

### Multiple clusters

Multiple clusters can coexist in the same network. Clusters can't see each others because are isolated black boxes.

![image](http://www.orientdb.org/images/cluster-multiple.png)

### Distribute the configuration to the clients

Every time a new Server Node joins or leaves the Cluster, the new Cluster configuration is broadcasted to all the connected clients. Everybody knows the cluster layout and who has a database!

![image](http://www.orientdb.org/images/cluster-cfg.png)

## Fail over management

### When a node is unreachable

When a Server Node becomes unreachable (because it’s crashed, network problems, high load, etc.) the Cluster treats this event as if the Server Node left the cluster.

![image](http://www.orientdb.org/images/cluster-crash.png)

Starting from v2.2.13, the unreachable server is removed from the [distributed configuration](Distributed-Configuration.md) only if it's dynamic, that means it hasn't registered under the [`servers`](Distributed-Configuration.md#default-distributed-db-configjson) configuration. Once removed it doesn't concur to the quorum anymore. Instead, if the server has been registered under [`servers`](Distributed-Configuration.md#default-distributed-db-configjson), it's kept in configuration waiting for a rejoining.

The [`newNodeStrategy`](Distributed-Configuration.md#default-distributed-db-configjson) setting specifies if a new joining node is automatically registered as static or is managed as dynamic.

### Automatic switch of servers

All the clients connected to the unreachable node will switch to another server transparently without raising errors to the Application User Application doesn’t know what is happening!

![image](http://www.orientdb.org/images/cluster-clientswitch.png)

### Re-distribute the updated configuration again

After the Server #2 left the Cluster the updated configuration is sent again to all the connected clients.

![image](http://www.orientdb.org/images/cluster-recfg.png)

Continue with:
- [Distributed Architecture](Distributed-Architecture.md)
- [Replication](Replication.md)
- [Tutorial to setup a distributed database](../gettingstarted/tutorials/Tutorial-Setup-a-distributed-database.md)
