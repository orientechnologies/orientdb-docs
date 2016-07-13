# OrientJS - `liveQuery()`

When using traditional queries, such as those called with `db.query()` and `db.select()` you only get data that is current at the time the query is issued.  Beginning in version 2.1, OrientDB now supports [Live Queries](Live-Query.md), where in issuing the query you tell OrientDB you want it to push affecting changes to your application.

You can execute Live Queries using the `db.liveQuery()` method with a [`LIVE SELECT`](SQL-Live-Select.md) statement passed as its argument. 

## Understanding Live Queries

Traditional queries provide you with information that is current at the time the query is issued.  In most cases, such as well pulling statistical data on long-dead ball players like Ty Cobb, this behavior is sufficient to your needs.  But, what if about when you need real time information.

For instance, what if in addition to historical data you also want your application to serve real-time information about baseball games as they're being played.

With the traditional query, you would have to reissue the query within a set interval to update the application.  Live Queries allow you to register events, so that your application performs addition operations in the event of an [`INSERT`](SQL-Insert.md), [`DELETE`](SQL-Delete.md), or [`UPDATE`](SQL-Update.md).
  
For example, say that you have a web application that uses the baseball database.  The application serves the current score and various other stats for the game.  Whenever your back-end system inserts new records for the game, you can execute a function to update the display information.

>For more information on event handlers in OrientJS, see [Events](OrientJS-Events.md).

## Working with Live Queries

In OrientJS, Live Queries are called using the `db.liveQuery()` method.  This is similar to `db.query()` in that you use it to issue the raw SQL of a [`LIVE SELECT`](SQL-Live-Select.md) statement.  Unlike `db.query()`, you can assign event handlers to `db.liveQuery` using the `on()` method.

For instance,

```js
db.liveQuery('LIVE SELECT FROM V')
   .on('live-update', function(data){
      var myRecord = data.content;
   });
```

This would assign to the variable `myRecord` object data in response to each update made to the class `V`.  For instance,

```js
db.update('#12:97')
   .set({
      ba: 0.321
   }).one(); 
```

When your application runs this method, it also sets the `myRecord` variable to

```js
var myRecord = {
   content: {
      @rid: $12:97,
      ba: 0.321
   },
   operation: update
};
```

You can then use this information in your code to determine what your application should do in response.


### Running Events on Insert

When you pass the `liveQuery().on()` method the string `live-insert`, it executes the function argument whenever an insert operation is performed on the class.  

For instance, say that you want to pass statistics on new plays to your game monitoring application:

```js
db.liveQuery('LIVE SELECT FROM Game '
             + WHERE game_id = "201606-001"')
   .on('live-insert', function(data){
      var gameStat = data.content;
		  if (gameStat.score != currentScore){
         var score = updateScore(gameStat.score);
         console.log("Updated Score:", score);
      }
   });
```

Here, the Live Query registers an event to [`INSERT`](SQL-Insert.md) events on the `Game` class where the `game_id` property equals the one currently being played.  Whenever the back-end service inserts data on a new play, the application checks for changes in the score.  When either team scores, it passes the score to an `updateScore` function, which we might use to trigger a notification event in the web browser to let the user know their team scored run or runs.

### Running Events on Delete

When you pass the `liveQuery().on()` method the string `live-delete`, it executes the function argument whenever a delete operation is performed on the class.

For instance, for the baseball database, say that you only calculate player batting averages after each game instead of on the fly.  You might set up an event to process new batting averages whenever the stored values are deleted.

```js
db.liveQuery('LIVE SELECT rid, name, ba FROM Player`)
   .on('live-delete' function(data.content){
      var player = data.content;
			var newBA = genBatAvg(player.rid);
      db.update(player.rid)
         .set({
            ba: newBa
         }).one()
         then(
            function(update){
               console.log("Updated BA: " update.name);
            }
         );
   });
```  

Now, whenever your application issues a [`delete()`](OrientJS-Query-Delete.md) statement against the player's batting average, it triggers this function to generate a new batting average and runs the [`update()`](OrientJS-Query-Update.md) method to apply the changes to the player's record.  Once this operation is complete, all queries made against this class will use the new data.


### Running Events on Updates

When you pass the `liveQuery().on()` method the string `live-update`, it executes the function argument whenever an update operation is performed on the class.

For instance, say that as a security precaution, you would like your application to email you whenever certain key changes are made to the `OUser` class, such as an update that escalates user privileges.  You might use something like this,

```js
db.liveQuery('LIVE SELECT FROM OUser')
   .on('live-update', function(data){
      var report = reportChange(data.content);
      console.log("Report:", report);
   });
```

When your application contains this code, any changes on the database that issue [`UPDATE`](SQL-Update.md) queries to the `OUser` class are passed to the `reportChange()` function, which you can use to determine whether or not the changes are legitimate and if they're not, what you want it to do or who it should notify about suspicious activity. 
