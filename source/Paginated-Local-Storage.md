# PLocal Storage

The Paginated Local Storage, "**plocal**" from now, is a disk based storage which works with data using page model.

plocal storage consists of several components each of those components use disk data through **[disk cache](plocal-storage-disk-cache.md)**.

Below is list of plocal storage components and short description of each of them:

1. **Clusters** are managed by 2 kinds of files:
 - **.pcl** files contain the cluster data
 - **.cpm** files contain the mapping between record's cluster position and real physical position
2. **Write Ahead (operation) Log ([WAL](Write-Ahead-Log.md))** are managed by 2 kinds of files:
 - **.wal** to store the log content
 - **.wmr** contains timing about synchronization operations between storage cache and disk system
3. **SBTree Index**, it uses files with extensions **.sbt**.
4. **Hash Index**, it uses files with extensions **.hit**, **.him** and **.hib**.
5. **Index Containers** to store values of single entries of not unique index (Index RID Set). It uses files with extension **.irs**.
6. **File mapping**, maps between file names and file ids (used internally). It's a single file with name: **name_id_map.cm**.

## File System
Since PLOCAL is bases on disk, all the pages are flushed to physical files. You can specify any mounted partitions on your machine, backed by Disks, SSD, Flash Disks or DRAM.

## Cluster

**Cluster** is logical piece of disk space where storage stores records data. Each cluster is split in pages. **Page** is a single atomic unit, which is used by cluster.

Each page contains system information and records data. System information includes "magic number" and crc32 check sum of page content. This information is used to check storage integrity after DB crash. To start integrity check run command "check database" from console.

Each cluster has 2 sub components:
- data file, with extension .pcl
- mapping between physical position of record in data file and cluster position, with extension .cpm

### File System
To speed up the access to the most requested clusters it's recommended to use the cluster files to a SSD or any faster support than disk. To do that, move the files to the mounted partitions and create symbolic links to them on original path. OrientDB will follow symbolic links and will open cluster files everywhere are reachable.

### Cluster pointers
The mapping between data file and physical position is managed with a list, where each entry of this list is a fixed size element which is the pointer to the physical position of record in data file.

Because data file is paginated, this pointer consist of 2 items: page index (long value) and position of record inside page (int value), so each record pointer consumes 12 bytes.

### Creation of new records in cluster
When a new record is inserted, a new pointer is added to the list so index of this pointer becomes cluster position. The list is append only data structure so if you add a new record its cluster position will be unique and will not be reused.

### Deletion of records in cluster
When you delete a record, the page index and record position are set to -1. So record pointer is transformed in record tombstone. You can think about record id like a **uuid**. It is unique and never reused.

Usually when you delete records you lose very small amount of disk space. This could be mitigated with a periodic "offline compaction" by performing database export/import. In such case records cluster positions will be changed (tombstones will be ignored during export) and the lost space will be revoked. So during the import process, the cluster positions can change.

#### Migration of RID
OrientDB import tool uses a manual hash index (by default the name is '___exportImportRIDMap') to map the old record ids and new record ids.

## Write Ahead (operation) Log (WAL)

[Write Ahead Log](Write-Ahead-Log.md), WAL from now, is used to restore storage data after a non-soft shutdown:
- Hard kill of the OrientDB process
- Crash/Failure of the Java Virtual Machine that runs OrientDB
- Crash/Failure of the Operating System that is hosting OrientDB

All the operations on **plocal** components are logged in WAL before they are performed on these components. WAL is append only data structure, you can think about it like a list of records which contains information about operations performed on storage components.

### WAL flush
WAL content is flushed to the disk on these events:
- every 1 second in background thread (flush interval can be changed in **storage.wal.commitTimeout** configuration property)
- synchronously if the amount of RAM used by WAL exceeds 65Mb (can be changed in **storage.wal.cacheSize** configuration property).

As result if OrientDB crashes, all data changes done during <=1 second interval before crash will be lost. This is the trade off between performance and durability.

### Put the WAL to a separate disk
It's strongly recommended to store WAL records on separate disk than the disk used to store the DB content. In this way data I/O operations will not be interrupted by WAL I/O operations. This can be done by setting the **storage.wal.path** property to the folder where storage WAL files will be placed.

### How Indexes use WAL?
Indexes can work with WAL in 2 modes:
- **ROLLBACK_ONLY** (default mode) and
- **FULL**

In ROLLBACK_ONLY mode only data are needed to rollback transactions are stored. WAL records can not be used to restore index content after crash, in such case automatic indexes are rebuild. In FULL mode indexes can be restored after DB crash without rebuild. You can change index durability mode by setting the property **index.txMode**.

