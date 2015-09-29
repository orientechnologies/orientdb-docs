# Local Storage (Not more available since 2.0)

Local storage is the first version of disk-based storage engine, but has been replaced by [plocal](Paginated-Local-Storage.md). Don't create new databases using **local**, but rather [plocal](Paginated-Local-Storage.md). Local storage has been kept only for compatibility purpose.

A **local** storage is composed of multiple [Cluster](#Cluster) and [Data Segments](#Data_Segment).

![](http://www.orientdb.org/images/orientdb-storage.png)


## <a name="wiki-Local_Physical_Cluster">Local Physical Cluster</a>

The cluster is mapped 1-by-2 to files in the underlying File System. The local physical cluster uses two or more files: One or more files with extension "ocl" (OrientDB Cluster) and only one file with the extension "och" (OrientDB Cluster Holes).

For example, if you create the "Person" cluster, the following files will be created in the folder that contains your database:
- person.0.ocl
- person.och

The first file contains the pointers to the record content in ODA (OrientDB Data Segment). The '0' in the name indicates that more successive data files can be created for this cluster. You can split a physical cluster into multiple real files. This behavior depends on your configuration. When a cluster file is full, a new file will be used.

The second file is the "Hole" file that stores the holes in the cluster caused by deleted data.

**NOTE (again, but very important): You can move real files in your file system only by using the OrientDB APIs.**


# <a name="wiki-Data_Segment">Data Segment</a>

OrientDB uses **data segments** to store the record content. The data segment behaves similar to the physical cluster files: it uses two or more files. One or multiple files with the extension "oda" (OrientDB Data) and only one file with the extension "odh" (OrientDB Data Holes).

By default OrientDB creates the first data segment named "default". In the folder that contains your database you will find the following files:
- default.0.oda
- default.odh

The first file is the one that contains the real data. The '0' in the name indicates that more successive data files can be created for this cluster. You can split a data segment into multiple real files. This behavior depends on your configuration. When a data segment file is full, a new file will be used.

**NOTE (again, but it can't be said too many times): You can move real files in your file system only by using the OrientDB APIs.**

Interaction between components: load record use case:

![](http://www.orientdb.org/images/orientdb-loadrecord.png)
