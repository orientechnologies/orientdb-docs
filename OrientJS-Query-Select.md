# OrientJS - `select()` 

Selection queries in OrientJS are those used to fetch data from the database, so that you can operate on it with your application.  The method is comparable to the [`SELECT`](SQL-Query.md) command in the OrientDB Console.

## Working with Selection Queries

In OrientJS, fetching data from the database uses the `select()` method.  The examples below operate on a database of baseball statistics, which has been initialized on the `db` variable.


### Selecting Records

Use the `select()` method to fetch records from the database.  For instance, say you want a lit of all players with a batting average of .300.

```js
var hitters = db.select().from('Player')
   .where({
      ba: 0.3
   }).all();
console.log('Hitters:', hitters);
```

### Searching Records

Using the `containsText()` method, you can search recods for specific strings.  For instance, say that a user would like information on a particular player, but does not remember the player's full name.  So, they want to fetch every player with the string `Ty` in their name.

```js
var results = db.select().from('Player')
   .containsText({
      name: 'Ty'
   }).all();
console.log('Found Players:', results);
```


### Using Expressions

In the event that you would like to return only certain properties on the class or use OrientDB functions, you can pass the expression as an argument to the `select()` method.

For instance, say you want to know how many players threw right and batted left: 

```js
var count = db.select('count(*)').from('Player')
   .where({
      threw:  'right',
      batted: 'left'
   }).scalar();
console.log('Total:', count);
```

### Returning Specific Fields

Similar to expressions, by passing arguments to the method you can define a specific field that you want to return.  For instance, say you want to list the teams in your baseball database, such as in building links on a directory page.

```js
var teams = db.select('name')
   .from('Teams').all();
console.log('Loading Teams:', teams);
```

### Specifying Default Values

Occasionally, you may encounter issues where your queries return empty fields.  In the event that this creates issues for how your application renders data, you can define default values for certain fields as OrientJS sets them on the variable.

For instance, in the example of the baseball database, consider a case where for some historical players the data is either currently incomplete or entirely unavailable. Rather than serving null values, you can set default values using the `defaults()` method.

```js
var player = db.select('name').from('Player')
   .defaults({
      throws: 'Unknown',
      bats: 'Unknown'
    }).all();
```



