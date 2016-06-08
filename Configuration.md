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

To know more look at the Java enumeration: [OGlobalConfiguration.java](https://github.com/nuvolabase/orientdb/blob/master/core/src/main/java/com/orientechnologies/orient/core/config/OGlobalConfiguration.java).


----

### Environment


##### environment.dumpCfgAtStartup

Dumps the configuration at application startup.

```
Setting name...: environment.dumpCfgAtStartup
Default value..: false
Set at run-time: false
```

##### environment.concurrent

Specifies if running in multi-thread environment. Setting this to false turns off the internal lock management.

```
Setting name...: environment.concurrent
Default value..: true
Set at run-time: false
```

##### environment.allowJVMShutdown

Allows to shutdown the JVM if needed/requested.

```
Setting name...: environment.allowJVMShutdown
Default value..: true
Set at run-time: true
```
----

### Envinronment


##### envinronment.concurrency.level

Level of paralellization for structures which are split their internal container on several partitions to increase multicore scalability like ConcurrentHashMap, bigger value means bigger memory consumption..

```
Setting name...: envinronment.concurrency.level
Default value..: 8
Set at run-time: false
```
----

### Script


##### script.pool.maxSize

Maximum number of instances in the pool of script engines.

```
Setting name...: script.pool.maxSize
Default value..: 20
Set at run-time: false
```
----

### Memory


##### memory.useUnsafe

Indicates whether Unsafe will be used if it is present.

```
Setting name...: memory.useUnsafe
Default value..: true
Set at run-time: false
```

##### memory.directMemory.safeMode

Indicates whether to do perform range check before each direct memory update, it is true by default, but usually it can be safely put to false. It is needed to set to true only after dramatic changes in storage structures..

```
Setting name...: memory.directMemory.safeMode
Default value..: true
Set at run-time: false
```

##### memory.directMemory.trackMode

If 'track mode' is switched on then following steps are performed: 1. direct memory JMX bean is registered. 2. You may check amount of allocated direct memory as property of JMX bean. 3. If memory leak is detected then JMX event will be fired. This mode provides big overhead and may be used only for testing purpose.

```
Setting name...: memory.directMemory.trackMode
Default value..: false
Set at run-time: false
```

##### memory.directMemory.onlyAlignedMemoryAccess

Some architectures does not allow unaligned memory access or suffer from speed degradation, on this platforms flag should be set to true.

```
Setting name...: memory.directMemory.onlyAlignedMemoryAccess
Default value..: true
Set at run-time: false
```
----

### Jvm


##### jvm.gc.delayForOptimize

Minimal amount of time (seconds) since last System.gc() when called after tree optimization.

```
Setting name...: jvm.gc.delayForOptimize
Default value..: 600
Set at run-time: false
```
----

### Storage


##### storage.diskCache.pinnedPages

Maximum amount of pinned pages which may be contained in cache, if this percent is reached next pages will be left in unpinned state. You can not set value more than 50.

```
Setting name...: storage.diskCache.pinnedPages
Default value..: 20
Set at run-time: false
```

##### storage.diskCache.bufferSize

Size of disk buffer in megabytes, disk size may be changed at runtime, but if does not enough to contain all pinned pages exception will be thrown..

```
Setting name...: storage.diskCache.bufferSize
Default value..: 4096
Set at run-time: true
```

##### storage.diskCache.writeCachePart

Percent of disk cache which is use as write cache.

```
Setting name...: storage.diskCache.writeCachePart
Default value..: 15
Set at run-time: false
```

##### storage.diskCache.writeCachePageTTL

Max time till page will be flushed from write cache in seconds.

```
Setting name...: storage.diskCache.writeCachePageTTL
Default value..: 86400
Set at run-time: false
```

##### storage.diskCache.writeCachePageFlushInterval

Interval between flushing of pages from write cache in ms..

```
Setting name...: storage.diskCache.writeCachePageFlushInterval
Default value..: 25
Set at run-time: false
```

##### storage.diskCache.writeCacheFlushInactivityInterval

Interval between 2 writes to the disk cache, if writes are done with interval more than provided all files will be fsynced before next write, which allows do not do data restore after server crash (in ms)..

```
Setting name...: storage.diskCache.writeCacheFlushInactivityInterval
Default value..: 60000
Set at run-time: false
```

##### storage.diskCache.writeCacheFlushLockTimeout

Maximum amount of time till write cache will be wait before page flush in ms..

```
Setting name...: storage.diskCache.writeCacheFlushLockTimeout
Default value..: -1
Set at run-time: false
```

##### storage.diskCache.diskFreeSpaceCheckInterval

The interval (in seconds), after which the storage periodically checks whether the amount of free disk space is enough to work in write mode.

```
Setting name...: storage.diskCache.diskFreeSpaceCheckInterval
Default value..: 5
Set at run-time: false
```

##### storage.diskCache.diskFreeSpaceCheckIntervalInPages

The interval (how many new pages should be added before free space will be checked), after which the storage periodically checks whether the amount of free disk space is enough to work in write mode.

```
Setting name...: storage.diskCache.diskFreeSpaceCheckIntervalInPages
Default value..: 2048
Set at run-time: false
```

##### storage.diskCache.keepState

Keep disk cache state between moment when storage is closed and moment when it is opened again. true by default..

```
Setting name...: storage.diskCache.keepState
Default value..: true
Set at run-time: false
```

##### storage.configuration.syncOnUpdate

Should we perform force sync of storage configuration for each update.

```
Setting name...: storage.configuration.syncOnUpdate
Default value..: true
Set at run-time: false
```

##### storage.compressionMethod

Record compression method is used in storage. Possible values : gzip, nothing, snappy, snappy-native. Default is snappy..

```
Setting name...: storage.compressionMethod
Default value..: nothing
Set at run-time: false
```

##### storage.useWAL

Whether WAL should be used in paginated storage.

```
Setting name...: storage.useWAL
Default value..: true
Set at run-time: false
```

##### storage.wal.syncOnPageFlush

Should we perform force sync during WAL page flush.

```
Setting name...: storage.wal.syncOnPageFlush
Default value..: true
Set at run-time: false
```

##### storage.wal.cacheSize

Maximum size of WAL cache (in amount of WAL pages, each page is 64k) <= 0 means that caching will be switched off..

```
Setting name...: storage.wal.cacheSize
Default value..: 3000
Set at run-time: false
```

##### storage.wal.maxSegmentSize

Maximum size of single. WAL segment in megabytes..

```
Setting name...: storage.wal.maxSegmentSize
Default value..: 128
Set at run-time: false
```

##### storage.wal.maxSize

Supposed, maximum size of WAL on disk in megabytes. This size may be more or less. .

```
Setting name...: storage.wal.maxSize
Default value..: 4096
Set at run-time: false
```

##### storage.wal.commitTimeout

Maximum interval between WAL commits (in ms.).

```
Setting name...: storage.wal.commitTimeout
Default value..: 1000
Set at run-time: false
```

##### storage.wal.shutdownTimeout

Maximum wait interval between events when background flush thread will receive shutdown command and when background flush will be stopped (in ms.).

```
Setting name...: storage.wal.shutdownTimeout
Default value..: 10000
Set at run-time: false
```

##### storage.wal.fuzzyCheckpointInterval

Interval between fuzzy checkpoints (in seconds).

```
Setting name...: storage.wal.fuzzyCheckpointInterval
Default value..: 300
Set at run-time: false
```

##### storage.wal.reportAfterOperationsDuringRestore

Amount of processed log operations, after which status of data restore procedure will be printed 0 or negative value, means that status will not be printed.

```
Setting name...: storage.wal.reportAfterOperationsDuringRestore
Default value..: 10000
Set at run-time: false
```

##### storage.wal.restore.batchSize

Amount of wal records are read at once in single batch during restore procedure.

```
Setting name...: storage.wal.restore.batchSize
Default value..: 1000
Set at run-time: false
```

##### storage.wal.readCacheSize

Size of WAL read cache in amount of pages.

```
Setting name...: storage.wal.readCacheSize
Default value..: 1000
Set at run-time: false
```

##### storage.wal.fuzzyCheckpointShutdownWait

Interval which we should wait till shutdown (in seconds).

```
Setting name...: storage.wal.fuzzyCheckpointShutdownWait
Default value..: 600
Set at run-time: false
```

##### storage.wal.fullCheckpointShutdownTimeout

Timeout till DB will wait that full checkpoint is finished during DB close (in seconds)).

