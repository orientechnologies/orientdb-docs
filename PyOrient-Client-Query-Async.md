# PyOrient Client - `query_async()`

This method is runs queries against the open OrientDB database, and runs the given callback function for each record the query returns.


## Querying the Database

When you issue a query using the standard [`query()`](PyOrient-Client-Query.md) method, PyOrient issues the query to OrientDB and then waits for the database to return its result-set.  In the case of particularly long running queries, you may want your application to perform some additional checks as it collects records from the query.

Using the `query_async()` method, each individual record PyOrient receives from OrientDB triggers the given callback function or method.


When working with the standard [`query()`](PyOrient-Client-Query.md) method, PyOrient issues the query to OrientDB then sets the subsequent result-set as its return value.  In the time between the issuing of the query and receiving the return value, the application waits.  For most use cases, given OrientDB's performance, this behavior is fine.  But, in the case of particularly long running queries, you may find it undesirable.

In the event that you would like to perform some additional checks or operations while the query runs, you can use the `query_async()` method.  This allows you to perform addition operations on the data as it processes, such as logging or initiating certain calculations in advance of the final result.


**Syntax**

```
client.query_async(<query>, <limit>, <fetch-plan>, <callback>)
```

- **`<query>`** Defines the SQL query.
- **`<limit>`** Defines a limit for the result-set.
- **`<fetch-plan>`** Defines a [Fetching Strategy](Fetching-Strategy.md)
- **`<callback>`** Defines the callback function or method.

**Example**

Consider the example of a smart home system that uses OrientDB for back-end storage.  Say that your application logs data on various environmental sensors.  Given a few dozen sensors and a set of records added at least every fifteen minutes, after a few months this can grow into a very large database.

For instance, say that you have a class used in analyzing data for a web front-end. Using `query_async()` you can call a logging method to report on the records you've retrieved before setting the return value.


```py
# Data Analyzer Class
class DataAnalyzer():

   # Initialize Class
   def __init__(self, client, nodetype):

      # Init Class Variables
      self.client = client
      self.record_count = 0

      # Retrieve Data
      query = "SELECT FROM Nodes WHERE nodetype = '%s' % nodetype
      self.data = self.client.query_async(query, "*:-1", self.log_query)

      # Report Count
      logging.info("Records Retrieved: %s" % self.record_count)

   # Log Record Returns
   def log_query(self, record):
       logging.debug("Loading Record: %s" % record._rid)
       self.record_count += 1
```

Here, when you initialize the `DataAnalyzer` class, you pass to it the PyOrient client and a string indicating the type of sensor nodes you want to analyzie.  The class queries OrientDB for data on these node types.  For each record `query_async()` retrieves, it calls the `log_query()` class method.

For each record retrieved, it calls the logging module to create a debugging event.  It also increments the internal counter `record_count`.  Once the query is complete, it calls logging again to issue an informational event reporting the number of records the query retrieved.
