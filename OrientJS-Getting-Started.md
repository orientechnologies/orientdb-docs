# Getting Started with OrientJS

The OrientJS Driver provides support for developing database applications for OrientDB from the Node.js language.  It supports,

- Intuitive API, based on the [Bluebird](https://github.com/petkaantonov/bluebird) promise library.
- Fast Binary Protocol Parser
- Distributed Support
- Multi-Database Access, through the same socket.
- Connection Pooling
- Migration Support
- Simple CLI


## Installation

In order to use OrientJS, you need to install it on your system.  There are two methods available to you in doing this: you can install it from the Node.js repositories or you can download the latest source code and build it on your local system.

Both methods require the Node.js package manager, NPM, and can install OrientJS as either a local or global package.


### Installing from the Node.js Repositories

When you call NPM and provide it with the specific package name, it connects to the Node.js repositories and downloads the source package for OrientJS.  It then installs the package on your system, either at a global level or in the `node_modules` folder of the current working directory.

- To install OrientJS locally in `node_modules`, run the following command:

  <pre>
  $ <code class="lang-sh userinput">npm install orientjs</code>
  </pre>

- To install OrientJS globally, run the following command as root or an administrator:

  <pre>
  # <code class="lang-sh userinput">npm install orientjs -g</code>
  </pre>

Once NPM finishes the install, you can begin to develop database applications using OrientJS.



### Building from the Source Code

When building from source code, you need to download the driver directly from [GitHub](https://github.com/orientechnologies/orientjs), then run NPM against the branch you want to use or test.

1. Using Git, clone the package repository, then enter the new directory:

   <pre>
   $ <code class="lang-sh userinput">git clone https://github.com/orientechnologies/orientjs.git</code>
   $ <code class="lang-sh userinput">cd orientjs</code>
   </pre>

1. When you clone the repository, Git automatically provides you with the current state of the `master` branch.  If you would like to work with another branch, like `develop` or test features on past releases, you need to check out the branch you want.  For instance,

   <pre>
   $ <code class="lang-sh userinput">git checkout develop</code>
   </pre>

1. Once you've selected the branch you want to build, call NPM to handle the installation.

   - To install OrientJS locally, run the following command:

     <pre>
     $ <code class="lang-sh userinput">npm install</code>
     </pre>

   - To install OrientJS globally, instead run this command as root or an administrator:

     <pre>
     # <code class="lang-sh userinput">npm install -g</code>
     </pre>

1. Run the tests to make sure it works:

   <pre>
   $ <code class="lang-sh userinput">npm test</code>
   </pre>

By calling NPM without an argument, it builds the package in the current working directory, here your local copy of the OrientJS GitHub repository.


## Using OrientJS

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
