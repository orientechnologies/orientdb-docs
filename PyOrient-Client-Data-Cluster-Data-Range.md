# PyOrient Client - `data_cluster_data_range()`

This method returns a range of Record ID's for the given cluster.

## Retrieving Cluster Records

Using the `data_cluster_data_range()` method, you can retrieve all records stored in a particular cluster.  You may find this particularly useful in implementations that organize similar records by storing them in dedicated clusters.

**Syntax**

```
client.data_cluster_data_range(<cluster-id>)
```

- **`<cluster-id>`** Defines an integer for the Cluster ID.

>For more information, see [Clusters](Tutorial-Clusters.md)

**Example**

Consider the example of a smart home management application that maintains records using OrientDB.  You have built a series of Arduino or Micro Python devices to monitor environmental conditions around the house, (that is, light, temperature, pollen levels, and so on), and have created a class in OrientDB to store data from these sensors.  To better organize this data, for each room in your house you have a dedicated cluster to store records from these sensors.

```py
# Retrieve Sensor Data
def get_sensor(client, cluster_id):

   # Retrieve Data
   data = client.data_cluster_data_range(cluster_id)
   return data
```
Here, the function receives the `client` object and an integer that indicates the Cluster ID for the room you want to access.  It then calls the `data_cluster_data_range()` method with these arguments to retrieve all records in that cluster.