```
Setting name...: storage.wal.fullCheckpointShutdownTimeout
Default value..: 600
Set at run-time: false
```

##### storage.wal.path

Path to the wal file on the disk, by default is placed in DB directory but it is highly recomended to use separate disk to store log operations.

```
Setting name...: storage.wal.path
Default value..: null
Set at run-time: false
```

##### storage.makeFullCheckpointAfterCreate

Indicates whether full checkpoint should be performed if storage was created..

```
Setting name...: storage.makeFullCheckpointAfterCreate
Default value..: true
Set at run-time: false
```

##### storage.makeFullCheckpointAfterOpen

Indicates whether full checkpoint should be performed if storage was opened. It is needed to make fuzzy checkpoints to work without issues.

```
Setting name...: storage.makeFullCheckpointAfterOpen
Default value..: true
Set at run-time: false
```

##### storage.makeFullCheckpointAfterClusterCreate

Indicates whether full checkpoint should be performed if storage was opened..

```
Setting name...: storage.makeFullCheckpointAfterClusterCreate
Default value..: true
Set at run-time: false
```

##### storage.diskCache.pageSize

Size of page of disk buffer in kilobytes,!!! NEVER CHANGE THIS VALUE !!!.

```
Setting name...: storage.diskCache.pageSize
Default value..: 64
Set at run-time: false
```

