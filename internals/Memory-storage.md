---
search:
   keywords: ['storage', 'memory']
---

# Memory Storage

Memory Storage is local and endures **only as long as the JVM is running**.
For the application programmer, it is identical in use to [Paginated Local Storage](Paginated-Local-Storage.md).
Transactions remain atomic, consistent and isolated (but are not durable).

Memory is the fastest choice for tasks where data are read from an external source,
and where the results are provided without needing to persist the graph itself.
It is also a good choice for certain test scenarios, since an abrupt exit leaves no debris on the disk.

A database using memory storage is designated by a URL of the form ``memory:<path>``,
for example ``memory:test``.
A hierarchical path is allowed, for example ``memory:subdir/test``.

The memory available for the database is *direct memory* allocated by the JVM as needed. In the case of a ``plocal:`` database, memory like this provides a cache whose pages are loaded from or flushed to pages files on disk. In the case of a ``memory:`` database, these direct memory pages are the ultimate storage. The database is allowed to take up more memory than there is physical RAM, as the JVM will allocate more from swap. Total size is limited by the ``-XX:MaxDirectMemorySize`` JVM option.
