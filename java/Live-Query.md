---
search:
  keywords: ['Java API', 'Live Query']
---

# Live Query

>**NOTE**: This feature was introduced in version 2.1 of OrientDB.  It is not available in older releases.

When you issue a standard query to the database, OrientDB returns a result-set for that moment when it received the query.  Changes that occur on the database after it returns the result-set are not available in the result-set.  Sometimes this behavior is not what you want.

Beginning in version 2.1, OrientDB introduces a new approach to queries, for cases when you need to push updates through to the application: the Live Query.  Instead of returning data, this query returns a token that subscribes to a result-set.  Whenever changes are made on those records, OrientDB pushes them to your application.

## Using Live Queries

Live Queries were introduced in version 2.1 of OrientDB and are not available on older versions.  Beginning in version 2.2, they are enabled by default.

To disable them, set the `query.live.support` property to `false`.

- [**Understanding Live Queries**](Live-Query-Intro.md)
- [**Comparison of Queries Methods**](Live-Query-Comparison.md)


### Supported interfaces

Currently, Live Queries are supported by the following interfaces:

- [**Java API**](Live-Query-Java.md), through the `OLiveResultListener` and `OLiveQuery` objects.
- [**OrientJS (Node.js)**](../orientjs/OrientJS.md), through the [`liveQuery()`](OrientJS-Live-Query.md) function.


### When to use Live Queries

You may find Live Queries particularly useful in the following scenarios:

- Where you need continuous, (that is, real-time), updates to multiple clients accessing different data subsets.

  In this use-case, polling is an expensive operation.  With thousands of clients executing continuous polling could crash any server.  At best it wastes significant resources, especially where updates only rarely occur.

- Where you have multiple data sources that insert or update data.

  When you have a single data source that populates the database, then you can intercept it and directly notify the clients of changes.  But, in most use-cases this doesn't happen.  
  
  More often you have multiple data sources, sometimes automatic (such as with applications), and sometimes manual (such as your database administrator performing maintenance), and you need these updates immediately sent through to the clients.

- Where you have a push-based/reactive infrastructure.

  When using message-driven infrastructure or with a reactive framework, traditional queries, which are synchronous and blocking, can create their own difficulties.  

  By providing push notifications for data changes, Live Queries allow you to work from same paradigm, developing applications in a more consistent way.