##### storage.diskCache.diskFreeSpaceLimit

Minimum amount of space on disk, which, when exceeded, will cause the database to switch to read-only mode (in megabytes).

```
Setting name...: storage.diskCache.diskFreeSpaceLimit
Default value..: 256
Set at run-time: false
```

##### storage.lowestFreeListBound

The minimal amount of free space (in kb) in page which is tracked in paginated storage.

```
Setting name...: storage.lowestFreeListBound
Default value..: 16
Set at run-time: false
```

##### storage.cluster.usecrc32

Indicates whether crc32 should be used for each record to check record integrity..

```
Setting name...: storage.cluster.usecrc32
Default value..: false
Set at run-time: false
```

##### storage.lockTimeout

Maximum timeout in milliseconds to lock the storage.

```
Setting name...: storage.lockTimeout
Default value..: 0
Set at run-time: false
```

##### storage.record.lockTimeout

Maximum timeout in milliseconds to lock a shared record.

```
Setting name...: storage.record.lockTimeout
Default value..: 2000
Set at run-time: false
```

##### storage.useTombstones

When record will be deleted its cluster position will not be freed but tombstone will be placed instead.

```
Setting name...: storage.useTombstones
Default value..: false
Set at run-time: false
```

##### storage.keepOpen

Deprecated.

```
Setting name...: storage.keepOpen
Default value..: true
Set at run-time: false
```
----

### Record


##### record.downsizing.enabled

On updates if the record size is lower than before, reduces the space taken accordingly. If enabled this could increase defragmentation, but it reduces the used space.

```
Setting name...: record.downsizing.enabled
Default value..: true
Set at run-time: false
```
----

### Object


##### object.saveOnlyDirty

Object Database only saves objects bound to dirty records.

```
Setting name...: object.saveOnlyDirty
Default value..: false
Set at run-time: true
```
----

### Db


##### db.pool.min

Default database pool minimum size.

```
Setting name...: db.pool.min
Default value..: 1
Set at run-time: false
```

##### db.pool.max

Default database pool maximum size.

```
Setting name...: db.pool.max
Default value..: 100
Set at run-time: false
```

##### db.pool.idleTimeout

Timeout for checking of free database in the pool.

```
Setting name...: db.pool.idleTimeout
Default value..: 0
Set at run-time: false
```

##### db.pool.idleCheckDelay

Delay time on checking for idle databases.

```
Setting name...: db.pool.idleCheckDelay
Default value..: 0
Set at run-time: false
```

##### db.mvcc.throwfast

Use fast-thrown exceptions for MVCC OConcurrentModificationExceptions. No context information will be available, use where these exceptions are handled and the detail is not neccessary.

```
Setting name...: db.mvcc.throwfast
Default value..: false
Set at run-time: true
```

##### db.validation

Enables or disables validation of records.

```
Setting name...: db.validation
Default value..: true
Set at run-time: true
```

##### db.makeFullCheckpointOnIndexChange

When index metadata is changed full checkpoint is performed.

```
Setting name...: db.makeFullCheckpointOnIndexChange
Default value..: true
Set at run-time: true
```

##### db.makeFullCheckpointOnSchemaChange

When index schema is changed full checkpoint is performed.

```
Setting name...: db.makeFullCheckpointOnSchemaChange
Default value..: true
Set at run-time: true
```

##### db.document.serializer

The default record serializer used by the document database.

```
Setting name...: db.document.serializer
Default value..: ORecordSerializerBinary
Set at run-time: false
```

