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

### Environment

|Parameter|Def.32bit|Def.64bit|Def.Server 32bit|Def.Server 64bit|Allowed input|Description|Since|
|---------|-------------|-------------|--------------------|--------------------|-------------|-----------|------|
|<code>environment.dumpCfgAtStartup</code>|true|false|true|false|true or false|Dumps the configuration at application startup|
|<code>environment.concurrent</code>|true|true|true|true|true or false|Specifies if running in multi-thread environment. Setting this to false turns off the internal lock management|

### Memory

|Parameter|Def.32bit|Def.64bit|Def.Server 32bit|Def.Server 64bit|Allowed input|Description|Since|
|---------|-------------|-------------|--------------------|--------------------|-------------|-----------|------|
|<code>memory.optimizeThreshold</code>|0.85|0.85|0.85|0.85|0.5-0.95|Threshold of heap memory where to start the optimization of memory usage. Deprecated since 1.0rc7 |

### Storage

|Parameter|Def.32bit|Def.64bit|Def.Server 32bit|Def.Server 64bit|Allowed input|Description|Since|
|---------|-------------|-------------|--------------------|--------------------|-------------|-----------|------|
|<code>storage.keepOpen</code>|true|true|true|true|true or false|Tells to the engine to not close the storage when a database is closed. Storages will be closed when the process will shutdown |
|<code>storage.record.lockTimeout</code>|5000|5000|5000|5000|0-N|Maximum timeout in milliseconds to lock a shared record |

### Cache

|Parameter|Def.32bit|Def.64bit|Def.Server 32bit|Def.Server 64bit|Allowed input|Description|Since|
|---------|-------------|-------------|--------------------|--------------------|-------------|-----------|------|
|<code>cache.level1.enabled</code>|true|true|false|false|true or false|Uses the level-1 cache|
|<code>cache.level1.size</code>|-1|-1|0|0|-1 - N|Size of the Level-1 cache in terms of record entries. -1 means no limit but when the free Memory Heap is low then cache entries are freed|
|<code>cache.level2.enabled</code>|true|true|false|false|true or false|Uses the level-2 cache|
|<code>cache.level2.size</code>|-1|-1|0|0|-1 - N|Size of the Level-2 cache in terms of record entries. -1 means no limit but when the free Memory Heap is low then cache entries are freed|

### Database

|Parameter|Def.32bit|Def.64bit|Def.Server 32bit|Def.Server 64bit|Allowed input|Description|Since|
|---------|-------------|-------------|--------------------|--------------------|-------------|-----------|------|
|<code>db.mvcc</code>|true|true|true|true|true or false|Enable Multi Version Control Checking (MVCC) or not|
|<code>object.saveOnlyDirty</code>|false|false|false|false|true or false|Object Database saves only object bound to dirty records|
|<code>nonTX.recordUpdate.synch</code>|false|false|false|false|true or false|Executes a synch against the file-system at every record operation. This slows down records updates but guarantee reliability on unreliable drives|

### Transactions

