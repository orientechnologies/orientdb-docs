---
search:
   keywords: ['Java API', 'mutli-thread', 'multithread']
---

# Multi-threading with OrientDB

OrientDB supports multi-threaded access to the database, but only through one instance per thread.  That is, `ODatabase*` and `OrientGraph*` instances are **not** thread-safe.  You must only use one instance per thread and only use each instance in one thread at a time.

The `ODocument`, `OrientVertex` and `OrientEdge` classes are also not thread-safe.  So, sharing them across threads can lead to unexpected errors that may prove difficult to recognize.

>For more information, see [Concurrency](Concurrency.md).

|![](images/warning.png)| Beginning in version 2.1 of OrientDB, implicit usage of multiple database instances from the same thread is no longer allowed.  Any attempt to manage multiple instances in the same thread must explicitly call the `db.activateOnCurrentThread()` method against the database instance **before** you use it.|

- [Understanding Multi-threading](#understanding-multi-threadng)
- [Multi-threading with OrientDB](Java-Mutli-Threading-Usage.md)
- [Multi Version Concurrency Control](Java-Multi-Threading-Concurrency.md)


## Understanding Multi-threading

Multiple database instances point to the same storage through the same database URL.  In this case, Storage is thread-safe and orchestrates requests from different `ODatabase*` instances.

```
ODatabaseDocumentTx-1-----+
                          |
                          +-----> OStorage(url=plocal:/tmp/db)
                          |
ODatabaseDocumentTx-2-----+
```

The same goes for the Graph API,

```
OrientGraph-1------------+
                         |
                         +------> OStorage(url=plocal:/tmp/db)
                         |
OrientGraph-2------------+
```

### Shared Objects

Individual database instances share the following objects:
- Schema
- Index Manager
- Security

For concurrnet contexts these objects synchronize by storing the current database in the `ThreadLocal` variable.  Whenever you create, open or acquire a database connection the instance is automatically set to the current `ThreadLocal` space.  Meaning that, in normal usage, this operation remains hidden from the developer.

>OrientDB always resets the current database for all common operatings, such as load, save, and so on.
