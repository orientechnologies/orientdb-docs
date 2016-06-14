# OrientJS Index API

Once you have initialized a database instance, you can create and fetch indices from OrientDB, using the OrientJS Index API.  This allows you to work with and take advantage of indexing features in OrientDB directly from within your application.

>By convention, the variable on which you initialize the Database API is called `db`.  This designation is arbitrary and used only for convenience.


## Working with Indices

Methods tied to the Index API are accessible through the Database API: `db.index.<method>`.  In OrientDB, indices are set as properties on the class they index.

### Creating Indexes

Using the Index API, you create an index property on a given class through the `db.index.create()` method.  For instance,

```js
var indexName = db.index.create({
   name: 'Player.name',
   type: 'fulltext'
});
console.log('Created Index: ' + indexName.name);
```

In the baseball statistics database, you may find yourself often searching for players by name.  The above example creates a Full Text index on the `name` property of `Player` using the SB-Tree indexing algorithm.

>For more information on indices in OrientDB, see [Indexes](Indexes.md).

### Getting Indexes

In the event that you would like to operate on an index object directly from within your application, you can fetch using the `db.index.get()` method.  You can then use the `get()` method on the return object to search for values.  For instance,


```js
var indexName = db.index.get('Player.name');
var cobb = indexName.get('Ty Cobb');
```

Here, on the class `Player`, you retrieve the index on the `name` property, defining it as `indexName`, then using the `get()` method you search for the player entry on Ty Cobb.
