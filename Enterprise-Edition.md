---
search:
   keywords: ['enterprise', 'enterprise edition']
---

# Enterprise Edition

This is the main guide on using <b>OrientDB Enterprise Edition</b>. For more information look at [OrientDB Enterprise Edition](http://orientdb.com/enterprise.htm).

Enterprise Edition is a commercial product developed by OrientDB Ltd, the same company that lead the development of OrientDB Community Edition. [Download now the 45-days trial](http://orientdb.com/orientdb-enterprise/#matrix).

OrientDB Enterprise Edition is designed specifically for applications seeking a scalable, robust, and secure multi-model database. Its main goal is to save time and money on your OrientDB investment by reducing risk, cost, effort, and time invested in a business critical application. It includes all Community features plus professional enterprise tools such as support for [Data Centers](Data-Centers.md), [Query Profiler](Studio-Query-Profiler.md), [Distributed Clustering](Studio-Cluster-Management.md) configuration, [Auditing Tools](Studio-Auditing.md), [Metrics recording](Studio-Server-Management.md), Live Monitor with configurable Alerts, [Non-Stop Incremental Backups](Studio-Backup-Management.md), [Teleporter](Studio-Teleporter.md) to import data from any Relational DBMS.


### Installation
The installation procedure is the same as for the [Community Edition](Tutorial-Installation.md) just use the package you downloaded after registering on the web site.

At run-time, the Enterprise edition logs this message:

```
2016-08-04 09:38:26:589 INFO  ***************************************************************************** [OEnterpriseAgent]
2016-08-04 09:38:26:589 INFO  *                     ORIENTDB  -  ENTERPRISE EDITION                       * [OEnterpriseAgent]
2016-08-04 09:38:26:589 INFO  ***************************************************************************** [OEnterpriseAgent]
2016-08-04 09:38:26:589 INFO  * If you are in Production or Test, you must purchase a commercial license. * [OEnterpriseAgent]
2016-08-04 09:38:26:589 INFO  * For more information look at: http://orientdb.com/orientdb-enterprise/    * [OEnterpriseAgent]
2016-08-04 09:38:26:590 INFO  ***************************************************************************** [OEnterpriseAgent]
```

### Upgrade from 2.1.x or previous

Before v2.2, the Enterprise Edition front end was the **Workbench** application. Starting from v2.2, the Workbench has been merged into [Studio](Studio-Home-page.md). When Studio runs on an Enterprise Edition, it enables the additional features automatically. Furthermore while the Workbench was a separate application that was connected to the servers, with the new Studio Enterprise, every server is a peer of the distributed cluster. You can configure any server by connecting to one of the servers in the distributed cluster.

Explore the Enterprise Edition features:

* [Dashboard](Studio-Dashboard.md)
* [Server Management](Studio-Server-Management.md)
* [Cluster Management](Studio-Cluster-Management.md)
* [Query Profiler](Studio-Query-Profiler.md)
* [Backup Management](Studio-Backup-Management.md)
* [Studio Auditing](Studio-Auditing.md)
* [Teleporter](Studio-Teleporter.md)
* [Data Centers](Data-Centers.md) 