##### db.mvcc

Deprecated, MVCC cannot be disabled anymore.

```
Setting name...: db.mvcc
Default value..: true
Set at run-time: false
```

##### db.use.distributedVersion

Deprecated, distributed version is not used anymore.

```
Setting name...: db.use.distributedVersion
Default value..: false
Set at run-time: false
```
----

### NonTX


##### nonTX.recordUpdate.synch

Executes a synch against the file-system at every record operation. This slows down records updates but guarantee reliability on unreliable drives.

```
Setting name...: nonTX.recordUpdate.synch
Default value..: false
Set at run-time: false
```

##### nonTX.clusters.sync.immediately

List of clusters to sync immediately after update separated by commas. Can be useful for manual index.

```
Setting name...: nonTX.clusters.sync.immediately
Default value..: manindex
Set at run-time: false
```
----

### Tx


##### tx.trackAtomicOperations

This setting is used only for debug purpose, it track stac trace of methods where atomic operation is started..

```
Setting name...: tx.trackAtomicOperations
Default value..: false
Set at run-time: false
```

##### tx.commit.synch

Synchronizes the storage after transaction commit.

```
Setting name...: tx.commit.synch
Default value..: false
Set at run-time: false
```

##### tx.autoRetry

Maximum number of automatic retry if some resource has been locked in the middle of the transaction (Timeout exception).

```
Setting name...: tx.autoRetry
Default value..: 1
Set at run-time: false
```

##### tx.log.fileType

File type to handle transaction logs: mmap or classic.

```
Setting name...: tx.log.fileType
Default value..: classic
Set at run-time: false
```

##### tx.log.synch

Executes a synch against the file-system at every log entry. This slows down transactions but guarantee transaction reliability on unreliable drives.

```
Setting name...: tx.log.synch
Default value..: false
Set at run-time: false
```

##### tx.useLog

Transactions use log file to store temporary data to be rolled back in case of crash.

```
Setting name...: tx.useLog
Default value..: true
Set at run-time: false
```
----

### Index


##### index.embeddedToSbtreeBonsaiThreshold

Amount of values after which index implementation will use sbtree as values container. Set to -1 to force always using it.

```
Setting name...: index.embeddedToSbtreeBonsaiThreshold
Default value..: 40
Set at run-time: false
```

##### index.sbtreeBonsaiToEmbeddedThreshold

Amount of values after which index implementation will use embedded values container (disabled by default).

```
Setting name...: index.sbtreeBonsaiToEmbeddedThreshold
Default value..: -1
Set at run-time: false
```

##### index.auto.synchronousAutoRebuild

Synchronous execution of auto rebuilding of indexes in case of db crash..

```
Setting name...: index.auto.synchronousAutoRebuild
Default value..: true
Set at run-time: false
```

##### index.auto.lazyUpdates

Configure the TreeMaps for automatic indexes as buffered or not. -1 means buffered until tx.commit() or db.close() are called.

```
Setting name...: index.auto.lazyUpdates
Default value..: 10000
Set at run-time: false
```

##### index.flushAfterCreate

Flush storage buffer after index creation.

```
Setting name...: index.flushAfterCreate
Default value..: true
Set at run-time: false
```

##### index.manual.lazyUpdates

Configure the TreeMaps for manual indexes as buffered or not. -1 means buffered until tx.commit() or db.close() are called.

```
Setting name...: index.manual.lazyUpdates
Default value..: 1
Set at run-time: false
```

##### index.durableInNonTxMode

Indicates whether index implementation for plocal storage will be durable in non-Tx mode, false by default.

```
Setting name...: index.durableInNonTxMode
Default value..: false
Set at run-time: false
```

##### index.txMode

Indicates index durability level in TX mode. Can be ROLLBACK_ONLY or FULL (ROLLBACK_ONLY by default).

```
Setting name...: index.txMode
Default value..: FULL
Set at run-time: false
```

##### index.cursor.prefetchSize

Default prefetch size of index cursor.

```
Setting name...: index.cursor.prefetchSize
Default value..: 500000
Set at run-time: false
```

##### index.auto.rebuildAfterNotSoftClose

Auto rebuild all automatic indexes after upon database open when wasn't closed properly.

```
Setting name...: index.auto.rebuildAfterNotSoftClose
Default value..: true
Set at run-time: false
```
----

### HashTable


##### hashTable.slitBucketsBuffer.length

