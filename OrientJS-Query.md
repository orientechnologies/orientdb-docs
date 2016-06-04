# Queries in OrientJS

Where the features described in previous chapters operate through their own API's, OrientJS handles queries as a series of methods tied to the [Database API](OrientJS-Database.md).  Once you've initialized the variable for your database, (here called `db`), you can execute queries through it to get data from OrientDB.

There are two methods available in issuing queries to the database.  You can query it directly in SQL.  Alternatively, you can use the Query Builder methods to construct your query in Node.js.


## Working with Queries

When querying the database directly, you prepare a string containing OrientDB [SQL](SQL.md), the pass it to either the `db.query()` or `db.exec()` methods.  For instance, going back to the baseball database, say that you want a list of players with a batting average of at least .300 that played for the Red Sox.

```js
var hitters = db.query(
   'SELECT name, ba FROM Player '
   + 'WHERE ba >= 0.3 AND team = "Red Sox"'
);
console.log(hitters);
```

### Using Parameters

In the event that you want to query other teams and batting averages, such as the case where you want your application to serve a website, you can use perviously defined variables, here `targetBA` and `targetTeam`, to set these parameters.  You can also add a limit to minimize the amount of data your application needs to parse.

```js
var hitters = db.query(
   'SELECT name, ba FROM Player '
   + 'WHERE ba >= :ba AND team = ":team"',
   {params:
      ba: targetBA,
      team: targetTeam
   }, limit: 20
);
console.log(hitters);
```


## Query Builder

Rather than writing out query strings in SQL, you can use the OrientJS Query Builder to construct queries using a series of methods connected through the Database API.

- [**`create()`**](OrientJS-Query-Create.md) Method used in creating vertices and edges.
- [**`delete()`**](OrientJS-Query-Delete.md) Method used in removing vertices, edges and records from the database.
- [**`fetch()`**](OrientJS-Query-Fetch.md) Method used in defining a fetching strategy for the query.
- [**`insert()`**](OrientJS-Query-Insert.md) Method used in adding records to the database.
- [**`select()`**](OrientJS-Query-Select.md) Method used in fetching records from the database.
- [**`transform()`**](OrientJS-Query-Transform.md) Method used in modifying fetched data before setting it to the variable.
- [**`traverse()`**](OrientJS-Query-Traverse.md) Method used in traversing relationships when fetching from the database.
- [**`update()`**](OrientJS-Query-Update.md) Method used in updating records on the database.


