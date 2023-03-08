
# OrientJS - `fetch()`

In OrientDB, sometimes the default behavior of the [`SELECT`](../sql/SQL-Query.md) command is not sufficient for your needs.  For instance, when your application connects to a remote server, using a fetching strategy can limit the number of times it needs to connect to the remote server.

>For more information, see [Fetching Strategies](../java/Fetching-Strategies.md).


## Working with Fetching Strategies

Using Fetching Strategies in OrientJS operates through the `fetch()` method tied into a larger query.

### Using Depth Levels

When traversing relationships to a vertex, queries can return a great deal more data than you need for the operation.  By defining the depth level, you can limit the number of traversals the query crosses in collecting the data.

For instance, say you want a list of active users on your database.  Using this method, you can limit the size of the load by only traversing to the fifth level.

```js
var users = db.select().from('OUser')
   .where({
     status: 'ACTIVE'
   }).fetch({
      role: 5
   }).all()
   .then(
      function(data){
         console.log('Active Users: ' + users);
      }
   );
```



