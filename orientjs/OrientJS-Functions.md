
# OrientJS Function API

In certain use cases you may find yourself in a situation where the available functions and methods supplied by OrientJS are not sufficient to meet your needs.  To manage this, you can create your own, custom functions to use in your application.


## Creating Custom Functions

The Function API is accessible through the [Datatbase API](OrientJS-Database.md).  Once you initialize a database, you can create custom functions through the `db.createFn()` method.

For instance, consider the example database of baseball statistics.  You might want a function to calculate a player's batting average from arguments providing hits and times at bat.

```js
db.createFn("batAvg",
   function(hits, atBats){
      return hits / atBats;
   }
);
```

In the event that you don't want to define a name for the function, it defaults to `Function#name`:

```js
db.createFn(function nameOfFunction(arg1, arg2){
   return arg1 + arg2;
});
```
