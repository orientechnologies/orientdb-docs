---
search:
   keywords: ['PyOrient', 'client', 'query']
---

# PyOrient Client - `query()`

This method issues a synchronous query to the open OrientDB database.  

## Querying Records

In the event that you're more comfortable working in SQL, you can query the OrientDB Server directly from within your PyOrient application using the `query()` method.  This method operates similar to the [`record_load()`](PyOrient-Client-Record-Load.md), [`record_update()`](PyOrient-Client-Record-Update.md) and [`create_record()`](PyOrient-Client-Record-Create.md) methods, depending on the SQL you use.

>In the event that you want to make an asynchronous query, see the [`query_async()`](PyOrient-Client-Query-Async.md) method.

**Syntax**

```
client.query(<query>, <limit>, <fetch-plan>)
```

- **`<query>`** Defines the SQL you want to send to OrientDB.
- **`<limit>`** Defines the number of results you want returned, defaults to all results.
- **`<fetch-plan>`** Defines the fetching strategy you want to use.

**Example**

Consider the example of the smart home database, where your application is logging readings from various Arduino or Micro Python sensors to OrientDB.  In building the web interface for this system, say that you want to pull all pollen data recorded to the database.

```py
data = client.query("SELECT FROM Sensors "
                    "WHERE sensorType = 'Pollen'", 
                    100)
```

Here, your application queries the `Sensors` class for all records that pertain to pollen sensors.  It then sets the return value to the `data` object.  You can now pass this object to a Django or Flask method in rendering it to HTML to use with the web interface.


### Querying Records with Fetch Plans

In OrientDB, [Fetching Strategies](../java/Fetching-Strategies.md) allow you to refine the process the given client uses in retrieving data from the server.  You may find this useful when retrieving a record that contains several layers of linked records.  With a normal query, the client would need to resubmit the request for each additional layer of linked records.  Using a fetch plan, OrientDB with collect all connecting records and send them to PyOrient together.

For instance, in the example of a smart home database say that you want to retrieve all records from sensors in your bedroom.  In the event that you have trouble sleeping, this might help in determining the cause of the problem, allowing you to say connect room temperature or light conditions with your waking up in the middle of the night.

```py
data = client.query("SELECT FROM Sensors "
                    "WHERE room = 'bedroom'",
                    100, "*:-1")
```

Here, the fetching strategy, (given as the third argument) retrieves all connecting records to the bedroom sensors.  It sets the return data to an object, which you can then pass to other methods for analysis or presentation.  You can fine tune how many layers of connecting records OrientDB collects.  For more information, see [Fetching Strategies](../java/Fetching-Strategies.md).
