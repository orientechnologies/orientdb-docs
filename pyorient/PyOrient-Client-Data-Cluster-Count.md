
# PyOrient Client - `data_cluster_count()`

This method returns the number of records in an array of clusters.

## Counting Cluster Records

Using the `data_cluster_count()` method, you can retrieve a count of the number of records stored on a given cluster.  You might find this useful for maintenance tasks or when you need a more granular record count than what the [`db_count_records()`](PyOrient-Client-DB-Count-Records.md) method provides.

**Syntax**

```
client.data_cluster_count([<cluster-ids>])
```

- **`<cluster-ids>`** Defines an array of Cluster ID's.

>For more information, see [Clusters](../gettingstarted/Tutorial-Clusters.md).

**Example**

For instance, consider the example of an application to manage smart home devices.  In each room you create a physical cluster to store data from environmental sensors.  For the web application, you want a count of the number of sensors in an array of rooms.  

```py
# Retrieve Record Count by Zone
def zone_count(client, cluster_ids, zone_name):

   # Fetch Record Count
   count = client.data_cluster_count(cluster_ids)

   # Log Findings
   logging.info("Found %s records for %s"
                % (str(count), zone_name))

   # Return
   return count
```

Where records are organized in clusters by room, for display purposes rooms are grouped together into zones.  This function receives the PyOrient Client, an array of Cluster ID's for a given zone and the zone name.  Using the Cluster ID's, it fetches a record count for that zone, uses the logging module to report its findings, then passes the count back as a return value.

