# Storages

Any OrientDB database relies on a Storage. OrientDB supports 4 storage types:
- **[plocal](Paginated-Local-Storage.md)**, persistent disk-based, where the access is made in the same JVM process
- **remote**, by using the network to access a remote storage
- **[memory](Memory-storage.md)**, all data remains in memory
- **[local](Local-Storage.md)**, deprecated, it's the first version of disk based storage, but has been replaced by **plocal**

A Storage is composed of multiple [Clusters](Concepts.md#Cluster).
