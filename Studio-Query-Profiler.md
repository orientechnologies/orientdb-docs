---
search:
   keywords: ['Studio', 'query', 'profiler', 'query profiler']
---

# Query Profiler

Starting from version 2.2, Studio Enterprise Edition includes a functionality called _Profiling_. To understand how Profiling works, please refer to the [Profiler](Profiler.md) page.

In the above section you can choose the server in order to investigate queries executed on it and manage the local cache.

NOTE: _This feature is available only in the [OrientDB Enterprise Edition](http://orientdb.com/orientdb-enterprise). If you are interested in a commercial license look at [OrientDB Subscription Packages](http://orientdb.com/support)_.


## Query
This panel shows all the queries executed on a specific server grouped by the command content. For each query the following information are reported:
- `Type`, as the query type
- `Command`, as the content of the query
- `Users`, as the users who executed the query
- `Entries`, as the number of times the query it was executed
- `Average`, as the average required time by the queries
- `Total`, as the total required time by all the queries
- `Max`, as the maximum required time
- `Min`, as the minimum required time
- `Last`, as the time required by the last query
- `Last execution`, as the timestamp of the last query execution


![Query](images/studio-queryprofiler-query.png)

## Command Cache
Through this panel you can manage the cache of the specific server and consult the cached results of queries by using the `VIEW RESULTS` button.
You can even filter the queries by the "Query" field and purge the whole cache by using the `PURGE CACHE` button.

![Command Cache](images/studio-queryprofiler-commandcache.png)
