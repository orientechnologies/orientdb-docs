---
search:
   keywords: ['PyOrient', 'client', 'load records']
---

# PyOrient Client - `record_load()`

This method retrieves the given Record ID from an open OrientDB database.


## Loading Records

In PyOrient, a record load is similar to a [`query()`](PyOrient-Client-Query.md) in that it fetches record from the database for the application to operate on.  But, unlike a query, `record_load()` fetches a record using its Record ID.

**Syntax**

```
client.record_load(<rid>, <fetch-plan>, <callback>)
```

- **`<rid>`** Defines the Record ID of the record you want to load.
- **`<fetch-plan>`** Defines a [Fetching Strategy](../java/Fetching-Strategies.md) to use.
- **`<callback>`** Defines a function to use as callback with your Fetch Plan.

**Example**

For instance, consider the use case of an application that manages a series of smart devices scattered about your home.  You log data from these devices to OrientDB.

Given that your application is logging all this data, you might want to extract it to use elsewhere.  With an array of Record ID's, you can iterate through, using this method to retrieve the data from OrientDB and pass it on as a return value.  For example,

```py
# Process Data
def compile_data(client, rid_array):

   # Initialize Variable
   data = {}

   # Iterate through Record ID's
   for rid in rid_array:

      # Log Data
      data[rid] = client.record_load(rid)

   # Return Data
   return data
```

Here, the function receives the `client` interface and array of Record ID's, it iterates through them, storing the data in the `data` dict, which it then returns for analysis elsewhere in your application.



### Loading Records with Cache

In addition to the standard record loads, where PyOrient queries the database and returns the single requested record, you can also implement a [Fetch Plan](Fetching Strategies.md) through this method.  When you need to traverse connected records, this feature allows you to take advantage of early loads, ensuring that the client only needs to make one request, rather than sending a series of additional requests for the connected records.

Consider the example of a smart home database.  In each room of your house you have installed a series of Arduino- or Micro Python-based devices to record environmental conditions, such as light and noise levels, pollen count, smoke and carbon monoxide detectors and so on.  Every fifteen minutes your application checks in with these devices and takes an average of their readings, logging its findings to OrientDB.

In building a web interface to serve as a control panel, you might want to extract this data by room or zone to generate graphs illustrating how conditions have changed over time.  For example, you might find it useful to combine the senor readings for your bedroom with a sleep monitor.

```py
zone = Zone('bedroom')

client.db_record_load('#14:33', '*:-1', zone.add_sensors)
```

Here, we initialize a Python `Zone` class, which we've defined elsewhere as a bedroom instance.  Once this is done, we ask PyOrient to all records associated with #14:33, (that is, the master bedroom).  PyOrient then passes the results to the `add_sensors()` method defined on the `Zone` class.  Once this is complete, we can use the `zone` class object in rendering a report for the control panel.