Length of buffer (in pages) where buckets that were splited but not flushed to the disk are kept. This buffer is used to minimize random IO overhead..

```
Setting name...: hashTable.slitBucketsBuffer.length
Default value..: 1500
Set at run-time: false
```
----

### Sbtree


##### sbtree.maxDepth

Maximum depth of sbtree which will be traversed during key look up till it will be treated like broken (64 by default).

```
Setting name...: sbtree.maxDepth
Default value..: 64
Set at run-time: false
```

##### sbtree.maxKeySize

Maximum size of key which can be put in SBTree in bytes (10240 by default).

```
Setting name...: sbtree.maxKeySize
Default value..: 10240
Set at run-time: false
```

##### sbtree.maxEmbeddedValueSize

Maximum size of value which can be put in SBTree without creation link to standalone page in bytes (40960 by default).

```
Setting name...: sbtree.maxEmbeddedValueSize
Default value..: 40960
Set at run-time: false
```
----

### Sbtreebonsai


##### sbtreebonsai.bucketSize

Size of bucket in OSBTreeBonsai in kB. Contract: bucketSize < storagePageSize, storagePageSize % bucketSize == 0..

```
Setting name...: sbtreebonsai.bucketSize
Default value..: 2
Set at run-time: false
```

##### sbtreebonsai.linkBagCache.size

Amount of LINKBAG collections are cached to avoid constant reloading of data.

```
Setting name...: sbtreebonsai.linkBagCache.size
Default value..: 100000
Set at run-time: false
```

##### sbtreebonsai.linkBagCache.evictionSize

How many items of cached LINKBAG collections will be removed when cache limit is reached.

```
Setting name...: sbtreebonsai.linkBagCache.evictionSize
Default value..: 1000
Set at run-time: false
```

##### sbtreebonsai.freeSpaceReuseTrigger

How much free space should be in sbtreebonsai file before it will be reused during next allocation.

```
Setting name...: sbtreebonsai.freeSpaceReuseTrigger
Default value..: 0.5
Set at run-time: false
```
----

### RidBag


##### ridBag.embeddedDefaultSize

Size of embedded RidBag array when created (empty).

```
Setting name...: ridBag.embeddedDefaultSize
Default value..: 4
Set at run-time: false
```

##### ridBag.embeddedToSbtreeBonsaiThreshold

Amount of values after which LINKBAG implementation will use sbtree as values container. Set to -1 to force always using it.

```
Setting name...: ridBag.embeddedToSbtreeBonsaiThreshold
Default value..: 40
Set at run-time: true
```

##### ridBag.sbtreeBonsaiToEmbeddedToThreshold

Amount of values after which LINKBAG implementation will use embedded values container (disabled by default).

```
Setting name...: ridBag.sbtreeBonsaiToEmbeddedToThreshold
Default value..: -1
Set at run-time: true
```
----

### Collections


##### collections.preferSBTreeSet

This config is experimental..

```
Setting name...: collections.preferSBTreeSet
Default value..: false
Set at run-time: false
```
----

### File


##### file.trackFileClose

Log all the cases when files are closed. This is needed only for internal debugging purpose.

```
Setting name...: file.trackFileClose
Default value..: false
Set at run-time: false
```

##### file.lock

Locks files when used. Default is true.

```
Setting name...: file.lock
Default value..: true
Set at run-time: false
```

##### file.deleteDelay

Delay time in ms to wait for another attempt to delete a locked file.

```
Setting name...: file.deleteDelay
Default value..: 10
Set at run-time: false
```

##### file.deleteRetry

Number of retries to delete a locked file.

```
Setting name...: file.deleteRetry
Default value..: 50
Set at run-time: false
```
----

### Jna


##### jna.disable.system.library

This property disable to using JNA installed in your system. And use JNA bundled with database..

```
Setting name...: jna.disable.system.library
Default value..: true
Set at run-time: false
```
----

### Network


##### network.maxConcurrentSessions

Maximum number of concurrent sessions.

```
Setting name...: network.maxConcurrentSessions
Default value..: 1000
Set at run-time: true
```

##### network.socketBufferSize

TCP/IP Socket buffer size.

```
Setting name...: network.socketBufferSize
Default value..: 32768
Set at run-time: true
```

##### network.lockTimeout

Timeout in ms to acquire a lock against a channel.

```
Setting name...: network.lockTimeout
Default value..: 15000
Set at run-time: true
```

##### network.socketTimeout

TCP/IP Socket timeout in ms.

