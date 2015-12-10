<!-- proofread 2015-12-10 SAM -->

# Hash Index Algorithm

This indexing algorithm provides a fast lookup and is very light on disk usage.  It is durable and transactional, but does not support range queries. It is similar to a HashMap, which makes it faster on punctual lookups and it consumes less resources than other index types. The Hash index algorithm supports four index types, which have been available since version 1.5.x:

- `UNIQUE_HASH_INDEX` Does not allow duplicate keys, it fails when it encounters duplicates.
- `NOTUNIQUE_HASH_INDEX` Does allow duplicate keys.
- `FULLTEXT_HASH_INDEX` Indexes to any single word.
- `DICTIONARY` Does not allow duplicate keys, it overwrites when it encounters duplicates.

> For more information on `FULLTEXT_HASH_INDEX`, see [FullText Index](FullTextIndex.md).

Hash indexes are able to perform index read operations in one I/O operation and write operations in a maximum of three I/O operations. The Hash Index algorithm is based on the [Extendible Hashing](http://en.wikipedia.org/wiki/Extendible_hashing) algorithm.  Despite not providing support for range queries, it is noticeably faster than [SB-Tree Index Algorithms](SB-Tree-index.md), (about twice as fast when querying through ten million records).

>**NOTE**:  There is an issue relating to the enhancement of Hash indexes to avoid slowdowns introduced by random I/O operations using LSM Tree approaches.  For more information, see [Issue #1757](https://github.com/orientechnologies/orientdb/issues/1757).
