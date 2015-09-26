# JMX

## Read Cache
JMX bean name: `com.orientechnologies.orient.core.storage.cache.local:type=O2QCacheMXBean`

It has following members:
- `usedMemory`, `usedMemoryInMB`, `usedMemoryInGB` which is amount of direct memory consumed by read cache in different units of measurements
- `cacheHits` is percent of cases when records will be downloaded not from disk but from read cache
- `clearCacheStatistics()` method may be called to clear cache hits statics so we always may start to gather cache hits statistic from any moment of time
- `amSize` ,  `a1OutSize`, `a1InSize` is the size of LRU queues are used in 2Q algorithm

## Write Cache
JMX bean name: `com.orientechnologies.orient.core.storage.cache.local:type=OWOWCacheMXBean,name=<storage name>,id=<storage id>` 

Write cache alike read cache is not JVM wide, it is storage wide, but one JVM may run several servers and each server may contain storage with the same name, that is why we need such complex name. 

JMX bean of write cache has following members:
- `writeCacheSize`, `writeCacheSizeInMB`, `writeCacheSizeInGB` provides size of data in different units which should be flushed to disk in background thread
- `exclusiveWriteCacheSize` , `exclusiveWriteCacheSizeInMB`, `exclusiveWriteCacheSizeInGB` provides size of data which should be flushed to disk but contained only in write cache

# More about memory model and data flow

At first when we read page we load it from disk and put it in read cache.
Then we change page and put it back to read cache and write cache,  but we do not copy page from read to write cache we merely send pointer to the same memory to write cache. Write cache flushes "dirty write page" in background thread. That is what property "writeCachSize" shows us amount of data in dirty pages which should be flushed. But there are very rare situations when page which is rarely used still is not flushed on disk and read cache has not enough memory to keep it. In such case this page is removed from read cache , but pointer to this page still exists in write cache, that is what property "exclusiveWriteCacheSize" shows us. Please not that this value is more than 0 only during extremely high load.  

The rest properties of write cache JMX bean are following:
- `lastFuzzyCheckpointDate`
- `lastAmountOfFlushedPages`
- `durationOfLastFlush`

