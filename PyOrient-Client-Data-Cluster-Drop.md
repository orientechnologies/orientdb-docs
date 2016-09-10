---
search:
   keywords: ['PyOrient', 'cluster', 'drop cluster']
---

# PyOrient Client - `data_cluster_drop()`

This method removes a cluster from the database.

## Removing Clusters

Occasionally, you may find the need to remove clusters from your database.  You can do so through the PyOrient Client using the `data_cluster_drop()` method.

**Syntax**

```
client.data_cluster_drop(<cluster-id>)
```

- **`<cluster-id>`** Defines the ID of the cluster.

>For more information, see [Clusters](Tutorial-Clusters.md).

**Example**

Consider the example of the smart home application.  Environmental sensors for each room write their data to a dedicated cluster on OrientDB.  Every so often users will move and take the system with them to a new house.  The new house may not have the same number of rooms as the old, which opens up the need for the application to delete clusters in setting the system back up:

```py
# Remove Cluster
def remove_cluster(client, name, cluster_id):

   # Remove Cluster
   client.data_cluster_drop(cluster_id)

   # Log Event
   logging.info("Removed Cluster %s for %s"
                % (str(cluster_id), name))
```

Here, the function receives the PyOrient Client, the room name and the Cluster ID for sensor nodes in that room as arguments.  It removes the cluster, then reports on what it did to the logging module.
