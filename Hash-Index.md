# Hash Index

Hash index allows to perform index read operations for 1 (one) I/O operation, and index write for 3 (three) I/O operations as maximum. Hash index algorithm is based on extendible hashing [Extendible Hashing](http://en.wikipedia.org/wiki/Extendible_hashing) algorithm. Hash index does not support range queries, but it's noticeable faster (about 2 times on 10M records) than [SB-Tree index](SB-Tree-index.md).

_NOTE: There is an issue about enhancement of hash index to avoid slowdown introduced by random I/O operations using LSM Tree approaches: [Issue #1757](https://github.com/orientechnologies/orientdb/issues/1757)._
