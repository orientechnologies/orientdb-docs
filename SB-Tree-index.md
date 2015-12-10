<!-- proofread 2015-12-10 SAM -->

# SB-Tree Index Algorithm

This indexing algorithm provides a good mix of features, similar to the features available from other index types.  It is good for general use and is durable, transactional and supports range queries. There are four index types that utilize the SB-Tree index algorithm:

- `UNIQUE` Does not allow duplicate keys, fails when it encounters duplicates.
- `NOTUNIQUE` Does allow duplicate keys.
- `FULLTEXT` Indexes to any single word of text.
- `DICTIONARY` Does not allow duplicate keys, overwrites when it encounters duplicates.


> For more information on `FULLTEXT_HASH_INDEX`, see [FullText Index](FullTextIndex.md).

The SB-Tree index algorithm is based on the [B-Tree index](https://en.wikipedia.org/wiki/B-tree) algorithm.  It has been adapted with several optimizations, which relate to data insertion and range queries.  As is the case with all other tree-based indexes, SB-Tree index algorithm experiences `log(N)` complexity, but the base to this logarithm is about 500.

>**NOTE**: There is an issue in the replacement of indexes based on B-Tree with those based on COLA Tree to avoid slowdowns introduced by random I/O operations.  For more information see [Issue #1756](https://github.com/orientechnologies/orientdb/issues/1756).