```
Setting name...: network.socketTimeout
Default value..: 15000
Set at run-time: true
```

##### network.requestTimeout

Request completion timeout in ms .

```
Setting name...: network.requestTimeout
Default value..: 3600000
Set at run-time: true
```

##### network.retry

Number of times the client retries its connection to the server on failure.

```
Setting name...: network.retry
Default value..: 5
Set at run-time: true
```

##### network.retryDelay

Number of ms the client waits before reconnecting to the server on failure.

```
Setting name...: network.retryDelay
Default value..: 500
Set at run-time: true
```

##### network.binary.loadBalancing.enabled

Asks for DNS TXT record to determine if load balancing is supported.

```
Setting name...: network.binary.loadBalancing.enabled
Default value..: false
Set at run-time: true
```

##### network.binary.loadBalancing.timeout

Maximum time (in ms) to wait for the answer from DNS about the TXT record for load balancing.

```
Setting name...: network.binary.loadBalancing.timeout
Default value..: 2000
Set at run-time: true
```

##### network.binary.maxLength

TCP/IP max content length in bytes of BINARY requests.

```
Setting name...: network.binary.maxLength
Default value..: 32736
Set at run-time: true
```

##### network.binary.readResponse.maxTimes

Maximum times to wait until response will be read. Otherwise response will be dropped from chanel.

```
Setting name...: network.binary.readResponse.maxTimes
Default value..: 20
Set at run-time: true
```

##### network.binary.debug

Debug mode: print all data incoming on the binary channel.

```
Setting name...: network.binary.debug
Default value..: false
Set at run-time: true
```

##### network.http.maxLength

TCP/IP max content length in bytes for HTTP requests.

```
Setting name...: network.http.maxLength
Default value..: 1000000
Set at run-time: true
```

##### network.http.charset

Http response charset.

```
Setting name...: network.http.charset
Default value..: utf-8
Set at run-time: true
```

##### network.http.jsonResponseError

Http response error in json.

```
Setting name...: network.http.jsonResponseError
Default value..: true
Set at run-time: true
```

##### network.http.jsonp

Enable the usage of JSONP if requested by the client. The parameter name to use is 'callback'.

```
Setting name...: network.http.jsonp
Default value..: false
Set at run-time: true
```

##### network.http.sessionExpireTimeout

Timeout after which an http session is considered tp have expired (seconds).

```
Setting name...: network.http.sessionExpireTimeout
Default value..: 300
Set at run-time: false
```

##### network.http.useToken

Enable Token based sessions for http.

```
Setting name...: network.http.useToken
Default value..: false
Set at run-time: false
```

##### network.token.secretyKey

Network token sercret key.

```
Setting name...: network.token.secretyKey
Default value..: 
Set at run-time: false
```

##### network.token.encriptionAlgorithm

Network token algorithm.

```
Setting name...: network.token.encriptionAlgorithm
Default value..: HmacSHA256
Set at run-time: false
```

##### network.token.expireTimeout

Timeout after which an binary session is considered tp have expired (minutes).

```
Setting name...: network.token.expireTimeout
Default value..: 60
Set at run-time: false
```
----

### Oauth2


##### oauth2.secretkey

Http OAuth2 secret key.

```
Setting name...: oauth2.secretkey
Default value..: 
Set at run-time: false
```
----

### Profiler


##### profiler.enabled

Enable the recording of statistics and counters.

```
Setting name...: profiler.enabled
Default value..: false
Set at run-time: true
```

##### profiler.config

Configures the profiler as <seconds-for-snapshot>,<archive-snapshot-size>,<summary-size>.

```
Setting name...: profiler.config
Default value..: null
Set at run-time: true
```

##### profiler.autoDump.interval

Dumps the profiler values at regular intervals. Time is expressed in seconds.

```
Setting name...: profiler.autoDump.interval
Default value..: 0
Set at run-time: true
```

##### profiler.maxValues

Maximum values to store. Values are managed in a LRU.

```
Setting name...: profiler.maxValues
Default value..: 200
Set at run-time: false
```
----

### Log


##### log.console.level

Console logging level.

```
Setting name...: log.console.level
Default value..: info
Set at run-time: true
```

##### log.file.level

File logging level.

```
Setting name...: log.file.level
Default value..: fine
Set at run-time: true
```
----

### Command


##### command.timeout

Default timeout for commands expressed in milliseconds.

```
Setting name...: command.timeout
Default value..: 0
Set at run-time: true
```
----

