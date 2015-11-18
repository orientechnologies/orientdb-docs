# Global Configuration

OrientDB can be configured in several ways. To know the current settings use the console with the [config command](Console-Command-Config.md).

## Change settings

### By command line
You can pass settings via command line when the JVM is launched. This is typically stored inside server.sh (or server.bat on Windows):
```
java -Dcache.size=10000 -Dstorage.keepOpen=true ...
```

### By server configuration

Put in the <code>&lt;properties&gt;</code> section of the file **orientdb-server-config.xml** (or orientdb-dserver-config.xml) the entries to configure. Example:
```xml
  ...
  <properties>
    <entry name="cache.size" value="10000" />
    <entry name="storage.keepOpen" value="true" />
  </properties>
  ...
```
### At run-time

```java
OGlobalConfiguration.MVRBTREE_NODE_PAGE_SIZE.setValue(2048);
```

## Dump the configuration
To dump the OrientDB configuration you can set a parameter at JVM launch:
```
java -Denvironment.dumpCfgAtStartup=true ...
```

Or via API at any time:

```java
OGlobalConfiguration.dumpConfiguration(System.out);
```

## Parameters ##

To know more look at the Java enumeration: <code>[OGlobalConfiguration.java](https://github.com/nuvolabase/orientdb/blob/master/core/src/main/java/com/orientechnologies/orient/core/config/OGlobalConfiguration.java)</code>.


----

### Environment


##### environment.dumpCfgAtStartup

Dumps the configuration during application startup..

```
Setting name...: environment.dumpCfgAtStartup
Default value..: false
Set at run-time: false
Hidden.........: false
```

##### environment.concurrent

Specifies if running in multi-thread environment. Setting this to false turns off the internal lock management..

```
Setting name...: environment.concurrent
Default value..: true
Set at run-time: false
Hidden.........: false
```

##### environment.allowJVMShutdown

Allows the shutdown of the JVM, if needed/requested..

```
Setting name...: environment.allowJVMShutdown
Default value..: true
Set at run-time: true
Hidden.........: false
```
----

### Script


##### script.pool.maxSize

Maximum number of instances in the pool of script engines..

```
Setting name...: script.pool.maxSize
Default value..: 20
Set at run-time: false
Hidden.........: false
```
----

### Memory


##### memory.useUnsafe

Indicates whether Unsafe will be used, if it is present..

```
Setting name...: memory.useUnsafe
Default value..: true
Set at run-time: false
Hidden.........: false
```

##### memory.directMemory.safeMode

Indicates whether to perform a range check before each direct memory update. It is true by default, but usually it can be safely set to false. It should only be to true after dramatic changes have been made in the storage structures..

```
Setting name...: memory.directMemory.safeMode
Default value..: true
Set at run-time: false
Hidden.........: false
```

##### memory.directMemory.trackMode

If 'track mode' is switched on, then the following steps are performed: 1. direct memory JMX bean is registered. 2. You may check amount of allocated direct memory as a property of the JMX bean. 3. If a memory leak is detected, then a JMX event will be fired. This mode causes a large overhead and should be used for testing purposes only..

```
Setting name...: memory.directMemory.trackMode
Default value..: false
Set at run-time: false
Hidden.........: false
```

##### memory.directMemory.onlyAlignedMemoryAccess

Some architectures do not allow unaligned memory access or may suffer from speed degradation. For such platforms, this flag should be set to true..

```
Setting name...: memory.directMemory.onlyAlignedMemoryAccess
Default value..: true
Set at run-time: false
Hidden.........: false
```
----

### Jvm


##### jvm.gc.delayForOptimize

Minimal amount of time (in seconds), since the last System.gc(), when called after tree optimization..

```
Setting name...: jvm.gc.delayForOptimize
Default value..: 600
Set at run-time: false
Hidden.........: false
```
----

### Storage


##### storage.diskCache.bufferSize

Size of disk buffer in megabytes..

```
Setting name...: storage.diskCache.bufferSize
Default value..: 4096
Set at run-time: false
Hidden.........: false
```

##### storage.diskCache.writeCachePart

Percentage of disk cache, which is used as write cache.

```
Setting name...: storage.diskCache.writeCachePart
Default value..: 15
Set at run-time: false
Hidden.........: false
```

##### storage.diskCache.writeCachePageTTL

Max time until a page will be flushed from write cache (in seconds)..

```
Setting name...: storage.diskCache.writeCachePageTTL
Default value..: 86400
Set at run-time: false
Hidden.........: false
```

##### storage.diskCache.writeCachePageFlushInterval

Interval between flushing of pages from write cache (in ms)..

```
Setting name...: storage.diskCache.writeCachePageFlushInterval
Default value..: 25
Set at run-time: false
Hidden.........: false
```

##### storage.diskCache.writeCacheFlushInactivityInterval

Interval between 2 writes to the disk cache, if writes are done with an interval more than provided, all files will be fsynced before the next write, which allows a data restore after a server crash (in ms)..

```
Setting name...: storage.diskCache.writeCacheFlushInactivityInterval
Default value..: 60000
Set at run-time: false
Hidden.........: false
```

##### storage.diskCache.writeCacheFlushLockTimeout

Maximum amount of time the write cache will wait before a page flushes (in ms, -1 to disable).

```
Setting name...: storage.diskCache.writeCacheFlushLockTimeout
Default value..: -1
Set at run-time: false
Hidden.........: false
```

##### storage.diskCache.diskFreeSpaceLimit

Minimum amount of space on disk, which, when exceeded, will cause the database to switch to read-only mode (in megabytes)..

```
Setting name...: storage.diskCache.diskFreeSpaceLimit
Default value..: 100
Set at run-time: false
Hidden.........: false
```

##### storage.diskCache.diskFreeSpaceCheckInterval

The interval (in seconds), after which the storage periodically checks whether the amount of free disk space is enough to work in write mode.

```
Setting name...: storage.diskCache.diskFreeSpaceCheckInterval
Default value..: 5
Set at run-time: false
Hidden.........: false
```

##### storage.configuration.syncOnUpdate

Indicates a force sync should be performed for each update on the storage configuration..

```
Setting name...: storage.configuration.syncOnUpdate
Default value..: true
Set at run-time: false
Hidden.........: false
```

##### storage.compressionMethod

Record compression method used in storage. Possible values : gzip, nothing, snappy, snappy-native. Default is 'nothing' that means no compression..

```
Setting name...: storage.compressionMethod
Default value..: nothing
Set at run-time: false
Hidden.........: false
```

##### storage.encryptionMethod

Record encryption method used in storage. Possible values : 'aes' and 'des'. Default is 'nothing' for no encryption..

```
Setting name...: storage.encryptionMethod
Default value..: nothing
Set at run-time: false
Hidden.........: false
```

##### storage.encryptionKey

Contains the storage encryption key. This setting is hidden..

```
Setting name...: storage.encryptionKey
Default value..: null
Set at run-time: false
Hidden.........: true
```

##### storage.makeFullCheckpointAfterCreate

Indicates whether a full checkpoint should be performed, if storage was created..

```
Setting name...: storage.makeFullCheckpointAfterCreate
Default value..: true
Set at run-time: false
Hidden.........: false
```

##### storage.makeFullCheckpointAfterOpen

Indicates whether a full checkpoint should be performed, if storage was opened. It is needed so fuzzy checkpoints can work properly..

```
Setting name...: storage.makeFullCheckpointAfterOpen
Default value..: true
Set at run-time: false
Hidden.........: false
```

##### storage.makeFullCheckpointAfterClusterCreate

Indicates whether a full checkpoint should be performed, if storage was opened.

```
Setting name...: storage.makeFullCheckpointAfterClusterCreate
Default value..: true
Set at run-time: false
Hidden.........: false
```

##### storage.useWAL

Whether WAL should be used in paginated storage..

```
Setting name...: storage.useWAL
Default value..: true
Set at run-time: false
Hidden.........: false
```

##### storage.wal.syncOnPageFlush

Indicates whether a force sync should be performed during WAL page flush..

```
Setting name...: storage.wal.syncOnPageFlush
Default value..: true
Set at run-time: false
Hidden.........: false
```

##### storage.wal.cacheSize

Maximum size of WAL cache (in amount of WAL pages, each page is 64k) If set to 0, caching will be disabled..

```
Setting name...: storage.wal.cacheSize
Default value..: 3000
Set at run-time: false
Hidden.........: false
```

##### storage.wal.maxSegmentSize

Maximum size of single WAL segment (in megabytes)..

```
Setting name...: storage.wal.maxSegmentSize
Default value..: 128
Set at run-time: false
Hidden.........: false
```

##### storage.wal.maxSize

Maximum size of WAL on disk (in megabytes)..

```
Setting name...: storage.wal.maxSize
Default value..: 4096
Set at run-time: false
Hidden.........: false
```

##### storage.wal.commitTimeout

Maximum interval between WAL commits (in ms.).

```
Setting name...: storage.wal.commitTimeout
Default value..: 1000
Set at run-time: false
Hidden.........: false
```

##### storage.wal.shutdownTimeout

Maximum wait interval between events, when the background flush threadreceives a shutdown command and when the background flush will be stopped (in ms.).

```
Setting name...: storage.wal.shutdownTimeout
Default value..: 10000
Set at run-time: false
Hidden.........: false
```

##### storage.wal.fuzzyCheckpointInterval

Interval between fuzzy checkpoints (in seconds).

```
Setting name...: storage.wal.fuzzyCheckpointInterval
Default value..: 300
Set at run-time: false
Hidden.........: false
```

##### storage.wal.reportAfterOperationsDuringRestore

Amount of processed log operations, after which status of data restore procedure will be printed (0 or a negative value, disables the logging)..

```
Setting name...: storage.wal.reportAfterOperationsDuringRestore
Default value..: 10000
Set at run-time: false
Hidden.........: false
```

##### storage.wal.restore.batchSize

Amount of WAL records, which are read at once in a single batch during a restore procedure..

```
Setting name...: storage.wal.restore.batchSize
Default value..: 1000
Set at run-time: false
Hidden.........: false
```

##### storage.wal.readCacheSize

Size of WAL read cache in amount of pages..

```
Setting name...: storage.wal.readCacheSize
Default value..: 1000
Set at run-time: false
Hidden.........: false
```

##### storage.wal.fuzzyCheckpointShutdownWait

The amount of time the DB should wait until it shuts down (in seconds)..

```
Setting name...: storage.wal.fuzzyCheckpointShutdownWait
Default value..: 600
Set at run-time: false
Hidden.........: false
```

##### storage.wal.fullCheckpointShutdownTimeout

The amount of time the DB will wait, until a checkpoint is finished, during a DB shutdown (in seconds)..

```
Setting name...: storage.wal.fullCheckpointShutdownTimeout
Default value..: 600
Set at run-time: false
Hidden.........: false
```

##### storage.wal.path

Path to the WAL file on the disk. By default, it is placed in the DB directory, but it is highly recommended to use a separate disk to store log operations..

```
Setting name...: storage.wal.path
Default value..: null
Set at run-time: false
Hidden.........: false
```

##### storage.diskCache.pageSize

Size of page of disk buffer (in kilobytes). !!! NEVER CHANGE THIS VALUE !!!.

```
Setting name...: storage.diskCache.pageSize
Default value..: 64
Set at run-time: false
Hidden.........: false
```

##### storage.lowestFreeListBound

The least amount of free space (in kb) in a page, which is tracked in paginated storage..

```
Setting name...: storage.lowestFreeListBound
Default value..: 16
Set at run-time: false
Hidden.........: false
```

##### storage.lockTimeout

Maximum amount of time (in ms) to lock the storage..

```
Setting name...: storage.lockTimeout
Default value..: 0
Set at run-time: false
Hidden.........: false
```

##### storage.record.lockTimeout

Maximum of time (in ms) to lock a shared record..

```
Setting name...: storage.record.lockTimeout
Default value..: 2000
Set at run-time: false
Hidden.........: false
```

##### storage.useTombstones

When a record is deleted, the space in the cluster will not be freed, but rather tombstoned..

```
Setting name...: storage.useTombstones
Default value..: false
Set at run-time: false
Hidden.........: false
```

##### storage.cluster.usecrc32

Indicates whether crc32 should be used for each record to check record integrity..

```
Setting name...: storage.cluster.usecrc32
Default value..: false
Set at run-time: false
Hidden.........: false
```

##### storage.keepOpen

Deprecated.

```
Setting name...: storage.keepOpen
Default value..: true
Set at run-time: false
Hidden.........: false
```
----

### Record


##### record.downsizing.enabled

On updates, if the record size is lower than before, this reduces the space taken accordingly. If enabled this could increase defragmentation, but it reduces the used disk space..

```
Setting name...: record.downsizing.enabled
Default value..: true
Set at run-time: false
Hidden.........: false
```
----

### Object


##### object.saveOnlyDirty

Object Database only! It saves objects bound to dirty records..

```
Setting name...: object.saveOnlyDirty
Default value..: false
Set at run-time: true
Hidden.........: false
```
----

### Db


##### db.pool.min

Default database pool minimum size..

```
Setting name...: db.pool.min
Default value..: 1
Set at run-time: false
Hidden.........: false
```

##### db.pool.max

Default database pool maximum size..

```
Setting name...: db.pool.max
Default value..: 100
Set at run-time: false
Hidden.........: false
```

##### db.pool.idleTimeout

Timeout for checking for free databases in the pool..

```
Setting name...: db.pool.idleTimeout
Default value..: 0
Set at run-time: false
Hidden.........: false
```

##### db.pool.idleCheckDelay

Delay time on checking for idle databases..

```
Setting name...: db.pool.idleCheckDelay
Default value..: 0
Set at run-time: false
Hidden.........: false
```

##### db.mvcc.throwfast

Use fast-thrown exceptions for MVCC OConcurrentModificationExceptions. No context information will be available. Set to true, when these exceptions are thrown, but the details are not necessary..

```
Setting name...: db.mvcc.throwfast
Default value..: false
Set at run-time: true
Hidden.........: false
```

##### db.validation

Enables or disables validation of records..

```
Setting name...: db.validation
Default value..: true
Set at run-time: true
Hidden.........: false
```

##### db.makeFullCheckpointOnIndexChange

When index metadata is changed, a full checkpoint is performed..

```
Setting name...: db.makeFullCheckpointOnIndexChange
Default value..: true
Set at run-time: true
Hidden.........: false
```

##### db.makeFullCheckpointOnSchemaChange

When index schema is changed, a full checkpoint is performed..

```
Setting name...: db.makeFullCheckpointOnSchemaChange
Default value..: true
Set at run-time: true
Hidden.........: false
```

##### db.document.serializer

The default record serializer used by the document database..

```
Setting name...: db.document.serializer
Default value..: ORecordSerializerBinary
Set at run-time: false
Hidden.........: false
```

##### db.mvcc

Deprecated, MVCC cannot be disabled anymore.

```
Setting name...: db.mvcc
Default value..: true
Set at run-time: false
Hidden.........: false
```

##### db.use.distributedVersion

Deprecated, distributed version is not used anymore.

```
Setting name...: db.use.distributedVersion
Default value..: false
Set at run-time: false
Hidden.........: false
```
----

### NonTX


##### nonTX.recordUpdate.synch

Executes a sync against the file-system for every record operation. This slows down record updates, but guarantees reliability on unreliable drives..

```
Setting name...: nonTX.recordUpdate.synch
Default value..: false
Set at run-time: false
Hidden.........: false
```

##### nonTX.clusters.sync.immediately

List of clusters to sync immediately after update (separated by commas). Can be useful for a manual index..

```
Setting name...: nonTX.clusters.sync.immediately
Default value..: manindex
Set at run-time: false
Hidden.........: false
```
----

### Tx


##### tx.trackAtomicOperations

This setting is used only for debug purposes. It creates a stack trace of methods, when an atomic operation is started..

```
Setting name...: tx.trackAtomicOperations
Default value..: false
Set at run-time: false
Hidden.........: false
```

##### tx.commit.synch

Synchronizes the storage after transaction commit.

```
Setting name...: tx.commit.synch
Default value..: false
Set at run-time: false
Hidden.........: false
```

##### tx.autoRetry

Maximum number of automatic retry if some resource has been locked in the middle of the transaction (Timeout exception).

```
Setting name...: tx.autoRetry
Default value..: 1
Set at run-time: false
Hidden.........: false
```

##### tx.log.fileType

File type to handle transaction logs: mmap or classic.

```
Setting name...: tx.log.fileType
Default value..: classic
Set at run-time: false
Hidden.........: false
```

##### tx.log.synch

Executes a synch against the file-system at every log entry. This slows down transactions but guarantee transaction reliability on unreliable drives.

```
Setting name...: tx.log.synch
Default value..: false
Set at run-time: false
Hidden.........: false
```

##### tx.useLog

Transactions use log file to store temporary data to be rolled back in case of crash.

```
Setting name...: tx.useLog
Default value..: true
Set at run-time: false
Hidden.........: false
```
----

### Index


##### index.embeddedToSbtreeBonsaiThreshold

Amount of values, after which the index implementation will use an sbtree as a values container. Set to -1, to disable and force using an sbtree..

```
Setting name...: index.embeddedToSbtreeBonsaiThreshold
Default value..: 40
Set at run-time: true
Hidden.........: false
```

##### index.sbtreeBonsaiToEmbeddedThreshold

Amount of values, after which index implementation will use an embedded values container (disabled by default).

```
Setting name...: index.sbtreeBonsaiToEmbeddedThreshold
Default value..: -1
Set at run-time: true
Hidden.........: false
```

##### index.auto.synchronousAutoRebuild

Synchronous execution of auto rebuilding of indexes, in case of a DB crash.

```
Setting name...: index.auto.synchronousAutoRebuild
Default value..: true
Set at run-time: false
Hidden.........: false
```

##### index.auto.lazyUpdates

Configure the TreeMaps for automatic indexes, as buffered or not. -1 means buffered until tx.commit() or db.close() are called..

```
Setting name...: index.auto.lazyUpdates
Default value..: 10000
Set at run-time: false
Hidden.........: false
```

##### index.flushAfterCreate

Flush storage buffer after index creation..

```
Setting name...: index.flushAfterCreate
Default value..: true
Set at run-time: false
Hidden.........: false
```

##### index.manual.lazyUpdates

Configure the TreeMaps for manual indexes as buffered or not. -1 means buffered until tx.commit() or db.close() are called.

```
Setting name...: index.manual.lazyUpdates
Default value..: 1
Set at run-time: false
Hidden.........: false
```

##### index.durableInNonTxMode

Indicates whether index implementation for plocal storage will be durable in non-Tx mode (true by default)..

```
Setting name...: index.durableInNonTxMode
Default value..: true
Set at run-time: false
Hidden.........: false
```

##### index.txMode

Indicates the index durability level in TX mode. Can be ROLLBACK_ONLY or FULL (ROLLBACK_ONLY by default)..

```
Setting name...: index.txMode
Default value..: FULL
Set at run-time: false
Hidden.........: false
```

##### index.cursor.prefetchSize

Default prefetch size of index cursor..

```
Setting name...: index.cursor.prefetchSize
Default value..: 500000
Set at run-time: false
Hidden.........: false
```

##### index.auto.rebuildAfterNotSoftClose

Auto rebuild all automatic indexes after upon database open when wasn't closed properly.

```
Setting name...: index.auto.rebuildAfterNotSoftClose
Default value..: true
Set at run-time: false
Hidden.........: false
```
----

### HashTable


##### hashTable.slitBucketsBuffer.length

Length of buffer (in pages), where buckets that were split, but not flushed to the disk, are kept. This buffer is used to minimize random IO overhead..

```
Setting name...: hashTable.slitBucketsBuffer.length
Default value..: 1500
Set at run-time: false
Hidden.........: false
```
----

### Sbtree


##### sbtree.maxDepth

Maximum depth of sbtree, which will be traversed during key look up until it will be treated as broken (64 by default).

```
Setting name...: sbtree.maxDepth
Default value..: 64
Set at run-time: false
Hidden.........: false
```

##### sbtree.maxKeySize

Maximum size of a key, which can be put in the SBTree in bytes (10240 by default).

```
Setting name...: sbtree.maxKeySize
Default value..: 10240
Set at run-time: false
Hidden.........: false
```

##### sbtree.maxEmbeddedValueSize

Maximum size of value which can be put in an SBTree without creation link to a standalone page in bytes (40960 by default).

```
Setting name...: sbtree.maxEmbeddedValueSize
Default value..: 40960
Set at run-time: false
Hidden.........: false
```
----

### Sbtreebonsai


##### sbtreebonsai.bucketSize

Size of bucket in OSBTreeBonsai (in kB). Contract: bucketSize < storagePageSize, storagePageSize % bucketSize == 0..

```
Setting name...: sbtreebonsai.bucketSize
Default value..: 2
Set at run-time: false
Hidden.........: false
```

##### sbtreebonsai.linkBagCache.size

Amount of LINKBAG collections to be cached, to avoid constant reloading of data..

```
Setting name...: sbtreebonsai.linkBagCache.size
Default value..: 100000
Set at run-time: false
Hidden.........: false
```

##### sbtreebonsai.linkBagCache.evictionSize

The number of cached LINKBAG collections, which will be removed, when the cache limit is reached..

```
Setting name...: sbtreebonsai.linkBagCache.evictionSize
Default value..: 1000
Set at run-time: false
Hidden.........: false
```

##### sbtreebonsai.freeSpaceReuseTrigger

How much free space should be in an sbtreebonsai file, before it will be reused during the next allocation..

```
Setting name...: sbtreebonsai.freeSpaceReuseTrigger
Default value..: 0.5
Set at run-time: false
Hidden.........: false
```
----

### RidBag


##### ridBag.embeddedDefaultSize

Size of embedded RidBag array, when created (empty).

```
Setting name...: ridBag.embeddedDefaultSize
Default value..: 4
Set at run-time: false
Hidden.........: false
```

##### ridBag.embeddedToSbtreeBonsaiThreshold

Amount of values after which a LINKBAG implementation will use sbtree as values container. Set to -1 to always use an sbtree..

```
Setting name...: ridBag.embeddedToSbtreeBonsaiThreshold
Default value..: 40
Set at run-time: true
Hidden.........: false
```

##### ridBag.sbtreeBonsaiToEmbeddedToThreshold

Amount of values, after which a LINKBAG implementation will use an embedded values container (disabled by default)..

```
Setting name...: ridBag.sbtreeBonsaiToEmbeddedToThreshold
Default value..: -1
Set at run-time: true
Hidden.........: false
```
----

### Collections


##### collections.preferSBTreeSet

This configuration setting is experimental..

```
Setting name...: collections.preferSBTreeSet
Default value..: false
Set at run-time: false
Hidden.........: false
```
----

### File


##### file.trackFileClose

Log all the cases when files are closed. This is needed only for internal debugging purposes..

```
Setting name...: file.trackFileClose
Default value..: false
Set at run-time: false
Hidden.........: false
```

##### file.lock

Locks files when used. Default is true.

```
Setting name...: file.lock
Default value..: true
Set at run-time: false
Hidden.........: false
```

##### file.deleteDelay

Delay time (in ms) to wait for another attempt to delete a locked file..

```
Setting name...: file.deleteDelay
Default value..: 10
Set at run-time: false
Hidden.........: false
```

##### file.deleteRetry

Number of retries to delete a locked file..

```
Setting name...: file.deleteRetry
Default value..: 50
Set at run-time: false
Hidden.........: false
```
----

### Jna


##### jna.disable.system.library

This property disables using JNA, should it be installed on your system. (Default true) To use JNA bundled with database..

```
Setting name...: jna.disable.system.library
Default value..: true
Set at run-time: false
Hidden.........: false
```
----

### Security


##### security.userPasswordSaltIterations

Number of iterations to generate the salt or user password. Changing this setting does not affect stored passwords..

```
Setting name...: security.userPasswordSaltIterations
Default value..: 65536
Set at run-time: false
Hidden.........: false
```

##### security.userPasswordSaltCacheSize

Cache size of hashed salt passwords. The cache works as LRU. Use 0 to disable the cache..

```
Setting name...: security.userPasswordSaltCacheSize
Default value..: 500
Set at run-time: false
Hidden.........: false
```
----

### Network


##### network.maxConcurrentSessions

Maximum number of concurrent sessions..

```
Setting name...: network.maxConcurrentSessions
Default value..: 1000
Set at run-time: true
Hidden.........: false
```

##### network.socketBufferSize

TCP/IP Socket buffer size..

```
Setting name...: network.socketBufferSize
Default value..: 32768
Set at run-time: true
Hidden.........: false
```

##### network.lockTimeout

Timeout (in ms) to acquire a lock against a channel..

```
Setting name...: network.lockTimeout
Default value..: 15000
Set at run-time: true
Hidden.........: false
```

##### network.socketTimeout

TCP/IP Socket timeout (in ms)..

```
Setting name...: network.socketTimeout
Default value..: 15000
Set at run-time: true
Hidden.........: false
```

##### network.requestTimeout

Request completion timeout (in ms)..

```
Setting name...: network.requestTimeout
Default value..: 3600000
Set at run-time: true
Hidden.........: false
```

##### network.retry

Number of attempts to connect to the server on failure..

```
Setting name...: network.retry
Default value..: 5
Set at run-time: true
Hidden.........: false
```

##### network.retryDelay

The time (in ms) the client must wait, before reconnecting to the server on failure..

```
Setting name...: network.retryDelay
Default value..: 500
Set at run-time: true
Hidden.........: false
```

##### network.binary.loadBalancing.enabled

Asks for DNS TXT record, to determine if load balancing is supported..

```
Setting name...: network.binary.loadBalancing.enabled
Default value..: false
Set at run-time: true
Hidden.........: false
```

##### network.binary.loadBalancing.timeout

Maximum time (in ms) to wait for the answer from DNS about the TXT record for load balancing..

```
Setting name...: network.binary.loadBalancing.timeout
Default value..: 2000
Set at run-time: true
Hidden.........: false
```

##### network.binary.maxLength

TCP/IP max content length (in bytes) of BINARY requests..

```
Setting name...: network.binary.maxLength
Default value..: 32736
Set at run-time: true
Hidden.........: false
```

##### network.binary.readResponse.maxTimes

Maximum attempts, until a response can be read. Otherwise, the response will be dropped from the channel..

```
Setting name...: network.binary.readResponse.maxTimes
Default value..: 20
Set at run-time: true
Hidden.........: false
```

##### network.binary.debug

Debug mode: print all data incoming on the binary channel..

```
Setting name...: network.binary.debug
Default value..: false
Set at run-time: true
Hidden.........: false
```

##### network.http.maxLength

TCP/IP max content length (in bytes) for HTTP requests..

```
Setting name...: network.http.maxLength
Default value..: 1000000
Set at run-time: true
Hidden.........: false
```

##### network.http.charset

Http response charset.

```
Setting name...: network.http.charset
Default value..: utf-8
Set at run-time: true
Hidden.........: false
```

##### network.http.jsonResponseError

Http response error in json..

```
Setting name...: network.http.jsonResponseError
Default value..: true
Set at run-time: true
Hidden.........: false
```

##### network.http.jsonp

Enable the usage of JSONP, if requested by the client. The parameter name to use is 'callback'..

```
Setting name...: network.http.jsonp
Default value..: false
Set at run-time: true
Hidden.........: false
```

##### network.http.sessionExpireTimeout

Timeout, after which an http session is considered to have expired (in seconds)..

```
Setting name...: network.http.sessionExpireTimeout
Default value..: 300
Set at run-time: false
Hidden.........: false
```

##### network.http.useToken

Enable Token based sessions for http..

```
Setting name...: network.http.useToken
Default value..: false
Set at run-time: false
Hidden.........: false
```

##### network.token.secretyKey

Network token sercret key..

```
Setting name...: network.token.secretyKey
Default value..: 
Set at run-time: false
Hidden.........: false
```

##### network.token.encriptionAlgorithm

Network token algorithm..

```
Setting name...: network.token.encriptionAlgorithm
Default value..: HmacSHA256
Set at run-time: false
Hidden.........: false
```

##### network.token.expireTimeout

Timeout, after which a binary session is considered to have expired (in minutes)..

```
Setting name...: network.token.expireTimeout
Default value..: 60
Set at run-time: false
Hidden.........: false
```
----

### Profiler


##### profiler.enabled

Enables the recording of statistics and counters..

```
Setting name...: profiler.enabled
Default value..: false
Set at run-time: true
Hidden.........: false
```

##### profiler.config

Configures the profiler as <seconds-for-snapshot>,<archive-snapshot-size>,<summary-size>.

```
Setting name...: profiler.config
Default value..: null
Set at run-time: true
Hidden.........: false
```

##### profiler.autoDump.interval

Dumps the profiler values at regular intervals (in seconds)..

```
Setting name...: profiler.autoDump.interval
Default value..: 0
Set at run-time: true
Hidden.........: false
```
----

### Log


##### log.console.level

Console logging level..

```
Setting name...: log.console.level
Default value..: info
Set at run-time: true
Hidden.........: false
```

##### log.file.level

File logging level..

```
Setting name...: log.file.level
Default value..: fine
Set at run-time: true
Hidden.........: false
```
----

### Cache


##### cache.local.impl

Local Record cache implementation..

```
Setting name...: cache.local.impl
Default value..: com.orientechnologies.orient.core.cache.ORecordCacheWeakRefs
Set at run-time: false
Hidden.........: false
```

##### cache.local.enabled

Deprecated, Level1 cache cannot be disabled anymore.

```
Setting name...: cache.local.enabled
Default value..: true
Set at run-time: false
Hidden.........: false
```
----

### Command


##### command.timeout

Default timeout for commands (in ms)..

```
Setting name...: command.timeout
Default value..: 0
Set at run-time: true
Hidden.........: false
```

##### command.cache.enabled

Enable command cache..

```
Setting name...: command.cache.enabled
Default value..: false
Set at run-time: false
Hidden.........: false
```

##### command.cache.evictStrategy

Command cache strategy between: [INVALIDATE_ALL,PER_CLUSTER].

```
Setting name...: command.cache.evictStrategy
Default value..: PER_CLUSTER
Set at run-time: false
Hidden.........: false
```

##### command.cache.minExecutionTime

Minimum execution time to consider caching the result set..

```
Setting name...: command.cache.minExecutionTime
Default value..: 10
Set at run-time: false
Hidden.........: false
```

##### command.cache.maxResultsetSize

Maximum resultset time to consider caching result set..

```
Setting name...: command.cache.maxResultsetSize
Default value..: 500
Set at run-time: false
Hidden.........: false
```
----

### Query


##### query.parallelAuto

Auto enable parallel query, if requirements are met..

```
Setting name...: query.parallelAuto
Default value..: true
Set at run-time: false
Hidden.........: false
```

##### query.parallelMinimumRecords

Minimum number of records to activate parallel query automatically..

```
Setting name...: query.parallelMinimumRecords
Default value..: 300000
Set at run-time: false
Hidden.........: false
```

##### query.parallelResultQueueSize

Size of the queue that holds results on parallel execution. The queue is blocking, so in case the queue is full, the query threads will be in a wait state..

```
Setting name...: query.parallelResultQueueSize
Default value..: 20000
Set at run-time: false
Hidden.........: false
```

##### query.scanPrefetchPages

Pages to prefetch during scan. Setting this value higher makes scans faster, because it reduces the number of I/O operations, though it consumes more memory. (Use 0 to disable).

```
Setting name...: query.scanPrefetchPages
Default value..: 20
Set at run-time: false
Hidden.........: false
```

##### query.scanBatchSize

Scan clusters in blocks of records. This setting reduces the lock time on the cluster during scans. A high value mean a faster execution, but also a lower concurrency level. Set to 0 to disable batch scanning. Disabling batch scanning is suggested for read-only databases only.

```
Setting name...: query.scanBatchSize
Default value..: 100000
Set at run-time: false
Hidden.........: false
```

##### query.scanThresholdTip

If the total number of records scanned in a query exceeds this setting, then a warning is given. (Use 0 to disable).

```
Setting name...: query.scanThresholdTip
Default value..: 50000
Set at run-time: false
Hidden.........: false
```

##### query.limitThresholdTip

If the total number of returned records exceeds this value, then a warning is given. (Use 0 to disable).

```
Setting name...: query.limitThresholdTip
Default value..: 10000
Set at run-time: false
Hidden.........: false
```
----

### Statement


##### statement.cacheSize

Number of parsed SQL statements kept in cache..

```
Setting name...: statement.cacheSize
Default value..: 100
Set at run-time: false
Hidden.........: false
```
----

### Client


##### client.channel.maxPool

Maximum size of pool of network channels between client and server. A channel is a TCP/IP connection..

```
Setting name...: client.channel.maxPool
Default value..: 100
Set at run-time: false
Hidden.........: false
```

##### client.connectionPool.waitTimeout

Maximum time, where the client should wait for a connection from the pool, when all connections busy..

```
Setting name...: client.connectionPool.waitTimeout
Default value..: 5000
Set at run-time: true
Hidden.........: false
```

##### client.channel.dbReleaseWaitTimeout

Delay (in ms), after which a data modification command will be resent, if the DB was frozen..

```
Setting name...: client.channel.dbReleaseWaitTimeout
Default value..: 10000
Set at run-time: true
Hidden.........: false
```

##### client.ssl.enabled

Use SSL for client connections..

```
Setting name...: client.ssl.enabled
Default value..: false
Set at run-time: false
Hidden.........: false
```

##### client.ssl.keyStore

Use SSL for client connections..

```
Setting name...: client.ssl.keyStore
Default value..: null
Set at run-time: false
Hidden.........: false
```

##### client.ssl.keyStorePass

Use SSL for client connections..

```
Setting name...: client.ssl.keyStorePass
Default value..: null
Set at run-time: false
Hidden.........: false
```

##### client.ssl.trustStore

Use SSL for client connections..

```
Setting name...: client.ssl.trustStore
Default value..: null
Set at run-time: false
Hidden.........: false
```

##### client.ssl.trustStorePass

Use SSL for client connections..

```
Setting name...: client.ssl.trustStorePass
Default value..: null
Set at run-time: false
Hidden.........: false
```

##### client.session.tokenBased

Request a token based session to the server..

```
Setting name...: client.session.tokenBased
Default value..: true
Set at run-time: false
Hidden.........: false
```

##### client.channel.minPool

Minimum pool size.

```
Setting name...: client.channel.minPool
Default value..: 1
Set at run-time: false
Hidden.........: false
```
----

### Server


##### server.openAllDatabasesAtStartup

If true, the server opens all the available databases at startup. Available since 2.2.

```
Setting name...: server.openAllDatabasesAtStartup
Default value..: false
Set at run-time: false
Hidden.........: false
```

##### server.channel.cleanDelay

Time in ms of delay to check pending closed connections..

```
Setting name...: server.channel.cleanDelay
Default value..: 5000
Set at run-time: false
Hidden.........: false
```

##### server.cache.staticFile

Cache static resources upon loading..

```
Setting name...: server.cache.staticFile
Default value..: false
Set at run-time: false
Hidden.........: false
```

##### server.log.dumpClientExceptionLevel

Logs client exceptions. Use any level supported by Java java.util.logging.Level class: OFF, FINE, CONFIG, INFO, WARNING, SEVERE.

```
Setting name...: server.log.dumpClientExceptionLevel
Default value..: FINE
Set at run-time: false
Hidden.........: false
```

##### server.log.dumpClientExceptionFullStackTrace

Dumps the full stack trace of the exception sent to the client.

```
Setting name...: server.log.dumpClientExceptionFullStackTrace
Default value..: false
Set at run-time: true
Hidden.........: false
```
----

### Distributed


##### distributed.crudTaskTimeout

Maximum timeout (in ms) to wait for CRUD remote tasks..

```
Setting name...: distributed.crudTaskTimeout
Default value..: 3000
Set at run-time: true
Hidden.........: false
```

##### distributed.commandTaskTimeout

Maximum timeout (in ms) to wait for Command remote tasks..

```
Setting name...: distributed.commandTaskTimeout
Default value..: 10000
Set at run-time: true
Hidden.........: false
```

##### distributed.commandLongTaskTimeout

Maximum timeout (in ms) to wait for Long-running remote tasks..

```
Setting name...: distributed.commandLongTaskTimeout
Default value..: 86400000
Set at run-time: true
Hidden.........: false
```

##### distributed.deployDbTaskTimeout

Maximum timeout (in ms) to wait for database deployment..

```
Setting name...: distributed.deployDbTaskTimeout
Default value..: 1200000
Set at run-time: true
Hidden.........: false
```

##### distributed.deployChunkTaskTimeout

Maximum timeout (in ms) to wait for database chunk deployment..

```
Setting name...: distributed.deployChunkTaskTimeout
Default value..: 15000
Set at run-time: true
Hidden.........: false
```

##### distributed.deployDbTaskCompression

Compression level (between 0 and 9) to use in backup for database deployment..

```
Setting name...: distributed.deployDbTaskCompression
Default value..: 7
Set at run-time: true
Hidden.........: false
```

##### distributed.queueTimeout

Maximum timeout (in ms) to wait for the response in replication..

```
Setting name...: distributed.queueTimeout
Default value..: 5000
Set at run-time: true
Hidden.........: false
```

##### distributed.asynchQueueSize

Queue size to handle distributed asynchronous operations. The bigger is the queue, the more operation are buffered, but also more memory it's consumed. 0 = dynamic allocation, which means up to 2^31-1 entries..

```
Setting name...: distributed.asynchQueueSize
Default value..: 0
Set at run-time: false
Hidden.........: false
```

##### distributed.asynchResponsesTimeout

Maximum timeout (in ms) to collect all the asynchronous responses from replication. After this time the operation is rolled back (through an UNDO)..

```
Setting name...: distributed.asynchResponsesTimeout
Default value..: 15000
Set at run-time: false
Hidden.........: false
```

##### distributed.purgeResponsesTimerDelay

Maximum timeout (in ms) to collect all the asynchronous responses from replication. This is the delay the purge thread uses to check asynchronous requests in timeout..

```
Setting name...: distributed.purgeResponsesTimerDelay
Default value..: 15000
Set at run-time: false
Hidden.........: false
```

##### distributed.queueMaxSize

Maximum queue size to mark a node as stalled. If the numer of messages in queue are more than this values, the node is restarted with a remote command (0 = no maximum, which means up to 2^31-1 entries)..

```
Setting name...: distributed.queueMaxSize
Default value..: 100
Set at run-time: false
Hidden.........: false
```

##### distributed.backupDirectory

Directory where the copy of an existent database is saved, before it is downloaded from the cluster..

```
Setting name...: distributed.backupDirectory
Default value..: ../backup/databases
Set at run-time: false
Hidden.........: false
```

##### distributed.concurrentTxMaxAutoRetry

Maximum attempts the transaction coordinator should execute a transaction automatically, if records are locked. (Minimum is 1 = no attempts).

```
Setting name...: distributed.concurrentTxMaxAutoRetry
Default value..: 10
Set at run-time: true
Hidden.........: false
```

##### distributed.concurrentTxAutoRetryDelay

Delay (in ms) between attempts on executing a distributed transaction, which had failed because of locked records. (0=no delay).

```
Setting name...: distributed.concurrentTxAutoRetryDelay
Default value..: 100
Set at run-time: true
Hidden.........: false
```
----

### Oauth2


##### oauth2.secretkey

Http OAuth2 secret key..

```
Setting name...: oauth2.secretkey
Default value..: 
Set at run-time: false
Hidden.........: false
```
----

### Lazyset


##### lazyset.workOnStream

Deprecated, now BINARY serialization is used in place of CSV.

```
Setting name...: lazyset.workOnStream
Default value..: true
Set at run-time: false
Hidden.........: false
```
----

### Mvrbtree


##### mvrbtree.timeout

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.timeout
Default value..: 0
Set at run-time: false
Hidden.........: false
```

##### mvrbtree.nodePageSize

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.nodePageSize
Default value..: 256
Set at run-time: false
Hidden.........: false
```

##### mvrbtree.loadFactor

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.loadFactor
Default value..: 0.7
Set at run-time: false
Hidden.........: false
```

##### mvrbtree.optimizeThreshold

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.optimizeThreshold
Default value..: 100000
Set at run-time: false
Hidden.........: false
```

##### mvrbtree.entryPoints

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.entryPoints
Default value..: 64
Set at run-time: false
Hidden.........: false
```

##### mvrbtree.optimizeEntryPointsFactor

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.optimizeEntryPointsFactor
Default value..: 1.0
Set at run-time: false
Hidden.........: false
```

##### mvrbtree.entryKeysInMemory

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.entryKeysInMemory
Default value..: false
Set at run-time: false
Hidden.........: false
```

##### mvrbtree.entryValuesInMemory

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.entryValuesInMemory
Default value..: false
Set at run-time: false
Hidden.........: false
```

##### mvrbtree.ridBinaryThreshold

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.ridBinaryThreshold
Default value..: -1
Set at run-time: false
Hidden.........: false
```

##### mvrbtree.ridNodePageSize

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.ridNodePageSize
Default value..: 64
Set at run-time: false
Hidden.........: false
```

##### mvrbtree.ridNodeSaveMemory

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.ridNodeSaveMemory
Default value..: false
Set at run-time: false
Hidden.........: false
```


*NOTE: On 64-bit systems you have not the limitation of 32-bit systems with memory.*

## Logging

Logging is configured in a separate file, look at [Logging](Logging.md) for more information.

## Storage configuration
OrientDB allows modifications to the storage configuration. Even though this will be supported with high level commands, for now it's pretty "internal" using Java API.

To get the storage configuration for the current database:

    OStorageConfiguration cfg = db.getStorage().getConfiguration();

Look at <code>[OStorageConfiguration](https://github.com/nuvolabase/orientdb/blob/master/core/src/main/java/com/orientechnologies/orient/core/config/OStorageConfiguration.java)</code> to discover all the properties you can change. To change the configuration of a cluster get it by ID;

    OStoragePhysicalClusterConfigurationLocal clusterCfg = (OStoragePhysicalClusterConfigurationLocal) cfg.clusters.get(3);

To change the default settings for new clusters get the file template object. In this example we change the initial file size from the default 500Kb down to 10Kb:

    OStorageSegmentConfiguration defaultCfg = (OStorageSegmentConfiguration) cfg.fileTemplate;
    defaultCfg.fileStartSize = "10Kb";

After changes call <code>OStorageConfiguration.update()</code>:

    cfg.update();
