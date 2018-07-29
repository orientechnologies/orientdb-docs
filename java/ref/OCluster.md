---
search:
   keywords: ['java', 'ocluster', 'cluster']
---

# OCluster

This class provides an interface for interacting with clusters.

## Managing Database Clusters

Clusters in OrientDB are where the server actually stores data, whether on the physical disk or in memory.  They are comparable to the partition in Relational databases.  Using the `OCluster` interface, you can operate directly on clusters from your application.

```java
import com.orientechnologies.orient.core.storage.OCluster;
```

## Methods

| Method | Return Type | Description |
|---|---|---|
| [**`close()`**](OCluster/close.md) | `void` | Closes the cluster |
| [**`delete()`**](OCluster/delete.md) | `void` | Removes the cluster |
| [**`deleteRecord()`**](OCluster/deleteRecord.md) | `boolean` | Removes record from cluster |
| [**`exists()`**](OCluster/exists.md) | `boolean` | Indicates whether the cluster exists |
| [**`getFileName()`**](OCluster/getFileName.md) | `String` | Retrieves filename for the cluster |
| [**`getFirstPosition()`**](OCluster/getFirstPosition.md) | `long` | Retrieves the position of the first record in the cluster |
| [**`getId()`**](OCluster/getId.md) | `int` | Retrieves the Cluster ID |
| [**`getLastPosition()`**](OCluster/getLastPosition.md) | `long` | Retrieves the position of the last record in the cluster |
| [**`getName()`**](OCluster/getName.md) | `String` | Retrieves the logical name of the cluster |
| [**`getNextPosition()`**](OCluster/getNextPosition.md) | `long` | Retrieves the position of the next record in the cluster |
| [**`getRecordSize()`**](OCluster/getRecordsSize.md) | `long` | Retrieves the size of the records in bytes contained in this cluster |
| [**`getTombstonesCount()`**](OCluster/getTombstonesCount.md) | `long` | Retrieves the number of hidden records in the cluster |
| [**`hideRecord()`**](OCluster/hideRecord.md) | `boolean` | Hides the given record from queries |
| [**`open()`**](OCluster/open.md) | `void` | Opens the cluster |
| [**`truncate()`**](OCluster/truncate.md) | `void` | Truncates the cluster |
| [**`updateRecord()`**](OCluster/updateRecord.md) | `void` | Updates the givne record |