### Query


##### query.scanThresholdTip

If total number of records scanned in a query is major than this threshold a warning is given. Use 0 to disable it.

```
Setting name...: query.scanThresholdTip
Default value..: 50000
Set at run-time: false
```

##### query.limitThresholdTip

If total number of returned records in a query is major than this threshold a warning is given. Use 0 to disable it.

```
Setting name...: query.limitThresholdTip
Default value..: 10000
Set at run-time: false
```
----

### Sql


##### sql.graphConsistencyMode

Consistency mode for graphs. It can be 'tx' (default), 'notx_sync_repair' and 'notx_async_repair'. 'tx' uses transactions to maintain consistency. Instead both 'notx_sync_repair' and 'notx_async_repair' do not use transactions, and the consistency, in case of JVM crash, is guaranteed by a database repair operation that run at startup. With 'notx_sync_repair' the repair is synchronous, so the database comes online after the repair is ended, while with 'notx_async_repair' the repair is a background process.

```
Setting name...: sql.graphConsistencyMode
Default value..: tx
Set at run-time: false
```
----

### Client


##### client.channel.maxPool

Maximum size of pool of network channels between client and server. A channel is a TCP/IP connection..

```
Setting name...: client.channel.maxPool
Default value..: 100
Set at run-time: false
```

##### client.connectionPool.waitTimeout

Maximum time which client should wait a connection from the pool when all connection are used.

```
Setting name...: client.connectionPool.waitTimeout
Default value..: 5000
Set at run-time: true
```

##### client.channel.dbReleaseWaitTimeout

Delay in ms. after which data modification command will be resent if DB was frozen.

```
Setting name...: client.channel.dbReleaseWaitTimeout
Default value..: 10000
Set at run-time: true
```

##### client.ssl.enabled

Use SSL for client connections.

```
Setting name...: client.ssl.enabled
Default value..: false
Set at run-time: false
```

##### client.ssl.keyStore

Use SSL for client connections.

```
Setting name...: client.ssl.keyStore
Default value..: null
Set at run-time: false
```

##### client.ssl.keyStorePass

Use SSL for client connections.

```
Setting name...: client.ssl.keyStorePass
Default value..: null
Set at run-time: false
```

##### client.ssl.trustStore

Use SSL for client connections.

```
Setting name...: client.ssl.trustStore
Default value..: null
Set at run-time: false
```

##### client.ssl.trustStorePass

Use SSL for client connections.

```
Setting name...: client.ssl.trustStorePass
Default value..: null
Set at run-time: false
```

##### client.session.tokenBased

Request a token based session to the server.

```
Setting name...: client.session.tokenBased
Default value..: false
Set at run-time: false
```

##### client.channel.minPool

Minimum pool size.

```
Setting name...: client.channel.minPool
Default value..: 1
Set at run-time: false
```
----

### Server


##### server.channel.cleanDelay

Time in ms of delay to check pending closed connections.

```
Setting name...: server.channel.cleanDelay
Default value..: 5000
Set at run-time: false
```

##### server.cache.staticFile

Cache static resources loading.

```
Setting name...: server.cache.staticFile
Default value..: false
Set at run-time: false
```

##### server.log.dumpClientExceptionLevel

Logs client exceptions. Use any level supported by Java java.util.logging.Level class: OFF, FINE, CONFIG, INFO, WARNING, SEVERE.

```
Setting name...: server.log.dumpClientExceptionLevel
Default value..: FINE
Set at run-time: false
```

##### server.log.dumpClientExceptionFullStackTrace

Dumps the full stack trace of the exception to sent to the client.

```
Setting name...: server.log.dumpClientExceptionFullStackTrace
Default value..: false
Set at run-time: true
```
----

### Distributed


##### distributed.crudTaskTimeout

Maximum timeout in milliseconds to wait for CRUD remote tasks.

```
Setting name...: distributed.crudTaskTimeout
Default value..: 3000
Set at run-time: true
```

##### distributed.commandTaskTimeout

Maximum timeout in milliseconds to wait for Command remote tasks.

```
Setting name...: distributed.commandTaskTimeout
Default value..: 10000
Set at run-time: true
```

##### distributed.commandLongTaskTimeout

Maximum timeout in milliseconds to wait for Long-running remote tasks.

```
Setting name...: distributed.commandLongTaskTimeout
Default value..: 86400000
Set at run-time: true
```

##### distributed.deployDbTaskTimeout

Maximum timeout in milliseconds to wait for database deployment.

