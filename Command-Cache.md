# Command Cache

Starting from release 2.2, OrientDB supports caching of commands results. Caching command results has been used by other DBMSs and proven to drammatically improve the following use cases:
- database is mostly read than write
- there are a few heavy queries that result a small result set
- you have available RAM to use or caching results

By default command cache is disabled. To enable it set `command.timeout=true`.

## Settings

There are some settings to tune the comman cache. Below the table containing all of them.

|Parameter|Description|Type|Default value|
|---------|-----------|----|-------------|
|command.cache.enabled|Enable command cache|Boolean|false|
|command.cache.evictStrategy|Command cache strategy between: [INVALIDATE_ALL,PER_CLUSTER]|String.class|PER_CLUSTER|
|command.cache.minExecutionTime|Minimum execution time to consider caching result set|Integer.class|10|
|command.cache.maxResultsetSize|Maximum resultset time to consider caching result set|Integer|500|

## Eviction strategies

Using a cache that hold old data could be meaningless, unless you could accept eventually consistency. For this reason the command cache supports 2 eviction strategies:
- **INVALIDATE_ALL** to remove all the query results at every Create, Update and Delete operation. This is faster than **PER_CLUSTER** if many writes occur.
- **PER_CLUSTER** to remove all the query results only related to the modified cluster. This operation is more expensive then **INVALIDATE_ALL**

