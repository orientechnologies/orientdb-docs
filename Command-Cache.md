# Command Cache

Starting from release 2.2, OrientDB supports caching of commands results. Caching command results has been used by other DBMSs and proven to drammatically improve the following use cases:
- database is mostly read than write
- there are a few heavy queries that result a small result set

## Eviction strategies

Using a cache that hold old data could be meaningless, unless you could accept eventually consistency. For this reason the command cache supports 2 eviction strategies:
- **INVALIDATE_ALL** to remove all the query results. This is faster than **PER_CLUSTER** if many writes occur.
- **PER_CLUSTER** to remove all the query results related only to the modified cluster


## DRAFT
