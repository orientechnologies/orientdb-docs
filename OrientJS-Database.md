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



### Using the Record API

Methods tied to the Record API are called through the `db.record` object.  These methods allow you to access and manipulate records directly through the Record ID.  For instance, say you want to get the data from the record #1:1:

```js
var rec = db.record.get('#1:1');
```

For more information on other methods available, see [Record API](OrientJS-Record.md).


### Closing the Database

When you initialize a database instance, OrientDB begins to reserve system resources for the client to access and manipulate data through the server.  In order to free up these resources when you're done, you need to close the open database instance, using the `db.close()` method.

```js
db.close();
```


