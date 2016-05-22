# OrientJS Server API

With OrientJS installed on your system with OrientDB, you can begin to develop applications around it.


## Initializing Server Connections

Now that you have OrientJS installed on your system, you can begin to use it in your applications.  In order to do so, you need to initialize your connection to the OrientDB server, you also need to close that connection when you're done using it.

For instance, to initialize client connection to OrientDB,

```javascript
var OrientDB = require('orientjs');

var server = OrientDB({
   host:       'localhost',
   port:       2424,
   username:   'root',
   password:   'root_passwd'
});
```

Your application uses this code to initialize the `server` object.  It then connects to OrientDB using `root` and `root_passwd` as the login credentials.

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
