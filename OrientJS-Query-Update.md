# OrientJS - `update()` 

Update queries in OrientJS are those used in changing or otherwise modifying existing records in the database.  The method is comparable to the [`UPDATE`](SQL-Update.md) command on the OrientDB Console.

## Working with Update Queries

In OrientJS, updating records works through the `update()` method.  The examples below operate on a database of baseball statistics, which has been initialized on the `db` variable.

### Updating Records

When the record already exists in the database, you can update the content to modify the current values stored on the class.

Consider the case where you want to update player data after a game.  For instance, last night the Boston Red Sox played and you want to update the batting average for the player Tito Ortiz, who has a Record ID #12:97.  You've set the new batting average on the variable `newBA` and now you want to pass the new data to OrientDB.


```js
var update = db.update('#12:97')
   .set({
      ba: newBA
   }).one();
console.log('Updated ', update);
```

### Putting in Map Entires

When working with map fields, you sometimes need to put entries into map properties.  In the OrientDB Console, you can do this with the `PUT` clause, in OrientJS you can do so through the `put()` method.

```js
var total = db.update('#1:1')
   .put('mapProperty', {
      key: 'value',
      foo: 'bar'
   })
   .scalar();
console.log('Updated', total, 'records');
```


