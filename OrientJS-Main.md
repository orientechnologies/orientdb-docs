# OrientJS driver

Official [orientdb](http://www.orientechnologies.com/orientdb/) driver for node.js. Fast, lightweight, uses the binary protocol.

[![Build Status](https://travis-ci.org/orientechnologies/orientjs.svg?branch=master)](https://travis-ci.org/orientechnologies/orientjs)


# Supported Versions

OrientJS aims to work with version 2.0.0 of OrientDB and later. While it may work with earlier versions, they are not currently supported, [pull requests are welcome!](./CONTRIBUTING.md)

> **IMPORTANT**: OrientJS does not currently support OrientDB's Tree Based [RIDBag](https://github.com/orientechnologies/orientdb/wiki/RidBag) feature because it relies on making additional network requests.
> This means that by default, the result of e.g. `JSON.stringify(record)` for a record with up to 119 edges will be very different from a record with 120+ edges.
> This can lead to very nasty surprises which may not manifest themselves during development but could appear at any time in production.
> There is an [open issue](https://github.com/orientechnologies/orientdb/issues/2315) for this in OrientDB, until that gets fixed, it is **strongly recommended** that you set `RID_BAG_EMBEDDED_TO_SBTREEBONSAI_THRESHOLD` to a very large value, e.g. 2147483647.
> Please see the [relevant section in the OrientDB manual](http://www.orientechnologies.com/docs/2.0/orientdb.wiki/RidBag.html#configuration) for more information.

# Installation

Install via npm.

```sh
npm install orientjs
```

To install OrientJS globally use the `-g` option:

```sh
npm install orientjs -g
```

# Running Tests

To run the test suite, first invoke the following command within the repo, installing the development dependencies:

```sh
npm install
```

Then run the tests:

```sh
npm test
```


# Features

- Tested with latest OrientDB (2.0.x and 2.1).
- Intuitive API, based on [bluebird](https://github.com/petkaantonov/bluebird) promises.
- Fast binary protocol parser.
- Access multiple databases via the same socket.
- Migration support.
- Simple CLI.
- Connection Pooling



# Table of Contents


* [USAGE](#usage)
  * [Server Api](#server-api)



## Usage

### Configuring the Client
```js
var OrientDB = require('orientjs');

var server = OrientDB({
  host: 'localhost',
  port: 2424,
  username: 'root',
  password: 'yourpassword'
});
```

```js
// CLOSE THE CONNECTION AT THE END
server.close();
```


### Server Api

#### Listing the databases on the server

```js
server.list()
.then(function (dbs) {
  console.log('There are ' + dbs.length + ' databases on the server.');
});
```





