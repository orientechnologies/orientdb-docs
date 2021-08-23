
# OrientJS - `transform()`

When working with queries in OrientJS, you may sometimes need to operate on data before setting it to the variable.  For instance, in cases where the data stored in the database is not in a format that suits your needs.  Transformation allows you to define functions within your application to update or alter the data as it comes in from the database.


## Working with Transformation Queries

In OrientJS, transformation operations are controlled through the `transform()` method as part of a larger query that fetches the data on which you want to operate.


### Transforming Fields

Most of the time, you may find that the data in the database is sufficient to your needs, save for the case of certain fields.  Using this method, you can define transformation functions for individual fields.

For instance, OrientDB stores the user status as a string in all caps, which you may find unsuitable as a return value to display on the user profile.

```js
var user = db.select('name').from('OUser')
   .where({
      status: 'ACTIVE'
   }).transform({
      status: function(status){
         return status.toLowerCase();
      }
   }).limit(1).one()
   .then(
      function(select){
         console.log('User Status Transformed:', select.status);
      }
   );
```

In the `transform()` method, the `toLowerCase()` method operates on the return status to convert `ACTIVE` to `active`.


### Transforming Records

On occasion, you may need to operate on the entire record rather than individual fields.

```js
var user = db.select('name').from('OUser')
   .where({
      status: 'ACTIVE'
   }).transform(
      function(record){
         return new User(record);
      }
   ).limit(1).one()
   .then(
      function(select){
         console.loog(
            'Is the user an instance of User?',
            (user.instanceof User)
         );
      }
   );
```
