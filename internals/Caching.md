---
search:
   keywords: ['internals', 'cache', 'caching']
---

# Caching

OrientDB has several caching mechanisms that act at different levels. Look at this picture:

![image](http://www.orientdb.org/images/caching.png)

- **Local cache** is one per database instance (and per thread in multi-thread environment)
- **[Storage](../Concepts.md#storage)**, it could cache depending on the implementation. This is the case for the **Local Storage** (disk-based) that caches file reads to reduce I/O requests
- **[Command Cache](../sql/Command-Cache.md)**


# How cache works?

## Local Mode (embedded database)

![image](http://www.orientdb.org/images/cache-flow.png)

When the client application asks for a record OrientDB checks:
- if a **transaction** has begun then it searches inside the transaction for changed records and returns it if found
- if the **Local cache** is enabled and contains the requested record then return it
- otherwise, at this point the record is not in cache, then asks for it to the **Storage** (disk, memory)

## Client-Server Mode (remote database)

![image](http://www.orientdb.org/images/cache_flow_client_server.png)

When the client application asks for a record OrientDB checks:
- if a **transaction** has begun then it searches inside the transaction for changed records and returns it if found
- if the **Local cache** is enabled and contains the requested record then return it
- otherwise, at this point the record is not in cache, then asks for it to the **Server** through a TCP/IP call
- in the server, if the **Local cache** is enabled and contains the requested record then return it
- otherwise, at this point the record is also not cached in the server, then asks for it to the **Storage** (disk, memory)

# Record cache

## Local cache

Local cache acts at database level. Each database instance has a Local cache enabled by default. This cache keeps the used records. Records will be removed from heap if two conditions will be satisfied:

1. There are no links to these records from outside of the database
1. The Java Virtual Machine doesn't have enough memory to allocate new data

## Empty Local cache

To remove all the records in Local cache you can invoke the <code>invalidate()</code> method:
```java
db.getLocalCache().invalidate();
```
