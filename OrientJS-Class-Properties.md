# Working with Properties

With OrientJS, you can access and manipulate properties on your OrientDB database, through the Class API.  This allows you to perform various operations on the classes directly from within your Node.js application.

The examples below use a database of baseball statistics, assuming that you've already created a class for players and initialized it in your code.  For instance,

```js
var Player = db.class.get('Player');
```

Methods that operate on properties use the `class.property` object, such as `Player.property.list()`.


## Listing Properties

In the event that you need to check the schema or are unfamiliar with the properties created on a class, you can retrieve them into a list using the `class.property.list()` method.

For instance, say you want a list of properties set for the class `Player`:

```js
var properties = Player.property.list();
console.log(Player.name + 'class has the following properties',
   properties);
```

## Creating Properties

Using OrientJS, you can define a schema for the classes from within your application by creating properties on the class with the `class.property.create()` method.  For instance,

```js
var name = Player.property.create({
   name: 'name',
   type: 'String'
});
```

This adds a property ot the class where you can give the player's name when entering data.  This is fine if you only have a few properties to create, but in the case of the example, there are a large number of values you might assign to a given player, such as dates of birth and death, team, batting averages, and so on.  You can set multiple properties together by passing `class.property.create()` an array.

```js
var properties = Player.property.create([
   {name: 'dateBirth',
    type: 'Date'},
   {name: 'dateDeath',
    type: 'Date'},
   {name: 'team',
    type: 'String'}
   {name: 'battingAverage',
    type: 'Float'}
]);
```


## Deleting Properties

In the event that you find you have set a property on a class that you want to remove, you can do so from within your application using the `class.property.drop()` method.  For instance, sat that you decide that you want to handle teams as a distinct class rather than a field in `Player`.

```js
Player.property.drop('team');
```


## Renaming Properties

In the event that you want to rename a property through OrientJS, you can do so using the `class.property.rename()` method.

```js
Player.property.rename('battingAverage', 'batAvg');
```
