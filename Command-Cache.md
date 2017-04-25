---
search:
   keywords: ['SQL', 'command cache']
---

# Command Cache

Starting in release 2.2, OrientDB supports caching of command results. Caching command results has been used by other DBMSs and has proven to improve dramatically the following use cases:
- database is mostly read than write
- there are a few heavy queries that return a small result set
- you have available RAM to use for caching results

By default, the command cache is disabled. To enable it, set `command.cache.enabled=true`. Look at the [Studio page about Command Cache](Studio-Query-Profiler.md#command-cache).

## Settings

There are some settings to tune the command cache. See the table below containing all the available settings.

|Parameter|Description|Type|Default value|
|---------|-----------|----|-------------|
|command.cache.enabled|Enable command cache|Boolean|false|
|command.cache.evictStrategy|Command cache strategy between: [INVALIDATE_ALL,PER_CLUSTER]|String.class|PER_CLUSTER|
|command.cache.minExecutionTime|Minimum execution time to consider caching result set|Integer.class|10|
|command.cache.maxResultsetSize|Maximum resultset time to consider caching result set|Integer|500|

## Eviction strategies

Using a cache that holds old data could be meaningless, unless you can accept eventual consistency. For this reason, the command cache supports 2 eviction strategies to keep the cache consistent:
- **INVALIDATE_ALL** to remove all the query results at every Create, Update, and Delete operation. This is faster than **PER_CLUSTER** if many writes occur.
- **PER_CLUSTER** to remove all the query results only related to the modified cluster. This operation is more expensive than **INVALIDATE_ALL**.

