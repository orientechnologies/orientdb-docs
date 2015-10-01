# Replication

OrientDB supports the [Multi Master replication](http://en.wikipedia.org/wiki/Multi-master_replication). This means that all the nodes in the cluster are Master and are able to read and write to the database. This allows to scale up horizontally without bottlenecks like most of any other RDBMS and NoSQL solution do.

Replication works only in the [Distributed-Architecture](Distributed-Architecture.md).

## Sharing of database
In Distributed Architecture the replicated database must have the same name. When an OrientDB Server is starting, it sends the list of current databases (all the databases located under ```$ORIENTDB_HOME/databases``` directory) to all the nodes in the cluster. If other nodes have databases with the same name, a replication is automatically set.

![image](http://www.orientdb.org/images/distributed-db-share.png)

_NOTE: In Distributed Architecture assure to avoid conflict with database names, otherwise 2 different databases could start replication with the chance to get corrupted._

If the [database configuration](Distributed-Configuration#default-distributed-db-configjson) has the setting ```"autoDeploy" : true```, then the databases are automatically deployed across the network to the other nodes as soon as they join the cluster.

![image](http://www.orientdb.org/images/distributed-db-autodeploy.png)

## Server unreachable

In case a server becomes unreachable, the node is removed by [database configuration](Distributed-Configuration#default-distributed-db-configjson) unless the setting ```"hotAlignment" : true```. In this case all the new synchronization messages are kept in a distributed queue.

![image](http://www.orientdb.org/images/distributed-srv-unreacheable.png)

As soon as the Server becomes online again, it starts the synchronization phase (status=SYNCHRONIZING) by polling all the synchronization messages in the queue.

![image](http://www.orientdb.org/images/distributed-srv-backonline.png)

Once the alignment is finished, the node becomes online (status=ONLINE) and the replication continues like at the beginning.

![image](http://www.orientdb.org/images/distributed-srv-restored.png)

## Further readings

Continue with:
- [Distributed Architecture](Distributed-Architecture.md)
- [Distributed Sharding](Distributed-Sharding.md)
- [Distributed database configuration](Distributed-Configuration.md)