```
Setting name...: distributed.deployDbTaskTimeout
Default value..: 1200000
Set at run-time: true
```

##### distributed.deployChunkTaskTimeout

Maximum timeout in milliseconds to wait for database chunk deployment.

```
Setting name...: distributed.deployChunkTaskTimeout
Default value..: 15000
Set at run-time: true
```

##### distributed.deployDbTaskCompression

Compression level between 0 and 9 to use in backup for database deployment.

```
Setting name...: distributed.deployDbTaskCompression
Default value..: 7
Set at run-time: true
```

##### distributed.queueTimeout

Maximum timeout in milliseconds to wait for the response in replication.

```
Setting name...: distributed.queueTimeout
Default value..: 5000
Set at run-time: true
```

##### distributed.asynchQueueSize

Queue size to handle distributed asynchronous operations. 0 = dynamic allocation (up to 2^31-1 entries).

```
Setting name...: distributed.asynchQueueSize
Default value..: 0
Set at run-time: false
```

##### distributed.asynchResponsesTimeout

Maximum timeout in milliseconds to collect all the asynchronous responses from replication.

```
Setting name...: distributed.asynchResponsesTimeout
Default value..: 15000
Set at run-time: false
```

##### distributed.purgeResponsesTimerDelay

Maximum timeout in milliseconds to collect all the asynchronous responses from replication.

```
Setting name...: distributed.purgeResponsesTimerDelay
Default value..: 15000
Set at run-time: false
```

##### distributed.queueMaxSize

Maximum queue size to mark a node as stalled. If the number of messages in queue are more than this values, the node is restarted with a remote command (0 = no maximum, which means up to 2^31-1 entries)..

```
Setting name...: distributed.queueMaxSize
Default value..: 10000
Set at run-time: false
```

##### distributed.backupDirectory

Directory where to copy an existent database before to download from the cluster.

```
Setting name...: distributed.backupDirectory
Default value..: ../backup/databases
Set at run-time: false
```

##### distributed.concurrentTxMaxAutoRetry

Maximum retries the transaction coordinator can execute a transaction automatically if records are locked. Minimum is 1 (no retry).

```
Setting name...: distributed.concurrentTxMaxAutoRetry
Default value..: 10
Set at run-time: true
```

##### distributed.concurrentTxAutoRetryDelay

Delay in ms between attempts on executing a distributed transaction failed because of records locked. 0=no delay.

```
Setting name...: distributed.concurrentTxAutoRetryDelay
Default value..: 100
Set at run-time: true
```
----

### Lazyset


##### lazyset.workOnStream

Deprecated, now BINARY serialization is used in place of CSV.

```
Setting name...: lazyset.workOnStream
Default value..: true
Set at run-time: false
```
----

### Mvrbtree


##### mvrbtree.timeout

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.timeout
Default value..: 0
Set at run-time: false
```

##### mvrbtree.nodePageSize

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.nodePageSize
Default value..: 256
Set at run-time: false
```

##### mvrbtree.loadFactor

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.loadFactor
Default value..: 0.7
Set at run-time: false
```

##### mvrbtree.optimizeThreshold

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.optimizeThreshold
Default value..: 100000
Set at run-time: false
```

##### mvrbtree.entryPoints

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.entryPoints
Default value..: 64
Set at run-time: false
```

##### mvrbtree.optimizeEntryPointsFactor

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.optimizeEntryPointsFactor
Default value..: 1.0
Set at run-time: false
```

##### mvrbtree.entryKeysInMemory

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.entryKeysInMemory
Default value..: false
Set at run-time: false
```

##### mvrbtree.entryValuesInMemory

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.entryValuesInMemory
Default value..: false
Set at run-time: false
```

##### mvrbtree.ridBinaryThreshold

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.ridBinaryThreshold
Default value..: -1
Set at run-time: false
```

##### mvrbtree.ridNodePageSize

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.ridNodePageSize
Default value..: 64
Set at run-time: false
```

##### mvrbtree.ridNodeSaveMemory

Deprecated, MVRBTREE IS NOT USED ANYMORE IN FAVOR OF SBTREE AND HASHINDEX.

```
Setting name...: mvrbtree.ridNodeSaveMemory
Default value..: false
Set at run-time: false
```
----

### Cache


##### cache.local.enabled

Deprecated, Level1 cache cannot be disabled anymore.

```
Setting name...: cache.local.enabled
Default value..: true
Set at run-time: false
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
