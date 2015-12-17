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
