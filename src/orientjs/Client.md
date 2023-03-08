

# Client API

The `OrientDBClient` is the entry point of the driver. Once connected it provides APIs for databases manipulation and sessions creation

### Connecting

Use the method `OrientDBClient.connect` to establish a connection to one OrientDB server/cluster. The methods return a Promise. Below an example of a connection to a single OrientDB server. 

```js
const OrientDBClient = require("orientjs").OrientDBClient;

OrientDBClient.connect({
  host: "localhost",
  port: 2424
}).then(client => {
  return client.close();
}).then(()=> {
   console.log("Client closed");
});
```

or with async/await

```js
const OrientDBClient = require("orientjs").OrientDBClient;

(async function() {
  let client;
  try {
    client = await OrientDBClient.connect({ host: "localhost" });
    console.log("Connected");
  } catch (e) {
    console.log(e);
  }

  if (client) {
    await client.close();
    console.log("Disconnected");
  }
})();
```

#### Configuration with OrientDB Cluster

To do so, define the servers configuration parameter when you initialize the server connection. OrientJS uses these as alternate hosts in the event that it encounters an error while connecting to the primary host.

When using this method, the only requisite is that at least one of these servers must be online when the application attempts to establish its first connection. Below an example of a connection with two servers.

```js

const OrientDBClient = require("orientjs").OrientDBClient;

OrientDBClient.connect({
  host: "localhost",
  port: 2424,
  servers : [{host : "localhost", port : 2425}]
}).then(client => {
  return client.close();
}).then(()=> {
   console.log("Client closed");
});

```

or with async/await

```js
const OrientDBClient = require("orientjs").OrientDBClient;

(async function() {
  let client;
  try {
    client = await OrientDBClient.connect({
      host: "localhost",
      port: 2424,
      servers: [{ host: "localhost", port: 2425 }]
    });
    console.log("Connected");
  } catch (e) {
    console.log(e);
  }

  if (client) {
    await client.close();
    console.log("Disconnected");
  }
})();

```


The only prerequisite when executing this code is that at least one of the hosts, primary or secondary, be online at the time that it first runs. Once it has established this initial connection, OrientJS keeps the list up to date with those servers in the cluster that are currently online. It manages this through the push notifications that OrientDB sends to connected clients when changes occur in cluster membership.


#### Connection Pooling

By default OrientJS create a connection pool of 5 sockets. Use the paramenter `pool` in order to change the default configuration.

```js
const OrientDBClient = require("orientjs").OrientDBClient;

OrientDBClient.connect({
  host: "localhost",
  port: 2424,
  pool : { max : 10}
}).then(client => {
  return client.close();
}).then(()=> {
   console.log("Client closed");
});
```

or with async/await

```js
const OrientDBClient = require("orientjs").OrientDBClient;

(async function() {
  let client;
  try {
    client = await OrientDBClient.connect({
      host: "localhost",
      port: 2424,
      pool : { max : 10}
    });
    console.log("Connected");
  } catch (e) {
    console.log(e);
  }

  if (client) {
    await client.close();
    console.log("Disconnected");
  }
})();

```

### Databases Manipulation

Once you have initialized the client variable in your application, you can use it to work with the OrientDB Server, such as creating new databases on the server. It also provides methods to initialize the OrientJS Sessions API, which are covered in more detail below.


#### Create a database

In the event that you need to create a database on OrientDB, you can do so through the OrientDBClient API using the `client.createDatabase ` method.

```js
client.createDatabase({
	name: "test",
	username: "root",
	password: "root"
})
.then(() => {
	console.log("Database created");
})
.catch(err => {
	console.log("Error creating database");
});
```

or with async/await

```js
try {
  await client.createDatabase({
    name: "test",
    username: "root",
    password: "root"
  });
  console.log("Database created");
} catch (e) {
  console.log(e);
}
```

#### Check existence of a databases

```js
client.existsDatabase({
	name: "test",
	username: "root",
	password: "root"
})
.then(result => {
	console.log(result);
})
.catch(err => {
	console.log("Error checking for database");
});
```

or with async/await

```js
try {
  let exists = await client.existsDatabase({
    name: "test",
    username: "root",
    password: "root"
  });
  console.log(exists);
} catch (e) {
  console.log(e);
}

```

#### List Databases

```js
client.listDatabases({
	username: "root",
	password: "root"
})
.then(results => {
	console.log(results);
})
.catch(err => {
	console.log("Error listing databases");
});
```

or with async/await

```js
try {
  let databases = await client.listDatabases({
    name: "test",
    username: "root",
    password: "root"
  });
  console.log(databases);
} catch (e) {
  console.log(e);
}
```

#### Drop a database


```js
client.dropDatabase({
	name: "test",
	username: "root",
	password: "root"
})
.then(() => {
	console.log("Database dropped");
})
.catch(err => {
	console.log("Error dropping the database");
});
```

or with async/await

```js
try {
  await client.dropDatabase({
    name: "test",
    username: "root",
    password: "root"
  });
} catch (e) {
  console.log(e);
}
```

### Sessions

Once you have initialized the client variable in your application, you can use it to open sessions on OrientDB Server. 
You can either open a single session with the API `client.session` or request a pool of sessions with the API `client.sessions`. 
Then use the [Session API](Session.md) to interact with the database.

#### Single Session

To open a new standalone session use the `client.session` api. This api will create a new stateful session associated with the given database and credentials. Once done, call `session.close` in order to release the session on the server. Session are stateful since OrientJS 3.0 as they can execute server side transactions.



```js
client.session({ name: "demodb", username: "admin", password: "admin" })
.then(session => {
	// use the session
	... 
	// close the session
	return session.close();
});
```

or with async/await

```js
try {
  let session = await client.session({
    name: "demodb",
    username: "admin",
    password: "admin"
  });
  // use session

  //close session
  await session.close();
} catch (e) {
  console.log(e);
}
```



#### Pool of Sessions

Opening and closing sessions everytime can be expensive, since open and close require a network request to the server. Use the API `client.sessions` to create a pool of sessions with a given database and credentials. To get a session from the pool call the api `pool.acquire`. Once done with the session you can return the session to the pool by calling `session.close`.

By default the pool size is is 5 sessions. Use the `pool` parameter to change this default configuration.


```js
// Create a sessions Pool
client.sessions({ name: "demodb", username: "admin", password: "admin", pool: { max: 10} })
  .then(pool => {
    // acquire a session
    return pool.acquire()
      .then(session => {
        // use the session
        ...
        // release the session
        return session.close();
      })
      .then(() => {
      	 // close the pool
        return pool.close();
      });
  });
});
```


```js
try {
  let pool = await client.sessions({
    name: "demodb",
    username: "admin",
    password: "admin"
  });
  // acquire a session
  let session = await pool.acquire();
  // use the session

  //close/release session
  await session.close();
  
  // close pool
  await pool.close();
} catch (e) {
  console.log(e);
}
```



