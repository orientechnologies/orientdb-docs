
# Working with Records

With OrientJS you can access and manipulate records on your OrientDB database, through the Class API.  This allows you to perform various operations on the data in a given class directly from within your Node.js application.

The examples below use a database of baseball statistics, assuming that you've already created a class for players and initialized it in your code.  For instance,

```js
db.class.get('Player').then(function(Player){
   Player...
});
```

## Listing Records

With the Class API, you can retrieve all records on the current class into an array using the `db.class.list()` method.  You might do this in operating on records or in collecting them for display in a web application.

```js
Player.list()
   .then(
      function(player){
         console.log('Records Found: ' + records.length());
      }
   );
```

Here, the current list of players in the database are set to the variable `records`, which in turn uses the `length` operator to find the number of entries in the database.


## Creating Records

You can also create records on OrientDB through the `db.class.create()` method.  This creates the class in the database and then retrieves it into a variable for further operations.

```js
Player.create({
   name:      "Ty Cobb",
   birthDate: "1886-12-18",
   deathDate: "1961-7-17",
   batted:    "left",
   threw:     "right"
}).then(
   function(player){
      console.log('Created Record: ' player.name);
   }
);
```

Here, you create an entry for the player Ty Cobb, including information on his dates of birth and death, and the sides he used when batting and throwing, which you might later collate with other players to show say the difference in batting averages and RBI's between left-side batters right-side throwers and left-side batters left-side throwers between the years 1910 and 1920.
