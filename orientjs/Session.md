---
search:
   keywords: ['OrientJS', 'Node.js', 'node','Client','Query', 'Delete','Live Query','Session']
---

# Session API

A Session instance can be used for:
- List classes and schema information
- Run a Query (Idempotent SQL statement)
- Run a Command (Idempotent or non idempotent SQL statement)
- Run a Batch Script
- Execute a Transaction
- Execute a live query
- Use query builder


To obtain a Session instance use the [Cient APIs](Client.md#sessions).

> By convention, the variable on which you initialize the Session API is called session. This designation is arbitrary and used only for convenience.

## List Classes

You can query the classes that are available in your db. This can be particularly useful when you want to know whether a class already exists before trying to create it.


```js
session.class.list()
.then((classes)=> {
	const classnames = classes.map(c=>c.name);
	console.log(classnames);
});
```

or with async/await

```js
try {
	let classes = await session
	.class.list()
	
	const classnames = classes.map(c=>c.name);
	console.log(classnames);
} catch (e) {
	console.log(e);
}
```

## List Properties of a Class

If you would like to list the properties of a class, get the class info first them list the properties from the property key of the returned object.


```js
    session.class.get('User').then(classinfo => {
    
      const properties = classinfo.property.list();
      
      console.log('class info', properties);
    });
```

or with async/await

```js
try {
	let classes = await session
	.class.get('User)
	
	 const properties = classinfo.property.list();
      
      	 console.log('class info', properties);
} catch (e) {
	console.log(e);
}
```

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

or with async/await

```js
try {
	let results = await session
	.query("select from OUser where name = :name", {
		params: { name: "admin" }
	})
	.all();
	console.log(results);
} catch (e) {
	console.log(e);
}
```

Alternatevely use `.one` API for the first entry only

```js
session.query("select from OUser where name = :name", { params : {name: "admin" }})
.one()
.then((results)=> {
	console.log(results);
});
```

or with async/await

```js
try {
	let results = await session
	.query("select from OUser where name = :name", {
		params: { name: "admin" }
	})
	.one();
	console.log(results);
} catch (e) {
	console.log(e);
}
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

or with async/await

```js
try {
	let results = await session
	.command("insert into V set name = :name", { params: { name: "test" } })
	.all();
	console.log(results);
} catch (e) {
	console.log(e);
}
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

or with async/await

```js
try {
	let batch = `begin;
	let $v1 = create vertex V set name = "first";
	let $v2 = create vertex V set name = "second";
	let $e = create edge E from $v1 to $v2;
	commit;
	return  $e;`;

	let results = await session.batch(batch).all();
	console.log(results);
} catch (e) {
	console.log(e);
}
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
	return tx.command("insert into V set name = :name", {params: { name: "test" }})
	.all();
}).then(({result,tx}) => {
	console.log(result);
	console.log(tx);
});
```

alternativelly using explicit API

```js
session.begin();
session.command("insert into V set name = :name", {
	params: { name: "admin" }})
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

When using traditional queries, such as those called with `session.query()` and `session.select()` you only get data that is current at the time the query is issued.  Beginning in version 2.1, OrientDB now supports [Live Queries](../java/Live-Query.md), where in issuing the query you tell OrientDB you want it to push affecting changes to your application.

You can execute Live Queries using the `session.liveQuery()` method with a [`LIVE SELECT`](../sql/SQL-Live-Select.md) statement passed as its argument. 


### Understanding Live Queries

Traditional queries provide you with information that is current at the time the query is issued.  In most cases, such as well pulling statistical data on long-dead ball players like Ty Cobb, this behavior is sufficient to your needs.  But, what if about when you need real time information.

For instance, what if in addition to historical data you also want your application to serve real-time information about baseball games as they're being played.

With the traditional query, you would have to reissue the query within a set interval to update the application.  Live Queries allow you to register events, so that your application performs addition operations in the event of an [`INSERT`](../sql/SQL-Insert.md), [`DELETE`](../sql/SQL-Delete.md), or [`UPDATE`](../sql/SQL-Update.md).
  
For example, say that you have a web application that uses the baseball database.  The application serves the current score and various other stats for the game.  Whenever your back-end system inserts new records for the game, you can execute a function to update the display information.

### Working with Live Queries

In OrientJS, Live Queries are called using the `session.liveQuery()` method.  This is similar to `session.query()` in that you use it to issue the raw SQL of a [`LIVE SELECT`](../sql/SQL-Live-Select.md) statement.  You can assign event handlers to `session.liveQuery` using the `on('data')` method. The methods returns an extension of Node.JS Streams

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
- **delete**: Removes vertices, edges, and records.
- **select**: Fetches records by query.


### Create

Creation queries in OrientJS are those used in creating vertex and edge records on a Graph Database. Given the added complexity of regular or lightweight edges running between the vertices, adding records is a little more complicated than the insert() method you might use otherwise.

The creation query method is comparable to the [`CREATE VERTEX`](../sql/SQL-Create-Vertex.md) and [`CREATE EDGE`](../sql/SQL-Create-Edge.md) commands on the OrientDB Console.

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
session.create("VERTEX", "Player")
	.set({
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


### Insert


Insertion queries in OrientJS are those that add records of a given class into the database.  The insertion query method is comparable to the [`INSERT`](../sql/SQL-Insert.md) commands on the OrientDB Console.



Example

In OrientJS, inserting data into the database uses the `insert()` method.  For instance, say that you want to add batting averages, runs and runs batted in for Ty Cobb.


```js
session.insert().into("Player")
	.set({
		ba: 0.367,
		r: 2246,
		rbi: 1938
	})
	.one()
	.then((player) => {
		console.log(player);
	});
```

##### Raw Expressions


```
session.insert().into('Player')
	.set({
		uuid : session.rawExpression("format('%s',uuid())"),
	  	ba:  0.367,
	  	r:   2246,
	  	rbi: 1938
	}).one().then((player)=>{
	   console.log(player)
	});
```


Generated Query

```SQL
INSERT INTO Player SET uuid = format('%s',uuid()), ba = 0.367, r = 2246, rbi = 1938

```

### Update

Update queries in OrientJS are those used in changing or otherwise modifying existing records in the database.  The method is comparable to the [`UPDATE`](../sql/SQL-Update.md) command on the OrientDB Console.


In OrientJS, updating records works through the `update()` method.  The examples below operate on a database of baseball statistics, which has been initialized on the `session` variable.

### Updating Records


When the record already exists in the database, you can update the content to modify the current values stored on the class.

Consider the case where you want to update player data after a game.  For instance, last night the Boston Red Sox played and you want to update the batting average for the player Tito Ortiz, who has a Record ID #12:97.  

```
session.update("#12:97")
	.set({
		ba: 3.1
	})
	.one()
	.then(update => {
		console.log("Records Updated:", update);
	});
```

If you don't know the RecordID, alternatevily and more likely you can update with a where condition, for example on the name of the player.

```js
session.update("Player")
	.set({
		ba: 3.1
	})
	.where({ name: "Ty Cobb" })
	.one()
	.then(update => {
		console.log("Records Updated:", update);
	});
```

### Delete

Deletion queries in OrientJS are those used in removing records from the database.  It can also account for edges between vertices, updating the graph to maintain its consistency.

The deletion query method is comparable to [`DELETE`](../sql/SQL-Delete.md), [`DELETE VERTEX`](../sql/SQL-Delete-Vertex.md) and the [`DELETE EDGE`](../sql/SQL-Delete-Edge.md) statements.

In OrientJS, deletions use the `delete()` method.  The examples below operate on a database of baseball statistics, which has been initialized on the `session` variable.


#### Deleting Vertices

With Graph Databases, deleting vertices is a little more complicated than the normal process of deleting records. You need to tell OrientDB that you want to delete a vertex to ensure that it takes the additional steps necessary to update the connecting edges.

For instance you want to remove the player Ty Cobb.

```js
session.delete("VERTEX", "Player")
	.where({ name: "Ty Cobb" })
	.one()
	.then((del)=> {
		console.log("Records Deleted: " + del);
	});
```


#### Deleting Edges

When deleting edges, you need to define the vertices that the edge connects.  For instance, consider the case where you have a bad entry on the `playsFor` edge, where you have Ty Cobb assigned to the Chicago Cubs.  Ty Cobb has a Record ID of #12:12, the Chicago Cubs #12:54.

```js
session.delete('EDGE', 'PlaysFor')
	.from('#12:12').to('#12:54')
	.one()
	.then((del)=>{
	     console.log('Records Deleted: ' + del);
	  }
	);
```

#### Deleting Records

In order to delete records in a given class, you need to define a conditional value that tells OrientDB the specific records in the class that you want to delete.  When working from the Console, you would use the [`WHERE`](../sql/SQL-Where.md) clause.  In OrientJS, set the `where()` method.

```js
session.delete().from('Player')
	.where('@rid = #12:84').limit(1).scalar()
	.then((del)=>{
	     console.log('Records Deleted: ' + del);
	  }
	);
```

### Select

Selection queries in OrientJS are those used to fetch data from the database, so that you can operate on it with your application.  The method is comparable to the [`SELECT`](../sql/SQL-Query.md) command in the OrientDB Console.


In OrientJS, fetching data from the database uses the `select()` method.  The examples below operate on a database of baseball statistics, which has been initialized on the `db` variable.


#### Selecting Records

Use the `select()` method to fetch records from the database.  For instance, say you want a lit of all players with a batting average of .300.

```js
session.select().from("Player")
	.where({
		ba: 0.3
	})
	.all()
	.then(function(select) {
		console.log("Hitters:", select);
	});
```

#### Custom Where

The where clause can take a JSON object for expressing condition.
For more complex condition the where clause can take a string with 
custom conditions and pass eventual parameters in one of the selected 
query terminator (one/all/stream/scalar)



```js
session.select().from("Player")
	.where("ba >= :ba")
	.all({ ba : 0.3})
	.then((select) => {
		console.log("Hitters:", select);
	});
```




#### Using Expressions

In the event that you would like to return only certain properties on the class or use OrientDB functions, you can pass the expression as an argument to the `select()` method.

For instance, say you want to know how many players threw right and batted left:

```js
session.select("count(*)").from("Player")
	.where({
		threw: "right",
		batted: "left"
	})
	.scalar()
	.then((select) => {
		console.log("Total:", select);
	});
```

#### Returning Specific Fields

Similar to expressions, by passing arguments to the method you can define a specific field that you want to return.  For instance, say you want to list the teams in your baseball database, such as in building links on a directory page.

```js
session.select("name").from("Teams")
	.all()
	.then((select)=> {
		console.log("Loading Teams:", select);
	});
```

#### Specifying Default Values

Occasionally, you may encounter issues where your queries return empty fields.  In the event that this creates issues for how your application renders data, you can define default values for certain fields as OrientJS sets them on the variable.

For instance, in the example of the baseball database, consider a case where for some historical players the data is either currently incomplete or entirely unavailable. Rather than serving null values, you can set default values using the `defaults()` method.

```js
session.select("name").from("Player")
	.defaults({
		throws: "Unknown",
		bats: "Unknown"
	}).all()
	.then(players => {
		console.log(players);
	});
```
