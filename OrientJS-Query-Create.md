# OrientJS - `create()`

Creation queries in OrientJS are those used in creating vertex and edge records on a Graph Database.  Given the added complexity of regular or lightweight edges running between the vertices, adding records is a little more complicated than the [`insert()`](OrientJS-Query-Insert) method you might use otherwise.

The creation query method is comparable to the [`CREATE VERTEX`](SQL-Create-Vertex.md) and [`CREATE EDGE`](SQL-Create-Edge.md) commands on the OrientDB Console.


## Working with Creation Queries

In OrientJS, creating vertices and edges uses the `create()` method.  The examples below operate on a database of baseball statistics, which has been initialized on the `db` variable.


### Creating Vertices

Create an empty vertex on the `Player` vertex class:

```js
var player = db.create('VERTEX', `Player`).one();
console.log('Created Vertex:', player);
```

Create a vertex with properties:

```js
var player = db.create('VERTEX', 'Player)
   .set({
      name:      'Ty Cobb',
      birthDate: '1886-12-18',
      deathDate: '1961-7-17',
      batted:    'left',
      threw:     'right'
   }).one();
console.log('Created Vertex: ' +  player.name)
```

### Creating Edges

Creating edges to connect two vertices follows the same pattern as creating vertices, with the addition of `from()` and `to()` methods to show the edge direction.

For instance, consider an edge class `PlaysFor` that you use to connect player and team vertices.  Using it, you might create a simple edge that simply establishes the connection:

```js
var playsFor = db.create('EDGE', 'PlaysFor')
   .from('#12:12').to('#12:13').one();
```

This creates an edge between the player Ty Cobb, (#12:12), and the Detroit Tigers, (#12:13).  While this approach may be useful with players that stay with the same team, many don't.  In order to account for this, you would need to define properties on the edge. 

```js
var playsFor = db.create('EDGE', 'PlaysFor')
   .from('#12:12').to('#12:13')
   .set({
      startYear: "1905",
      endYear: "1926",
   }).one();
```

Now, whenever you build queries to show the players for a team, you can include conditionals to only show what teams they played for in a given year.
