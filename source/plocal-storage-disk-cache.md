# PLocal Disk-Cache

OrientDB Disk cache consists of two separate cache components that work together:
- **Read Cache**, based on [2Q](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.54.392) cache algorithm
- **Write Cache**, based on [WOW](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.108.8729) cache algorithm

Starting from v2.1, OrientDB exposes internal metrics through [JMX Beans](JMX.md). Use this information to track and profile OrientDB.

## Read Cache

It contains the following queues:
- **a1**, as FIFO queue for pages which were not in the read cache and accessed for the first time
- **am**, as FIFO queue for the hot pages (pages which are accessed frequently during db lifetime). The most used pages stored in **a1** becomes "hot pages" and are moved into the **am** queue.

### a1 Queue
a1 queue is split in two queues:
- **a1in** that contains pointers to the pages are cached in memory
- **a1out** that contains pointers to the pages which were in **a1in**, but was not accessed for some time and were removed from RAM. **a1out** contains pointers to the pages located on the disk, not in RAM.

### Loading a page
When a page is read for the first time, it's loaded from the disk and put in the **a1in** queue. If there isn't enough space in RAM, the page is moved to **a1out** queue.

If the same page is accessed again, then:
  1. if it is in **a1in** queue, nothing
  2. if it is in **a1out** queue, the page is supposed to be a "hot page" (that is page which is accessed several times, but doesn't follow the pattern when the page is accessed several times for short interval, and then not accessed at all) we put it in **am** queue
  3. if it is in **am** queue, we put the page at the top of am queue

### Queue sizes
By default this is the configuration of queues:
- **a1in** queue is 25% of Read Cache size
- **a1out** queue is 50% of Read Cache size
- **am** is 75% of Read Cache size.

When OrientDB starts, both caches are empty, so all the accessed pages are put in **a1in** queue, and the size of this queue is 100% of the size of the Read Cache.

But then, when there is no more room for new pages in **a1in**, the old pages are moved from **a1in** to **a1out**. Eventually when **a1out** contains requested pages we need room for **am** queue pages, so once again we move pages from **a1in** queue to **a1out** queue, **a1in** queue is truncated till it is reached 25% size of read cache.

To make more clear how RAM and pages are distributed through queues lets look at example.
Lets suppose we have cache which should cache in RAM 4 pages, and we have 8 pages stored on disk (which have indexes from 0 till 7 accordingly).

When we start database server all queues contain 0 pages:

* am - []
* a1in - []
* a1out - []

Then we read first 4 pages from the disk.
So we have:

* am - []
* a1in - [3, 2, 1, 0]
* a1out - []

Then we read 5-th page from the disk and then 6-th , because only 4 pages can be fit into RAM we remove the last pages with indexes 0 and 1, free memory which is consumed by those pages and put them in a1out.
So we have:

* am - []
* a1in - [5, 4, 3, 2]
* a1out - [1, 0]

lets read pages with indexes from 6 till 7 (last 2 pages) but a1out can contain only 2 pages (50% of cache size) so the first pages will be removed from o1out.
We have here:

* am - []
* a1in - [7, 6, 5, 4]
* a1out - [3, 2]

Then if we will read pages 2, 3 then we mark them (obviously) as hot pages and we put them in am queue but we do not have enough memory for these pages, so we remove pages 5 and 4 from a1in queue and free memory which they consumed.
Here we have:

* am - [3, 2]
* a1in - [7, 6]
* a1out - [5, 4]

Then we read page 4  because we read it several times during long time interval it is hot page and we put it in am queue.
So we have:

* am - [4, 3, 5]
* a1in - [7]
* a1out - [6, 5]

We reached state when queues can not grow any more so we reached stable, from point of view of memory distribution, state.

This is the used algorithm in pseudo code:
<pre>
On accessing a page X
begin:
 if X is in Am then
   move X to the head of Am
else if (X is in A1out) then
 removeColdestPageIfNeeded
 add X to the head of Am
else if (X is in A1in)
 // do nothing
else
 removeColdestPageIfNeeded
 add X to the head of A1in
end if
end

removeColdestPageIfNeeded
begin
 if there is enough RAM do nothing
 else if( A1in.size > A1inMaxSize)
  free page out the tail of A1in, call it Y
  add identifier of Y to the head of A1out
 if(A1out.size > A1OutMaxSize)
  remove page from the tail of Alout
 end if
 else
  remove page out the tail of Am
  // do not put it on A1out; it hasn’t been
  // accessed for a while
 end if
end
</pre>

## Write cache

The main target of the write cache is to eliminate disk I/O overhead, by using the following approaches:

1. All the pages are grouped by 4 adjacent pages (group 0 contains pages from 0 to 3, group 1 contains pages from 4 to 7, etc. ). Groups are sorted by position on the disk. Groups are flushed in sorted order, in such way we reduce the random I/O disk head seek overhead. Group's container is implemented as SortedMap: when we reach the end of the map we start again from the beginning. You can think about this data structure as a "ring buffer"
2. All the groups have "recency bit", this bit is set when group is changed. It is needed to avoid to flush  pages that are updated too often, it will be wasting of I/O time
3. Groups are continuously flushed by background thread, so until there is enough free memory, all data operations do not suffer of I/O overhead because all operations are performed in memory

Below the pseudo code for write cache algorithms:

Add changed page in cache:
<pre>
begin
 try to find page in page group.
 if such page exist
  replace page in page group
  set group's "recency bit" to true
 end if
 else
  add page group
  set group's "recency bit" to true
 end if
end
</pre>

On periodical background flush
<pre>
begin
 calculate amount of groups to flush
 start from group next to flushed in previous flush iteration
 set "force sync" flag to false

 for each group
  if "recency bit" set to true and "force sync" set to false
   set "recency bit" to false
  else
   flush pages in group
   remove group from ring buffer
  end if
 end for

  if we need to flush more than one group and not all of them are flushed repeat "flush loop" with "force sync" flag set to true.
end
</pre>

The collection of groups to flush is calculated in following way:

1. if amount of RAM consumed by pages is less than 80%, then 1 group is flushed.
2. if amount of RAM consumed by pages is more than 80%, then 20% of groups is flushed.
3. if amount of RAM consumed by pages is more than 90%, then 40% of groups is flushed.

## Interaction between Read and Write Caches

By default the maximum size of Read Cache is 70% of cache RAM and 30% for Write Cache.

When a page is requested, the Read Cache looks into the cached pages. If it's not present, the Read Cache requests page from the Write Cache. Write Cache looks for the page inside the Ring Buffer: if it is absent, it reads the page from the disk and returns it directly to the Read Cache without caching it inside of Write Cache Ring Buffer.

### Implementation details
Page which is used by storage data structure (such as cluster or index) can not be evicted (removed from memory) so each page pointer also has "usage counter" when page is requested by cache user, "usage counter" is incremented and decremented when page is released. So removeColdestPageIfNeeded() method does not remove tail page, but removes page closest to tail which usage counter is 0, if such pages do not exit either exception is thrown or cache size is automatically increased and warning message is added to server log (default) (it is controlled by properties **server.cache.2q.increaseOnDemand** and **server.cache.2q.increaseStep**, the last one is amount of percent of RAM from original size on which cache size will be increased).

When a page is changed, the cache page pointer (data structure which is called OCacheEntry) is marked as dirty by cache user before release. If cache page is dirty it is put in write cache by read cache during call of OReadWriteDiskCache#release() method. Strictly speaking memory content of page is not copied, it will be too  slow, but pointer to the page is passed. This pointer (OCachePointer) tracks amount of referents if no one references this pointer, it frees referenced page.

Obviously caches work in multithreaded environment, so to prevent data inconsistencies each page is not accessed directly. Read cache returns data structure which is called cache pointer. This pointer contains pointer to the page and lock object. Cache user should acquire read or write lock before it will use this page. The same read lock is acquired by write cache for each page in group before flush, so inconsistent data will not be flushed to the disk. There is interesting nuance here, write cache tries to acquire read lock and if it is used by cache user it will not wait but will try to flush other group.
