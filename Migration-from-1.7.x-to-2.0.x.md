# Migration from 1.7.x to 2.0.x
_____

Databases created with release 1.7.x are compatible with 2.0, so you don't have to export/import the database like in the previous releases. Check your database directory: if you have a file *.wal, delete it before migration.

## Use the new binary serialization
To use the new binary protocol you have to export and reimport the database into a new one. This will boost up your database performance of about +20% against old database.

To export and reimport your database follow these steps:

1) Stop any OrientDB server running

2) Open a new shell (Linux/Mac) or a Command Prompt (Windows)

2) Export the database using the console. Move into the directory where you've installed OrientDB 2.0 and execute the following commands:

    > cd bin
    > ./console.sh (or bin/console.bat under Windows)
    orientdb> CONNECT plocal:/temp/mydb admin admin
    orientdb> EXPORT DATABASE /temp/mydb.json.gz
    orientdb> DISCONNECT
    orientdb> CREATE DATABASE plocal:/temp/newdb
    orientdb> IMPORT DATABASE /temp/mydb.json.gz

Now your new database is: /temp/newdb.

## API changes

### ODocument pin() and unpin() methods
We removed pin() and unpin() methods to force the cache behavior.

### ODocument protecting of internal methods
We have hidden some methods considered internal to avoid users call them. However, if your usage of OrientDB is quite advanced and you still need them, you can access from Internal helper classes. Please still consider them as internals and could change in the future. Below the main ones:
- ORecordAbstract.addListener(), uses ORecordListenerManager.addListener() instead

### ODatabaseRecord.getStorage()
We moved getStorage() method to ODatabaseRecordInternal.

### ODatabaseDocumentPool
We replaced ODatabaseDocumentPool Java class (now deprecated) with the new, more efficient com.orientechnologies.orient.core.db.OPartitionedDatabasePool.

### Caches
We completely removed Level2 cache. Now only Level1 and Storage DiskCache are used. This change should be transparent with code that run on previous versions, unless you enable/disable Level2 cache in your code.

Furthermore it's not possible anymore to disable Cache, so method `setEnable()` has been removed.

#### Changes

|Context|1.7.x|2.0.x|
|----|----------|-------------|
|API|ODatabaseRecord.getLevel1Cache()|ODatabaseRecord.getLocalCache()|
|API|ODatabaseRecord.getLevel2Cache()|Not available|
|Configuration|OGlobalConfiguration.CACHE_LEVEL1_ENABLED|OGlobalConfiguration.CACHE_LOCAL_ENABLED|
|Configuration|OGlobalConfiguration.CACHE_LEVEL2_ENABLED|Not available|

### No more LOCAL engine
We completely dropped the long deprecated [LOCAL Storage](Local-Storage.md). If your database were created using "[LOCAL:](Local-Storage.md)" then you have to export it with the version you were using, then import it in a fresh new database created with OrientDB 2.0.

## Server
### First run ask for root password

At first run, OrientDB asks for the root's password. Leave it blank to auto generate it (like with 1.7.x). This is the message:

```
+----------------------------------------------------+
|          WARNING: FIRST RUN CONFIGURATION          |
+----------------------------------------------------+
| This is the first time the server is running.      |
| Please type a password of your choice for the      |
| 'root' user or leave it blank to auto-generate it. |
+----------------------------------------------------+

Root password [BLANK=auto generate it]: _
```

If you set the system setting or environment variable `ORIENTDB_ROOT_PASSWORD`, then its value will be taken as root password. If it's defined, but empty, a password will be automatically generated.

## Distributed
### First run ask for node name

At first run as distributed, OrientDB asks for the node name. Leave it blank to auto generate it (like with 1.7.x). This is the message:

```
+----------------------------------------------------+
|    WARNING: FIRST DISTRIBUTED RUN CONFIGURATION    |
+----------------------------------------------------+
| This is the first time that the server is running  |
| as distributed. Please type the name you want      |
| to assign to the current server node.              |
+----------------------------------------------------+

Node name [BLANK=auto generate it]: _
```

If you set the system setting or environment variable `ORIENTDB_NODE_NAME`, then its value will be taken as node name. If it's defined, but empty, a name will be automatically generated.


### Multi-Master replication

With OrientDB 2.0 each record cluster selects assigns the first server node in the `servers` list node as master for insertion only. In 99% of the cases you insert per class, not per cluster. When you work per class, OrientDB auto-select the cluster where the local node is the master. In this way we completely avoid conflicts (like in 1.7.x). 

Example of configuration with 2 nodes replicated (no sharding):

    INSERT INTO Customer (name, surname) VALUES ('Jay', 'Miner')

If you execute this command against a node1, OrientDB will assign the cluster-id where node1 is master, i.e. #13:232. With node2 would be different: it couldn't never be #13. 

For more information look at: http://www.orientechnologies.com/docs/last/orientdb.wiki/Distributed-Sharding.html.

### Asynchronous replication

OrientDB 2.0 supports configurable execution mode through the new variable **`executionMode`**. It can be:
- `undefined`, the default, means synchronous
- `synchronous`, to work in synchronous mode
- `asynchronous`, to work in asynchronous mode 

```json
{
    "autoDeploy": true,
    "hotAlignment": false,
    "executionMode": "undefined",
    "readQuorum": 1,
    "writeQuorum": 2,
    "failureAvailableNodesLessQuorum": false,
    "readYourWrites": true,
    "clusters": {
        "internal": {
        },
        "index": {
        },
        "*": {
            "servers" : [ "<NEW_NODE>" ]
        }
    }
}
```

Set to "asynchronous" to speed up the distributed replication.

## Graph API

### Multi-threading
Starting from OrientDB 2.0, instances of both classes OrientGraph and OrientGraphNoTx can't be shared across threads. Create and destroy instances from the same thread.

### Edge collections
OrientDB 2.0 disabled the auto scale of edge. In 1.7.x, if a vertex had 1 edge only, a LINK was used. As soon as a new edge is added the LINK is auto scaled to a LINKSET to host 2 edges. If you want this setting back you have to call these two methods on graph instance (or OrientGraphFactory before to get a Graph instance):

    graph.setAutoScaleEdgeType(true);
    graph.setEdgeContainerEmbedded2TreeThreshold(40);