|Parameter|Def.32bit|Def.64bit|Def.Server 32bit|Def.Server 64bit|Allowed input|Description|Since|
|---------|-------------|-------------|--------------------|--------------------|-------------|-----------|------|
|<code>tx.useLog</code>|true|true|true|true|true or false|Transactions use log file to store temporary data to being rolled back in case of crash|
|<code>tx.log.fileType</code>|classic|classic|classic|classic|'classic' or 'mmap'|File type to handle transaction logs: mmap or classic|
|<code>tx.log.synch</code>|false|false|false|false|true or false|Executes a synch against the file-system for each log entry. This slows down transactions but guarantee transaction reliability on non-reliable drives|
|<code>tx.commit.synch</code>|false|false|true|true|true or false|Synchronizes the storage after transaction commit (see [Disable the disk synch](#Disable_the_disk_synch))|

### [TinkerPop Blueprints](Graph-Database-Tinkerpop.md)

|Parameter|Def.32bit|Def.64bit|Def.Server 32bit|Def.Server 64bit|Allowed input|Description|Since|
|---------|-------------|-------------|--------------------|--------------------|-------------|-----------|------|
|<code>blueprints.graph.txMode</code>|0|0|0|0|0 or 1|Transaction mode used in [TinkerPop Blueprints](Graph-Database-Tinkerpop.md) implementation. 0 = Automatic (default), 1 = Manual|

### Index

|Parameter|Def.32bit|Def.64bit|Def.Server 32bit|Def.Server 64bit|Allowed input|Description|Since|
|---------|-------------|-------------|--------------------|--------------------|-------------|-----------|------|
|<code>index.auto.rebuildAfterNotSoftClose</code>|true|true|true|true|true or false|Auto rebuild all automatic indexes after upon database open when wasn't closed properly|1.3.0|

### MVRB Tree (index and dictionary)

|Parameter|Def.32bit|Def.64bit|Def.Server 32bit|Def.Server 64bit|Allowed input|Description|Since|
|---------|-------------|-------------|--------------------|--------------------|-------------|-----------|------|
|<code>mvrbtree.lazyUpdates</code>|20000|20000|1|1|-1=Auto, 0=always lazy until explicit <code>lazySave()</code> is called by application, 1=No lazy, commit at each change. >1=Commit at every X changes|Configure the MVRB Trees (indexes and dictionaries) as buffered or not|
|<code>mvrbtree.nodePageSize</code>|128|128|128|128|63-65535|Page size of each single node. 1,024 means that 1,024 entries can be stored inside a node|
|<code>mvrbtree.loadFactor</code>|0.7f|0.7f|0.7f|0.7f|0.1-0.9|HashMap load factor|
|<code>mvrbtree.optimizeThreshold</code>|100000|100000|100000|100000|10-N|Auto optimize the MVRB Tree every X operations as get, put and remove. -1=Auto (default)|
|<code>mvrbtree.entryPoints</code>|16|16|16|16|1-200|Number of entry points to start searching entries|
|<code>mvrbtree.optimizeEntryPointsFactor</code>|1.0f|1.0f|1.0f|1.0f|0.1-N| Multiplicand factor to apply to entry-points list (parameter mvrbtree.entrypoints) to determine if needs of optimization|
|<code>mvrbtree.ridBinaryThreshold</code>|8|8|8|8|-1 - N|Valid for set of rids. It's the threshold as number of entries to use the binary streaming instead of classic string streaming. -1 means never use binary streaming|
|<code>mvrbtree.ridNodePageSize</code>|16|16|16|16|4 - N|Page size of each treeset node. 16 means that 16 entries can be stored inside each node|
|<code>mvrbtree.ridNodeSaveMemory</code>|False|False|False|False|true or false|Save memory usage by avoid keeping RIDs in memory but creating them at every access|

### Lazy Collections

|Parameter|Def.32bit|Def.64bit|Def.Server 32bit|Def.Server 64bit|Allowed input|Description|Since|
|---------|-------------|-------------|--------------------|--------------------|-------------|-----------|------|
|<code>lazyset.workOnStream</code>|true|true|false|false|true or false|Work directly on streamed buffer to reduce memory footprint and improve performance|

### File (I/O)

|Parameter|Def. 32bit|Def. 64bit|Def. Server 32bit|Def. Server 64bit|Allowed input|Description|Since|
|---------|-------------|-------------|--------------------|--------------------|-------------|-----------|------|
|<code>file.lock</code>|false|false|false|false|true or false|Locks the used files so other process can't modify them|
|<code>file.defrag.strategy</code>|0|0|0|0|0,1|Strategy to recycle free space. 0=recycles the first hole with enough size (default): fast, 1=recycles the best hole: better usage of space but slower|
|<code>file.defrag.holeMaxDistance</code>|32768 (32Kb)|32768 (32Kb)|32768 (32Kb)|32768 (32Kb)|8K-N|Max distance in bytes between holes to defragment them. Set it to -1 to use dynamic size. Pay attention that if the database is huge, then moving blocks to defragment could be expensive|
|<code>file.mmap.useOldManager</code>|false|false|false|false|true or false|Manager that will be used to handle mmap files. true = USE OLD MANAGER, false = USE NEW MANAGER|
|<code>file.mmap.lockMemory</code>|true|true|true|true|true or false|When using new map manager this parameter specify prevent memory swap or not. true = LOCK MEMORY, false = NOT LOCK MEMORY(If you want this parameter take effect you need to have Orient Native OS jar in class path)|
|<code>file.mmap.strategy</code>|0|0|0|0|0-4|Strategy to use with memory mapped files. 0 = USE MMAP ALWAYS, 1 = USE MMAP ON WRITES OR ON READ JUST WHEN THE BLOCK POOL IS FREE, 2 = USE MMAP ON WRITES OR ON READ JUST WHEN THE BLOCK IS ALREADY AVAILABLE, 3 = USE MMAP ONLY IF BLOCK IS ALREADY AVAILABLE, 4=NEVER USE MMAP|
|<code>file.mmap.blockSize</code>|1048576 (1Mb)|1048576 (1Mb)|1048576 (1Mb)|1048576 (1Mb)|10k-N|Size of the memory mapped block(this property takes effect only if <code>file.mmap.useOldManager</code> is set up to true)|
|<code>file.mmap.bufferSize</code>|8192 (8Kb)|8192 (8Kb)|8192 (8Kb)|8192 (8Kb)|1K-N|Size of the buffer for direct access to the file through the channel(this property takes effect only if <code>file.mmap.useOldManager</code> is set up to true)|
|<code>file.mmap.maxMemory</code>|134Mb|(maxOsMem - maxProcessHeapMem) / 2|like Def. 32 bit|like Def. 64 bit|100000-the maximum allowed by OS|Max memory allocable by memory mapping manager. Note that on 32-bit OS the limit is to 2Gb but can change to OS by OS(this property takes effect only if <code>file.mmap.useOldManager</code> is set up to true)|
|<code>file.mmap.overlapStrategy</code>|2|2|2|2|0-2|Strategy when a request overlap in-memory buffers: 0 = Use the channel access, 1 = force the in memory buffer and use the channel access, 2 = always create an overlapped in-memory buffer (default) (this property takes effect only if <code>file.mmap.useOldManager</code> is set up to true)|
|<code>file.mmap.forceDelay</code>|500 (0.5sec)|500 (0.5sec)|500 (0.5sec)|500 (0.5sec)|100-5000|Delay time in ms to wait for another force flush of the memory mapped block to the disk|
|<code>file.mmap.forceRetry</code>|20|20|20|20|0-N|Number of times the memory mapped block will try to flush to the disk|

### JNA

|Parameter|Def.32bit|Def.64bit|Def.Server 32bit|Def.Server 64bit|Allowed input|Description|Since|
|---------|-------------|-------------|--------------------|--------------------|-------------|-----------|------|
|<code>jna.disable.system.library</code>|true|true|true|true|true or false|This property disable to using JNA installed in your system. And use JNA bundled with database.|

### Networking (I/O)

|Parameter|Def.32bit|Def.64bit|Def.Server 32bit|Def.Server 64bit|Allowed input|Description|Since|
|---------|-------------|-------------|--------------------|--------------------|-------------|-----------|------|
|<code>network.socketBufferSize</code>|32768|32768|32768|32768|8K-N|TCP/IP Socket buffer size|
|<code>network.lockTimeout</code>|15000 (15secs)|15000 (15secs)|15000 (15secs)|15000 (15secs)|0-N|Timeout in ms to acquire a lock against a channel, 0=no timeout|
|<code>network.socketTimeout</code>|10000 (10secs)|10000 (10secs)|10000 (10secs)|10000 (10secs)|0-N|TCP/IP Socket timeout in ms, 0=no timeout|
|<code>network.retry</code>|5|5|5|5|0-N|Number of times the client connection retries to connect to the server in case of failure|
|<code>network.retryDelay</code>|500 (0.5sec)|500 (0.5sec)|500 (0.5sec)|500 (0.5sec)|1-N|Number of ms the client wait to reconnect to the server in case of failure|
|<code>network.binary.maxLength</code>|100000 (100Kb)|100000 (100Kb)|100000 (100Kb)|100000 (100Kb)|1K-N|TCP/IP max content length in bytes of BINARY requests|
|<code>network.binary.readResponse.maxTime</code>|30|30|30|30|0-N|Maximum time (in seconds) to wait until response will be read. Otherwise response will be dropped from chanel|1.0rc9|
|<code>network.binary.debug</code>|false|false|false|false|true or false|Debug mode: print all the incoming data on binary channel|
|<code>network.http.maxLength</code>|100000 (100Kb)|100000 (100Kb)|100000 (100Kb)|100000 (100Kb)|1000-N|TCP/IP max content length in bytes of HTTP requests|
|<code>network.http.charset</code>|utf-8|utf-8|utf-8|utf-8|Supported HTTP charsets|Http response charset|
|<code>network.http.sessionExpireTimeout</code>|300 (5min)|300 (5min)|300 (5min)|300 (5min)|0-N|Timeout in seconds before considering an HTTP session expired|

### [Profiler](Profiler.md)

|Parameter|Def.32bit|Def.64bit|Def.Server 32bit|Def.Server 64bit|Allowed input|Description|Since|
|---------|-------------|-------------|--------------------|--------------------|-------------|-----------|------|
|<code>profiler.enabled</code>|false|false|true|true|true or false|Enable the recording of statistics and counters|
|<code>profiler.autoDump.interval</code>|0|0|0|0|0=inactive >0=time in seconds|Dumps the profiler values at regular intervals. Time is expressed in seconds|1.0rc8|
|<code>profiler.autoDump.reset</code>|true|true|true|true|true or false|Resets the profiler at every auto dump|1.0rc8|
|<code>profiler.config</code>|null|null|null|null|String with 3 values separated by comma with the format: &lt;seconds-for-snapshot&gt;,&lt;archive-snapshot-size&gt;,&lt;summary-size&gt;|Configure the profiler|1.2.0|

### Log

|Parameter|Def.32bit|Def.64bit|Def.Server 32bit|Def.Server 64bit|Allowed input|Description|Since|
|---------|-------------|-------------|--------------------|--------------------|-------------|-----------|------|
|<code>log.console.level</code>|info|info|info|info|fine, info, warn, error|Console's logging level|
|<code>log.file.level</code>|fine|fine|fine|fine|fine, info, warn, error|File's logging level|

### Client

|Parameter|Def.32bit|Def.64bit|Def.Server 32bit|Def.Server 64bit|Allowed input|Description|Since|
|---------|-------------|-------------|--------------------|--------------------|-------------|-----------|------|
|<code>client.channel.minPool</code>|1|1|1|1|1-N|Minimum size of the channel pool|
|<code>client.channel.maxPool</code>|5|5|5|5|1-N|maximum size of the channel pool|

### Server

|Parameter|Def.32bit|Def.64bit|Def.Server 32bit|Def.Server 64bit|Allowed input|Description|Since|
|---------|-------------|-------------|--------------------|--------------------|-------------|-----------|------|
|<code>server.channel.cleanDelay</code>|5000|5000|5000|5000|0-N|Time in ms of delay to check pending closed connections|1.0|
|<code>server.log.dumpClientExceptionLevel</code>|FINE|FINE|FINE|FINE|OFF, FINE, CONFIG, INFO, WARNING, SEVERE|Logs client exceptions. Use any level supported by Java java.util.logging.Level class|1.0|
|<code>server.log.dumpClientExceptionFullStackTrace</code>|false|false|false|false|true or false|Dumps the full stack trace of the exception to sent to the client|1.0|
|<code>server.cache.staticFile</code>|false|false|false|false|true or false|Cache static resources after loaded. It was server.cache.file.static before 1.0|

### Distributed cluster

|Parameter|Def.32bit|Def.64bit|Def.Server 32bit|Def.Server 64bit|Allowed input|Description|Since|
|---------|-------------|-------------|--------------------|--------------------|-------------|-----------|------|
|<code>distributed.async.timeDelay</code>|0|0|0|0|0-N|Delay time (in ms) of synchronization with slave nodes. 0 means early synchronization|
|<code>distributed.sync.maxRecordsBuffer</code>|100|100|100|100|0-10000|Maximum number of records to buffer before to send to the slave nodes|

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
