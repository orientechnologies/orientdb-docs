# Troubleshooting

This page aims to link all the guides to Problems and Troubleshooting.

## Sub sections
- [Troubleshooting Java API](Troubleshooting-Java.md)

## Topics

### Why can't I see all the edges?

OrientDB, by default, manages edges as "lightweight" edges if they have no properties. This means that if an edge has no properties, it's not stored as physical record. But don't worry, your edge is still there but encoded in a separate data structure. For this reason if you execute a ```select from E```no edges or less edges than expected are returned. It's extremely rare the need to have the list of edges, but if this is your case you can disable this feature by issuing this command once (with a slow down and a bigger database size):

``` sql
ALTER DATABASE custom useLightweightEdges=false
```

### JVM crash on Solaris and other *NIX platforms.
The reason of this issue is massive usage of sun.misc.Unsafe which may have different contract than it is
implemented for Linux and Windows JDKs. To avoid this error please use following settings during server start:

```
java ... -Dmemory.useUnsafe=false and -Dstorage.compressionMethod=gzip ...
```

### Error occurred while locking memory: Unable to lock JVM memory. This can result in part of the JVM being swapped out, especially if mmapping of files enabled. Increase RLIMIT_MEMLOCK or run OrientDB server as root(ENOMEM)

Don't be scared about it: your OrientDB installation will work perfectly, just it could be slower with database larger than memory.

This lock is needed in case of you work on OS which uses aggressive swapping like Linux. If there is the case when amount of available RAM is not enough to cache all MMAP content OS can swap out rarely used parts of Java heap to the disk and when GC is started to collect garbage we will have performance degradation, to prevent such situation Java heap is locked into memory and prohibited to be flushed on the disk.
### com.orientechnologies.orient.core.exception.OStorageException: Error on reading record from file 'default.0.oda', position 2333, size 122,14Mb: the record size is bigger then the file itself (233,99Kb)

This usually happens because the database has been corrupted by a hw/sw crash or a hard kill of the process during the writing to disk. If this happens on index clusters just rebuild indexes, otherwise re-import a previously exported database.

### Class 'OUSER' or 'OROLE' was not found in current database
Look at: [Restore admin user](Security.md#restore-admin-user).

### User 'admin' was not found in current database
Look at: [Restore admin user](Security.md#restore-admin-user).

### WARNING: Connection re-acquired transparently after XXXms and Y retries: no errors will be thrown at application level

This means that probably default timeouts are too low and server side operation need more time to complete. Follow these  [MemoryLocker.lockMemory](MemoryLocker.lockMemory.md)Performance-Tuning#remote_connections.suggestions]].

### Could not find artifact com.orientechnologies:orientdb-core:jar:1.0-SNAPSHOT in orientechnologies-repository(http://www.orientechnologies.com/listing/m2)

Your maven configuration points to the old Orient Technologies repository: http://www.orientechnologies.com/listing/m2. Follow this configuration: [### Record id invalid -1:-2

This message is relative to a temporary [Concepts#recordidrecordid](Download.md#via_maven_repository).]] generated inside a transaction. For more information look at [Transactions](Transactions.md). This means that the record hasn't been correctly serialized.

### Brand new records are created with version major than 0

This happens in graphs. Think to this graph of records:

A -> B -> C -> A

When OrientDB starts to serialize records goes recursively from the root A. When A is encountered again to avoid loops it saves the record as empty just to get the RecordID to store into the record C. When the serialization stack ends the record A (that was the first of the stack) is updated because has been created as first but empty.

### Why it's so slow with index and massive insertion?

Try to enable automatic flush of index nodes. Via API:
```java
    OGlobalConfiguration.MVRBTREE_LAZY_UPDATES.setValue(-1);
```
or via configuration:
```java
java ... -Dmvrbtree.optimizeThreshold=-1 ...
```

### Error: com.orientechnologies.orient.core.db.record.ORecordLazySet cannot be cast to com.orientechnologies.orient.core.db.record.OIdentifiable

This happens if you've migrated a database created with an old version of OrientDB where indexes were managed in different way. Just drop and recreate the indexes.

### com.orientechnologies.common.concur.lock.OLockException: File '/tmp/databases/demo/default.0.oda' is locked by another process, maybe the database is in use by another process. Use the remote mode with a OrientDB server to allow multiple access to the same database

This is because the database is locked by another process is using it. To fix:
- check there's no a process is using OrientDB. Most of the times a OrientDB Server is running. Just shutdown it and retry
- set the [storage.keepOpen](http://code.google.com/p/orient/wiki/PerformanceTuning#Parameters) setting to false


### 012-04-20 11:29:56:132 SEVE Received unread response from /10.0.0.2:2434 for session=0, probably corrupted data from the network connection. Cleared dirty data in the buffer (330 bytes): [----7-c-o-m-.-o-r-i-e-n-t-e-c-h-n-o-l-o-g-i-e-s-.-c-o-m-m-o-n-.-c-o-n-c-u-r-.-l-o-c-k-.-O-L-o-c-k...] [OChannelBinaryClient

This is a message of an old version of OrientDB: upgrade it.

### Caused by: java.lang.NumberFormatException: For input string: "500Mb"
You're using different version of libraries. For example the client is using 1.3 and the server 1.4. Align the libraries to the same version (last is suggested). Or probably you've different versions of the same jars in the classpath.
