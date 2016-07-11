# OrientJS Server API

With OrientJS installed on your system, you can now begin to develop applications around it.  In your code, this starts with initializing the client connection between your application and the OrientDB Server, which is managed through the OrientJS Server API.

>By convention, the variable on which you initialize the Server API is called `server`. This designation is arbitrary and used only for convenience.



## Initializing the Server API

In order to use the OrientDB with your Node.js application, you first need to initialize the Server API.  This provides your application with the tools it needs in interacting with the OrientDB server to find and access the necessary database objects.

```javascript
var OrientDB = require('orientjs');

var server = OrientDB({
   host:       'localhost',
   port:       2424,
   username:   'root',
   password:   'root_passwd'
});
```

Your application uses this code to initialize the `server` variable.  It then connects to OrientDB using `root` and `root_passwd` as the login credentials.

When you're done with the server, you need to close it to free up system resources.

```javascript
server.close();
```


### Using Tokens

OrientJS supports tokens through the [Network Binary Protocol](Network-Binary-Protocol.md#token).  To use it in your application, define the `useToken` configuration parameter when you initialize the server connection.

For instance,

```javascript
var server = OrientDB({
   host:     'localhost',
   port:     2424,
   username: 'root',
   password: 'root_passwd',
   useToken: true
});
```

### Using Distributed Databases

Beginning in version 2.1.11 of OrientJS, you can develop Node.js applications to use distributed database instances.  To do so, define the `servers` configuration parameter when you initialize the server connection.  OrientJS uses these as alternate hosts in the event that it encounters an error while connecting to the primary host.

When using this method, the only requisite is that at least one of these servers must be online when the application attempts to establish its first connection.

```js
var server = OrientDB({
   host:     '10.0.1.5',
   port:     2424,
   username: 'root',
   password: 'root_passwd',
   servers:  [{host: '10.0.1.5', port: 2425}]
});

var db = server.use({
   name:     'GratefulDeadConcerts',
   username: 'admin',
   password: 'admin_passwd'
});
```

The only prerequisite when executing this code is that at least one of the hosts, primary or secondary, be online at the time that it first runs.  Once it has established this initial connection, OrientJS keeps the list up to date with those servers in the cluster that are currently online.  It manages this through the push notifications that OrientDB sends to connected clients when changes occur in cluster membership.

>**NOTE**: Distributed Database support in OrientJS remains experimental.  It is recommended that you don't use it in production.



## Working with Server

Once you have initialized the `server` variable in your application, you can use it to manage and otherwise work with the OrientDB Server, such as listing the current databases and creating new databases on the server.  It also provides methods to initialize the OrientJS [Database API](OrientJS-Database.md) variables, which are covered in more detail elsewhere.


### Listing Databases

Using the Server API you can list the current databases on the Server using the `server.list()` method.  This returns a list object, which you can store as a variable and use elsewhere, or you can pass it to the `console.log()` function to print the number of databases available on the server.

```js
server.list().then(function(dbs){
   console.log('There are ' + dbs.length + ' databases on the server.');
});

```

Here, the database list is set to the variable `dbs`, which then uses the `.length` operator to find the number of entries in the list.  You might use the `server.list()` method in your application logic in determining whether you need to create a database before attempting to connect to one.



### Creating Databases

In the event that you need to create a database on OrientDB, you can do so through the Server API using the `server.create()` method.  Similar to `server.use()`, this method initializes an OrientJS [Database API](OrientJS-Database.md) variable, which you can then use elsewhere to work with the specific databases on your server.

```js
var db = server.create({
   name:    'BaseballStats',
   type:    'graph',
   storage: 'plocal'
}).then(function(db){
   console.log('Created a database called ' + db.name);
});

```

Using this code creates a database for baseball statistics on the OrientDB Server. Within your application, it also initializes a Database API variable called `db`.  Then it logs a message about what it did to the console.


### Using Databases

In the event that the database already exists on your server, you can set an instance using the `server.use()` method.  Similar to `server.create()`, this method initializes an OrientJS [Database API](OrientJS-Database.md) variable, which you can then use elsewhere to work with the specific databases on your server.

```js
var db = server.use('BaseballStats');
console.log('Using database: ' + db.name);
```

Using this code initializes an instance of the `BaseballStats` database within your application called `db`.  You can now use this instance to work with that database.


### Closing Connections

When you're finished with the Server API, you need to close the client connection through the `server.close()` method.  When you call this method, OrientJS sends a message to OrientDB that it no longer needs these resources, allowing the Server itself to reallocate them to other processes.

```js
server.close()
```