You can find more details about WAL **[here](Write-Ahead-Log.md)**.

## File types
PLocal storage writes the database on file system using different files. Below all the extensions:

- **.cpm**, contains the mapping between real physical positions and cluster positions. If you delete record, the tombstone is placed here. Each tombstone consumes about 12 bytes
- **.pcl**, data file
- **.sbt**, is index file
- **.wal** and **.wmr**, are Journal Write Ahead (operation) Log files
- **.cm**, is the mapping between file id and real file name (is used internally)
- **.irs**, is the RID set file for not unique index

## How it works (Internal)
Basically paginated storage is nothing more than 2-level disk cache which works together with write ahead log.

Every file is spitted on pages, and each file operation is atomic at page level. 2-level disk cache allows:

1. Cache frequently accessed pages in memory.
2. Automatically separate pages which are rarely accessed from frequently accessed and rid off the first from cache memory.
3. Minimize amount of disk head seeks during data writes.
4. In case of low or middle write data load allows to mitigate pauses are needed to write data to the disk by flushing all changed or newly added pages to the disk in background thread.
5. Works together with WAL to make any set changes on single page look like atomic operation.

2-level cache itself consist of **Read Cache** (implementation is based on 2Q cache algorithm) and **Write cache* (implementation is based on WOW cache algorithm).

Typical set of operations are needed to work with any file looks like following:

1. Open file using OReadWriteDiskCache#openFile operation and get id of open file. If files does not exist it will be automatically created. Id of file is stored in special meta data file and always will belong to given file till it will be deleted.
2. Allocate new page OReadWriteDiskCache#allocateNewPage or load existing one ORreadWriteDiskCache#load into off heap memory.
3. Retrieve pointer to the allocated area of off-heap memory OCacheEntry#getCachePointer().
4. If you plan to change page data acquire write lock or read lock if you read data and your single file page is shared across several data structures. Write lock must be acquired whether  single page are used between several data structures or not. Write lock is needed to prevent flush of inconsistent pages to the disk inside of background “data flush” thread of write cache. OCachePointer#acquireExclusiveLock.
5. Update/read data  in off heap memory.
6. Release write lock if needed.  OCachePointer#releaseExclusiveLock.
7. Mark page as dirty if you changed page data. It will allow write cache to flush pages which are really changed OCacheEntry#markDirty.
8. Push record back to the disk cache, in other words indicate cache that you do not use this page any more so it can be safely evicted from the memory to make room to other pages OReadWriteDiskCache#release.

### So what is going on underneath when we load and release pages?

When we load page at first Read Cache looks it in one of LRU lists. There are two of them for data which are accessed several times and then not accessed for very long period of item (it consumes 25% of memory) and data which are accessed frequently for long period of time (it consumes 75% of memory).

If page is absent in LRU queues, then Read Cache asks to the Write Cache to load data from the disk.

If we are lucky and pages which are queued to flush are still in Write Queue of Write Cache it will be retrieved from there or otherwise Write Cache will load data from file on the disk.

When data will be read from file by Write Cache, it will be put in LRU queue which contains “short living” pages. Eventually, if this pages will be accessed frequently during long time interval, loaded page will be moved to the LRU of “long living” pages.

When we release page and this page is marked as dirty this page is put into the Write Cache which adds it to the Write Queue. Write Queue can be considered as ring buffer where all the pages are sorted by its position on the disk. This trick allows to minimize disk head movements during pages flush. What is more interesting that pages are always flushed in background in “background flush” thread. This approach allows to mitigate I/O bottleneck if we have enough RAM to work in memory only and flush data in background.

So it was about how disk cache works. But how we achieve durability of changes on page level and what is more interesting on the level when we work with complex data structures like Trees or Hash Maps (these data structures are used in indexes).

If we look back on set of operations which we perform to manipulate file data you see that step 5 does not contains any references to OrientDB API. That is because there are two ways to work with off heap page durable and not durable.

So simple (not durable way) is to work with methods of direct memory pointer com.orientechnologies.common.directmemory.ODirectMemoryPointer(setLong/getLong, setInt/getInt and so on).
If you would like to make all changes in your data structures durable you should not work with direct memory pointer but should create component which will present part of your data structure and extend it from com.orientechnologies.orient.core.storage.impl.local.paginated.ODurablePage class. This class has similar methods for manipulation of data in off heap page but also it tracks all changes are done to the page and we can always return diff between old/new states of page using com.orientechnologies.orient.core.storage.impl.local.paginated.ODurablePage#getPageChanges method. Also this class allows to apply given diff to the old/new snapshot of given pages to repeat/revert (restoreChanges()/revertChanges()) changes are done for this page.

