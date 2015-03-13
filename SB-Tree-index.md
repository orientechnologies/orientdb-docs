# SB-Tree index

This index is based on B-Tree index with several optimizations related to data insertion and range queries. As any other tree based indexes they have log(N) complexity, but base of this logarithm is about 500.

There is an issue about replacement of B-Tree based index by COLA Tree based index to avoid slowdown introduced by random I/O operations [Issue #1756](https://github.com/orientechnologies/orientdb/issues/1756).
