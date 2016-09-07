---
search:
   keywords: ['OrientJS', 'Events']
---

# OrientJS Events

On occasion, you may find the need to run additional code around queries outside of the standard query methods.  In OrientJS you can program events to run whenever queries begin and end.

You may find this useful in implementing logging functionality or profiling your system, or in initiating housekeeping tasks in response to certain types of queries.

## Working with Events

The method to create events is accessible through the [Database API](OrientJS-Database.md), using `db.on()`.  The second argument defines the function it executes, the first the event that triggers the function.


### Running Events on Query Start

When you pass the `db.on()` method the string `beginQuery`, it executes the function argument whenever a query starts.  So, for instance, if your application executes the following query,

```js
var query = db.select('name, status').from('OUser')
   .where({"status": "active"})
   .limit(1)
   .fetch({"role": 1})
   .one();
```

The function in `beginQuery` event receives an object that contains data on the query it's executing, this is similar to the data set on the `obj` variable below:

```js
var obj = {
   query: 'SELECT name, status FROM OUser'
           + 'WHERE status = :paramstatus0 LIMIT 1',
   mode: 'a',
   fetchPlan: 'role:1',
   limit: -1,
   params: {
      params: {
         paramstatus0: 'active'
      }
   }
}
```

For instance, say that there is something wrong with your application and for the purposes of debugging, you want to log all queries made to the database.

```js
db.on("beginQuery", function(obj){
   console.log('DEBUG: ', obj);
});
```

### Running Events on Query End

In addition to running your event code at the start of the query, by passing the `endQuery` string to the `db.on()` method, you can define a function to execute after the query finishes.

The function in `endQuery` events receives an object containing data about how the query ran, similar to the data set on the `obj` variable below:

```js
var obj = {
   {
      "err": errObj,
      "result": resultObj,
      "perf": {
         "query": timeInMs
      },
      "input" : inputObj
   }
}
```

Where `inputObj` is the data used for the `beginQuery` event.

For instance, when debugging you might use this event to log errors and performance data to the console:

```js
db.on("endQuery", function(obj){
   console.log("DEBUG: ", obj);
});
```

### Running Events on Live Queries

Beginning in version 2.1, OrientDB introduces Live Queries, which provides support for [`INSERT`](SQL-Insert.md), [`DELETE`](SQL-Delete.md), and [`UPDATE`](SQL-Update.md) events to OrientJS applications.

Unlike other events, these are not set to the Database API itself, but rather through a [`LIVE SELECT`](SQL-Live-Select.md) query that determines what records you want the application to monitor.

For more information and examples, see [`liveQuery()`](OrientJS-Query-Live-Query.md).
