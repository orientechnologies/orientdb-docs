# PyOrient Client - `data_cluster_add()`

This method creates new clusters on the connected OrientDB Server.


## Creating Clusters

In OrientDB, the cluster is the place in memory or on disk where the database stores its records.  Using PyOrient, you can create new clusters from within your application using the `data_cluster_add()` method.  New cluster can be created as physical (that is, on disk), or in memory.

**Syntax**

```
client.data_cluster_add(<cluster-name>, <cluster-type>)
```

- **`<cluster-name>`** Defines the cluster name.
- **`<cluster-type>`** Defines the cluster type: 
  - *`pyorient.CLUSTER_TYPE_PHYSICAL`* Creates a physical cluster.
  - *`pyorient.CLUSTER_TYPE_MEMORY`* Creates an in-memory cluster.

>For more information, see [Clusters](Tutorial-Clusters.md).

**Example**

Consider the example of a database for a smart home management application.  When the application runs for the first time, you'll need to initialize OrientDB with any clusters the application requires to operate.  For instance, say you want your various environmental sensors to use different clusters for different rooms in the house:

```py
rooms = ['livingRoom', 'masterBedroom', 'guestBedroom', 
         'kitchen', 'bathroom', 'porch'] 

# Create a Cluster for Each Room
for room in rooms:

   client.data_cluster_add(room, pyorient.CLUSTER_TYPE_PHYSICAL)

   logging.info('Created Physical Cluster: %s' % room)
```

Here, your application loops over a list of cluster names and creates each instance as a physical cluster on the OrientDB Server.
