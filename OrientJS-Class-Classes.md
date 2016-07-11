# Working with Classes

With OrientJS, you can access and manipulate classes on your OrientDB database, through the Class API.  This allows you to perform various operations on the classes directly from within your Node.js application.


## Listing Classes

Using the Class API, you can retrieve all current classes on the database in a list.  You might do this in checking that the database has been set up or to otherwise ensure that it includes the classes your application requires to operate.

```js
db.class.list().then(function(classes){
   console.log('There are ' + classes.length + ' classes in the db:',
   classes);
});

```

Here, the class list is set to the variable `classes`, which in turn uses the `length` operator to find the number of entries in the list.


## Creating Classes

You can also create classes through the Class API.  You may find this especially useful when setting up a schema on your database.  For instance, on the `BaseballStats` database, you might want to create a class to log statistical information on particular players.

```js
db.class.create('Player').then(function(Player){
   console.log('Created class: ' + Player.name);
});

```

This creates the class `Player` in the database and a cluster `player` in which to store the data.

>To further define the schema, you need to create properties.  For information on how to manage this through the Class API, see [Working with Properties](OrientJS-Class-Properties.md).

### Extending Classes

Sometimes you may want to extend existing classes, such as ones that you've created previously or to create custom vertex and edge classes in a graph database.  You can manage this through the Class API by passing additional arguments to the `db.class.create()` method.

For instance, in the above example you created a class for storing data on players.  Consider the case where you want instances of `Player` to be vertices in a Graph Database.

```js
db.class.create('Player', 'V').then(function(Player){
   console.log('Created Vertex Class: ' + Player.name);
});

```

This creates `Player` as an extension of the vertex class `V`.


## Getting Classes

In order to work with the class, you may need to retrieve the class object from OrientDB.  With OrientJS this is handled by the `db.class.get()` method.

```js
db.class.get('Player').then(function(Player){
   console.log('Retrieved class: ' + Player.name);
});

```

## Updating Classes

In certain situations, you may want to update or otherwise change a class after creating it.  You can do so through the `db.class.update()` method.

For instance, above there were two examples on how to create a class for baseball players, one using the default method and one creating the class as an extension of the vertex class `V`.  By updating the class, you can add the super-class to an existing class, removing the need to create it all over again.

```js
db.class.update({
   name: 'Player',
   superClass: 'V'
}).then(function(){
   console.log('Updated class: ' Player.name
   + ' to extend '
   + Player.superClass);
});

```



