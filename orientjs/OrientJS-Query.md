---
search:
   keywords: ['OrientJS', 'query']
---

# Queries in OrientJS

Where the features described in previous chapters operate through their own API's, OrientJS handles queries as a series of methods tied to the [Database API](OrientJS-Database.md).  Once you've initialized the variable for your database, (here called `db`), you can execute queries through it to get data from OrientDB.

There are two methods available in issuing queries to the database.  You can query it directly in SQL.  Alternatively, you can use the Query Builder methods to construct your query in Node.js.


## Working with Queries

When querying the database directly, you prepare a string containing OrientDB [SQL](../SQL.md), the pass it to either the `db.query()` or `db.exec()` methods.  For instance, going back to the baseball database, say that you want a list of players with a batting average of at least .300 that played for the Red Sox.

```js
db.query(
   'SELECT name, ba FROM Player '
   + 'WHERE ba >= 0.3 AND team = "Red Sox"'
).then(function(hitters){
   console.log(hitters)
});
```

### Using Parameters

In the event that you want to query other teams and batting averages, such as the case where you want your application to serve a website, you can use previously defined variables, (here, `targetBA` and `targetTeam`), to set these parameters.  You can also add a limit to minimize the amount of data your application needs to parse.

>Do not enclose param placeholders in single/double quotes in query string. Query parameters are properly encoded by their type. Given example below, the executed query will be `SELECT name, ba FROM Player WHERE ba >= 0.3 AND team = "Red Sox" LIMIT 20` 

```js
var targetBA = 0.3;
var targetTeam = 'Red Sox';

db.query(
   'SELECT name, ba FROM Player '
   + 'WHERE ba >= :ba AND team = :team',
   {params:{
            ba: targetBA,
            team: targetTeam
           },
    limit: 20
   }
).then(function(hitters){
   console.log(hitters)
});
```

### Using Fetching Strategies

While the `query()` method supports most OrientDB SQL statements, there are some limitations in regards to [Fetching Strategies](../Fetching-Strategies.md).

The `query()` method does not support Fetching Strategies directly.For instance, say that you want to query the player records in your baseball database with baseball card images.  From the OrientDB Console, you might issue this command:

<pre>
orientdb> <code class="lang-sql userinput">SELECT name, OUT("hasCard") AS cards
          FROM Player FETCHPLAN *:1</code>
</pre>

This would return a result-set with the player's name in one colmn and an array from the `Card` class with all properties on that class, (as expected).  If instead, you passed this query in OrientJS through the `query()` method, you would meet with different results:

```js
db.query(
   'SELECT name, OUT("hasCard") AS cards '
   + 'FROM Player FETCHPLAN *:1')
   .then(function(results){
   console.log(results)
})
```

Using this code, instead of fetching and unpacking the relationship connecting the `Player` and `Card` class, the `card` column would only contain an array of Record ID's, ignoring the Fetch Plan.  The reason is that it expects to parse Fetch Plans as part of a parameter option, rather than with the query itself.  To use Fetching Strategies with OrientJS, pass it as a parameter:

```js
var results = db.query(
   'SELECT name, OUT("hasCard") AS cards '
   + 'FROM Player',
   {fetchPlan: 'hasCard:1'})
    .then(function(results){
   console.log(results)
})
```

## Query Builder

Rather than writing out query strings in SQL, you can alternatively use the OrientJS Query Builder to construct queries using a series of methods connected through the Database API.

| Method | Description |
|---|---|
| [**`create()`**](OrientJS-Query-Create.md) | Creates vertices and edges. |
| [**`delete()`**](OrientJS-Query-Delete.md) | Removes vertices, edges, and records.|
| [**`fetch()`**](OrientJS-Query-Fetch.md) | Defines a [Fetching Strategy](../Fetching-Strategies.md).|
| [**`insert()`**](OrientJS-Query-Insert.md)| Adds records.|
| [**`liveQuery()`**](OrientJS-Query-Live-Query.md) | Executes a Live Query. |
| [**`select()`**](OrientJS-Query-Select.md)| Fetches records by query.|
| [**`transform()`**](OrientJS-Query-Transform.md)| Modifies records in transit.|
| [**`traverse()`**](OrientJS-Query-Traverse.md) | Fetches records by traversal.|
| [**`update()`**](OrientJS-Query-Update.md)| Modifies records on database.|


