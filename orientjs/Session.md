---
search:
   keywords: ['OrientJS', 'Node.js', 'node','Client']
---

# Session API

A Session instance can be used for:

- Run a Query (Idempotent SQL statement)
- Run a Command (Idempotent or non idempotent SQL statement)
- Run a Batch Script
- Execute a Transaction
- Execute a live query


To obtain a Session instance use the [Cient APIs](Client.md#session-access).

> By convention, the variable on which you initialize the Session API is called session. This designation is arbitrary and used only for convenience.

## Query

The `session.query` method executes an idempotent SQL query against the opened database. You can either define these values directly in SQL, or define arbitrary parameters through additional arguments.
The API call returns an extension of Node.js Streams.


### Streaming

```js
session.query("select from OUser where name = :name", {params: { name: "admin" }})
.on("data", data => {
	console.log(data);
})
.on('error',(err)=> {
  console.log(err);
})
.on("end", () => {
	console.log("End of the stream");
});
```


### To Promise

Use `.all` API that convert the stream to a Promise and collect the result set into an array

```js
session.query("select from OUser where name = :name", { params : {name: "admin" }})
.all()
.then((results)=> {
	console.log(results);
});
```

alternatevely use `.one` API for the first entry only

```js
session.query("select from OUser where name = :name", { params : {name: "admin" }})
.one()
.then((results)=> {
	console.log(results);
});
```

## Command

The `session.command` method executes a SQL query against the opened database and accept non idempotent queries like `insert into`, `create vertex` etc.
The API call returns an extension of Node.js Streams.


```js
session.command("insert into V set name = :name", {params: { name: "test" }})
.all()
.then(result => {
	console.log(result);
});
```

## Batch Script

The `batch` method executes a Multiple SQL query against the opened database.
The API call returns an extension of Node.js Streams.


```js
let batch = `begin;
	let $v1 = create vertex V set name = "first";
	let $v2 = create vertex V set name = "second";
	let $e = create edge E from $v1 to $v2;
	commit;
	return  $e;`;
	
session.batch(batch).all()
  .then(results => {
    console.log(results);
  });
```

## Query/Command/Script Options

Those APIs accepts an options object as second paramenter. 

The options can contains:

- Query parameters
- Additional Configuration 

### Using Parameters

The options object can contain a `params` property that represent the query parameters to use. 

#### Named parameters

```js
session.command("insert into V set name = :name", {params: { name: "test" }})
.all()
.then(result => {
	console.log(result);
});
```

#### Positional parameters

```js
session.command("insert into V set name = ?", {params: ["admin"]})
.all()
.then(result => {
	console.log(result);
});
```


### Additional configuration

Starting from OrientDB 3.0, the result set from a query/command/script is paginated. By default OrientJS uses a page size of `100` records.
Use the additional property `pageSize` to tune this configuration.

```js
session.command("select name from V", {
	params: ["admin"],
	pageSize: 1000
})
.all()
	.then(results => {
	console.log(results);
});
```

## Transactions


Use the api `session.runInTransaction` in order to run a unit of work in a managed transaction (begin/commit/retry). The unit of work provided in input should return a Promise. The return of `session.runInTransaction` is a Promise that once resolved, returns the result of the last operation in the unit of work and the result of the `commit` of the transaction.

> The Session supports only 1 transaction at time.
Use multiple sessions if you want to run concurrent transactions.


```js
session.runInTransaction((tx)=>{
	return tx.command("insert into V set name = :name", {params: { name: "test" }}).all()
}).then(({result,tx}) => {
	console.log(result);
	console.log(tx);
});
```

alternativelly using explicit API

```js
session.begin();
session.command("insert into V set name = :name", {
	params: { name: "admin" }
})
.one()
.then(results => {
	console.log(results);
	return session.commit();
})
.then(results => {
	console.log(results);
});
```


## Live Queries

When using traditional queries, such as those called with `session.query()` and `session.select()` you only get data that is current at the time the query is issued.  Beginning in version 2.1, OrientDB now supports [Live Queries](Live-Query.md), where in issuing the query you tell OrientDB you want it to push affecting changes to your application.

You can execute Live Queries using the `session.liveQuery()` method with a [`LIVE SELECT`](SQL-Live-Select.md) statement passed as its argument. 


### Understanding Live Queries

Traditional queries provide you with information that is current at the time the query is issued.  In most cases, such as well pulling statistical data on long-dead ball players like Ty Cobb, this behavior is sufficient to your needs.  But, what if about when you need real time information.

For instance, what if in addition to historical data you also want your application to serve real-time information about baseball games as they're being played.

With the traditional query, you would have to reissue the query within a set interval to update the application.  Live Queries allow you to register events, so that your application performs addition operations in the event of an [`INSERT`](SQL-Insert.md), [`DELETE`](SQL-Delete.md), or [`UPDATE`](SQL-Update.md).
  
For example, say that you have a web application that uses the baseball database.  The application serves the current score and various other stats for the game.  Whenever your back-end system inserts new records for the game, you can execute a function to update the display information.

### Working with Live Queries

In OrientJS, Live Queries are called using the `session.liveQuery()` method.  This is similar to `session.query()` in that you use it to issue the raw SQL of a [`LIVE SELECT`](SQL-Live-Select.md) statement.  You can assign event handlers to `session.liveQuery` using the `on('data')` method. The methods returns an extension of Node.JS Streams

For instance,


```js
session.liveQuery("select from V").on("data", data => {
	console.log(data);
});
```

The data object is emitted every time the live query is matched and it contains those properties

- **monitorId** : identifier of the live query on the server.
- **operation** : identifier of the operation executed
	- 1 - Create
	- 2 - Update
	- 3 - Delete
- **data** : the actual matched record.
- **before** : in case of update, the previously version of the record changed.

```JSON
{ 
	monitorId: 275616756,
	operation: 1,
	data:
  		{ 
  			name: 'Foo',
     		'@rid': RecordID { cluster: 10, position: 12 },
     		'@class': 'V',
     		'@version': 1 
     	} 
}
```



### Unsubscribing Live Queries

To unsubscribe a live query, use the API `handle.unsubscribe` where
`handle` is the returned value of the `liveQuery` function

```js
let handle = session.liveQuery("select from V").on("data", data => {
	console.log(data);
	handle.unsubscribe();
});
```

## Query Builder

Rather than writing out query strings in SQL, you can alternatively use the OrientJS Query Builder to construct queries using a series of methods connected through the Database API.

- **create**: Creates vertices and edges.
- **insert**: Insert records
- **update**: Modifies records on database.
- **select**: Fetches records by query.
- **delete**: Removes vertices, edges, and records.


### Create

Creation queries in OrientJS are those used in creating vertex and edge records on a Graph Database. Given the added complexity of regular or lightweight edges running between the vertices, adding records is a little more complicated than the insert() method you might use otherwise.

The creation query method is comparable to the CREATE VERTEX and CREATE EDGE commands on the OrientDB Console.

In OrientJS, creating vertices and edges uses the create() method. The examples below operate on a database of baseball statistics, which has been initialized on the db variable.


#### Creating Vertices

Create an empty vertex on the `Player` vertex class:

```js
session.create("VERTEX", `Player`).one()
.then(results => {
	console.log(results);
});
```

Create a vertex with properties:

```js
session.create("VERTEX", "Player").set({
	name: "Ty Cobb",
	birthDate: "1886-12-18",
	deathDate: "1961-7-17",
	batted: "left",
	threw: "right"
})
.one()
.then((player)=> {
	console.log(player);
});
```

#### Creating Edges

Creating edges to connect two vertices follows the same pattern as creating vertices, with the addition of `from()` and `to()` methods to show the edge direction.

For instance, consider an edge class `PlaysFor` that you use to connect player and team vertices.  Using it, you might create a simple edge that simply establishes the connection:

```js
session.create("EDGE", "PlaysFor")
.from("#12:12").to("#12:13")
.one()
.then(edge => {
	console.log(edge);
});
```

This creates an edge between the player Ty Cobb, (#12:12), and the Detroit Tigers, (#12:13).  While this approach may be useful with players that stay with the same team, many don't.  In order to account for this, you would need to define properties on the edge.

```js
session.create("EDGE", "PlaysFor")
.from("#12:12").to("#12:13")
.set({
	startYear: "1905",
	endYear: "1926"
})
.one()
.then(edge => {
	console.log(edge);
});
```

Now, whenever you build queries to show the players for a team, you can include conditionals to only show what teams they played for in a given year.
