
# Multi-threading with OrientDB

OrientDB supports multi-threaded access to the database.  The `OrientDB` is thread safe, the `ODatabase*` and `OrientGraph*` instances are **not** thread-safe.  You must only use one of this instance per thread and only use each instance in one thread at a time.

The `ODocument`, `OrientVertex` and `OrientEdge` classes are also not thread-safe.  So, sharing them across threads can lead to unexpected errors that may prove difficult to recognize.

>For more information, see [Concurrency](../general/Concurrency.md).

|![](../images/warning.png)|Implicit usage of multiple database instances from the same thread is no longer allowed.  Any attempt to manage multiple instances in the same thread must explicitly call the `db.activateOnCurrentThread()` method against the database instance **before** you use it.|

- [Multi-threading with OrientDB](Java-Multi-Threading-Usage.md)
- [Multi Version Concurrency Control](Java-Multi-Threading-Concurrency.md)


## Basic Example Multi-threading

Example of multithread usage:

```java
OrientDB orientDB = new OrientDB("remote:localhost", OrientDBConfig.defaultConfig());

// Spawn two threads that do some job
new Thread(() ->{
   ODatabaseDocument database = orientDB.open("database", "admin", "admin");
   //... Job One
   database.close();
).start();

new Thread(() ->{
   ODatabaseDocument database = orientDB.open("database", "admin", "admin");
   //... Job two
   database.close();
}).start();


```

