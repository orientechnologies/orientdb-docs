# PyOrient Client - `query_async()`

This method runs an asynchronous query against the open OrientDB database. 


## Using Asynchronous Queries

In the event that you are building a large or particularly resource intensive application, you may want to consider implementing asynchronous support.  Most client operations execute synchronously.  That is, the method queries the OrientDB Server and the thread waits for its response.  In some situations, such as when you are retrieving a large amount of data, you may want the application to perform other tasks.  

For situations such as this, you can use the `query_async()` method.  In the event that the query is less intensive or for other reasons it's acceptable that it executes synchronously, you can use the [`query()`](PyOrient-Client-Query.md) method.

**Syntax**

```
client.query_async(<query>, <limit>, <fetch-plan>, <callback>)
```

- **`<query>`** Defines the SQL query.
- **`<limit>`** Defines a limit for the result-set.
- **`<fetch-plan>`** Defines a [Fetching Strategy](Fetching-Strategy.md)
- **`<callback>`** Defines the callback function or method.

**Example**

Consider the example of a smart home database.  Say that you've built a system to collect and analyze data gathered from all devices.

```py
# Data Analyzer Class
class DataAnalyzer():

   # Initialize Class
   def __init__(self, client, nodetype):

      # Init Class Variables
      self.client = client

      # Retrieve Data
      query = "SELECT FROM Nodes WHERE nodetype = '%s' % nodetype
      self.data = self.client.query_async(query, "*:-1", self.log_query)

   # Log Record Returns
   def log_query(self, record):
       logging.info("Loading Record: %s" % record._rid)
```
```
