
# PyOrient Client - `record_delete()`

This method removes records from the open OrientDB database.

## Deleting Records

When you want to remove records from the open OrientDB database, you can do so using the `record_delete()` method.  To do so, you'll need the cluster that contains the record and its Record ID.


**Syntax**

```
client.record_delete(<cluster-id>, <record-id>)
```

- **`<cluster-id>`** Defines the cluster that contains the record.
- **`<record-id>`** Defines the record to remove.

**Example**

Consider the example of the smart home database.  In developing the web interface, you want to implement a feature that allows the user to delete sensor nodes from the database.  In the event that you find certain nodes are damaged or you move the system to a new house and would like the monitors to display fresh sensor data.  

```py
def remove_records(client, cluster_id record_list):
   
   # Iterate through Record ID's
   for record in record_list:

      # Delete Record
      client.record_delete(cluster_id, record.__rid)
```

Here, the function receives the client, cluster ID and an array of records as arguments.  It then iterates over each record in the array and deletes it using the `record_delete()` method.

