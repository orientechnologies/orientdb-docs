
# Auto Sharding Index Algorithm

(Since v2.2)

This indexing algorithm is based on the [DHT concept](https://en.wikipedia.org/wiki/Distributed_hash_table), where they keys are stored on different partition, based on the [Murmur3](https://en.wikipedia.org/wiki/MurmurHash) hash function.

Auto Sharding Index supports the following index types:
- `UNIQUE_HASH_INDEX` Does not allow duplicate keys, it fails when it encounters duplicates.
- `NOTUNIQUE_HASH_INDEX` Does allow duplicate keys.

Under the hood, this index creates multiple [Hash Indexes](Hash-Index.md), one per cluster. So if you have 8 clusters for the class "Employee", this index will create, at the beginning, 8 [Hash Indexes](Hash-Index.md).

Since this index is based on the [Hash Index](Hash-Index.md), it's able to perform index read operations in one I/O operation and write operations in a maximum of three I/O operations. The Hash Index algorithm is based on the [Extendible Hashing](http://en.wikipedia.org/wiki/Extendible_hashing) algorithm.  Despite not providing support for range queries, it is noticeably faster than [SB-Tree Index Algorithms](SB-Tree-index.md), (about twice as fast when querying through ten million records).

## Usage

Create an index by passing "AUTOSHARDING" as index engine:

```java
final OClass cls = db.createClass("Log");
cls.createProperty("key", OType.LONG);
cls.createIndex("idx_LogKey", OClass.INDEX_TYPE.UNIQUE.toString(),
    (OProgressListener) null, (ODocument) null, "AUTOSHARDING", new String[] { "key" });
```

## Performance

On multi-core hw, using this index instead of [Hash Index](Hash-Index.md) gives about +50% more throughput on insertion on a 8 cores machine.

## Distributed

The fully distributed version of this index will be supported in v3.0. In v2.2 each node has own copy of the index with all the partitions.

## Internals

This is the algorithm for the `put(key,value)`:

```
int partition = Murmur3_hash(key) % partitions;
getSubIndex(partition).put(key,value);
```

This is for the `value = get(key)`:
```
int partition = Murmur3_hash(key) % partitions;
return getSubIndex(partition).get(key);
```
