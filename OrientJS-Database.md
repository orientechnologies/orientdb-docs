# OrientJS Database API

Once you have initialized the [Server API](OrientJS-Server.md), you can begin to interact with the databases on the OrientDB Server.  In your code, this starts with initializing a database instance for your application, which is managed through the OrientJS Database API.

>By convention, the variable on which you initialize the Database API is called `db`.  This designation is arbitrary and used only for convenience.


## Initializing the Database API

In order to work with an OrientDB database in your Node.js application, you need to initialize an instance of the Database API.  This provides your application with the tools it needs to access, manipulate and otherwise interact with specific databases.  The initialization process is handled through the Server API, which is called `server` by convention.

For instance, with an existing database,

```js
var db = server.use('BaseballStats');
console.log('Using database: ' + db.name);
```

Using this code, your application would attempt to connect to the `BaseballStats` database.  When it succeeds, it logs a message to the console to tell the user which database they're on.

When you're done with the database, be sure to close the instance,

```js
db.close();
```


### Using Credentials

In the above example, the Database API attempts to load the database using the default credentials, that is the `admin` user with the password `admin`.  That's fine for a database that collects baseball statistics, but may prove problematic in the event that you want to store sensitive information.  You can pass additional objects to the `server.use()` method to use credentials when you initialize the database instance.

```js
var db = server.use({
   name:     'SmartHomeData',
   user:     'smarthome_user',
   password: 'smarthome_passwd'
});
```

Here, you have a database for logging information from various smart home devices.  By passing in the `user` and `password` arguments, you can now use application specific credentials when interacting with the database.  This allows you to implement better security practices on the database, (for instance, by restricting what `smarthome_user` can do).


### Using Standalone Databases

Beginning in version 2.1.11 of OrientJS, you can initialize a database instance without needing to connect to the OrientDB Server.  This is managed through the `ODatabase` class.

For instance, here the application connects to the `GratefulDeadConcerts` database and queries the vertex class, returns its length, then closes the database instance.

```js
var ODatabase = require('orientjs').ODatabase;
var db = new ODatabase({
   host:     'localhost',
   port:     2424,
   username: 'admin',
   password: 'admin',
   name:     'GratefulDeadCocnerts'
});

db.open().then(function() {
   return db.query('SELECT FROM V LIMIT 1');
}).then(function(res){
   console.log(res.length);
   db.close().then(function(){
      console.log('closed');
   });
});
```


## Working with Databases

Methods are tied to the variable you initialize the Database API to: `db.<method>`.  These can also be used to define and call other API's in the OrientJS driver.


### Using the Record API

Methods tied to the Record API are called through the `db.record` object.  These methods allow you to access and manipulate records directly through the Record ID.  For instance, say you want to get the data from the record #1:1:

```js
var rec = db.record.get('#1:1');
```

For more information on the Record API and other methods available, see [Record API](OrientJS-Record.md).


### Using the Class API

Methods tied to the Class API are called through the `db.class` object.  These methods allow you to create, access and manipulate classes directly through their class names.  For instance, say you wanted to create a class in a baseball database for players,

```js
var Player = db.class.create('Player', 'V');
```

For more information on the Class API and other methods available, see [Class API](OrientJS-Class.md).


### Using the Index API

Methods tied to the Index API are called throught the `db.index` object.  These methods all you to create adn fetch index properties for a given class.  For instance, say you want create an index on the `Player` class in your baseball database for the players' names,

```js
var indexName = db.index.create({
   name: 'Player.name',
   type: 'fulltext'
});
```

For more information on the Index API and other methods, see [Index API](OrientJS-Index.md).  For more information on indices in general, see [Indexes](Indexes.md).


### Querying the Database

Unlike the above operations, querying the database does not require that you call a dedicated API.  You can call these methods on the Database API directly, without setting or defining an additional object, using the `db.query()` method.

The `db.query` method executes an SQL query against the opened database.  You can either define these values directly in SQL, or define arbitrary parameters through additional arguments.  

For instance, using the baseball database, say that you want to allow users to retrieve statistical information on players.  They provide the parameters and your application sorts and displays the results.


```js
var targetAvg = 0.3;
var targetTeam = 'Red Sox';

var hitters = db.query(
   'SELECT name, battavg FROM Player WHERE battavg >= :ba AND team = :team', 
   {params: {
      ba: targetAvg,
      team: targetTeam
    },limit: 20 }
);
console.log(hitters);
```

Here, the variables `targetAvg` and `targetTeam` are defined at the start, then the query is run against the `Player` class for Red Sox players with batting averages greater than or equal to .300, printing the return value to the console.

There are a number of more specialized query related methods supported by the Database API.  For more information, see the [Query](OrientJS-Query.md) guide.


### Closing the Database

When you initialize a database instance, OrientDB begins to reserve system resources for the client to access and manipulate data through the server.  In order to free up these resources when you're done, you need to close the open database instance, using the `db.close()` method.

```js
db.close();
```


