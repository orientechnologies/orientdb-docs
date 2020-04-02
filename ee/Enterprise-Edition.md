---
search:
   keywords: ['enterprise', 'enterprise edition']
---

# Enterprise Edition

This is the main guide on using <b>OrientDB Enterprise Edition</b>. For more information look at [OrientDB Enterprise Edition](http://orientdb.com/enterprise.htm).

Enterprise Edition is a commercial product developed by OrientDB Ltd, the same company that lead the development of OrientDB Community Edition. [Download now the 45-days trial](http://orientdb.com/orientdb-enterprise/#matrix).

OrientDB Enterprise Edition is designed specifically for applications seeking a scalable, robust, and secure multi-model database. Its main goal is to save time and money on your OrientDB investment by reducing risk, cost, effort, and time invested in a business critical application. It includes all Community features plus professional enterprise tools such as support for [Query Profiler](./Server-Profiler.md), [Distributed Clustering](./Cluster-Management.md) configuration, [Auditing Tools](./Security.md), [Metrics recording](../Server-Management.md), [Non-Stop Incremental Backups](./Backup-Management.md), [Teleporter](./Teleporter.md) to import data from any Relational DBMS.


### Installation

Enterprise Edition is an additional package which can be installed in the [Community Edition](../gettingstarted/Tutorial-Installation.md). Download the Enterprise package after registering on the web site and install it in the `${ORIENTDB_HOME}/plugins` folder.

At run-time, the Enterprise edition logs this message:

```
2016-08-04 09:38:26:589 INFO  ***************************************************************************** [OEnterpriseAgent]
2016-08-04 09:38:26:589 INFO  *                     ORIENTDB  -  ENTERPRISE EDITION                       * [OEnterpriseAgent]
2016-08-04 09:38:26:589 INFO  ***************************************************************************** [OEnterpriseAgent]
2016-08-04 09:38:26:589 INFO  * If you are in Production or Test, you must purchase a commercial license. * [OEnterpriseAgent]
2016-08-04 09:38:26:589 INFO  * For more information look at: http://orientdb.com/orientdb-enterprise/    * [OEnterpriseAgent]
2016-08-04 09:38:26:590 INFO  ***************************************************************************** [OEnterpriseAgent]
```

## EE Features

Explore the Enterprise Edition features:

* [Dashboard](./Dashboard.md)
* [Server Management](./Server-Management.md)
* [Cluster Management](./Cluster-Management.md)
* [Backup Management](./Backup-Management.md)
* [Server Profiler](./Server-Profiler.md)
* [Security](./Security.md)
* [Teleporter](./Teleporter.md)
* [Neo4j to OrientDB Importer](./Neo4j-Importer.md)
* [Settings](./Settings.md)

See here for the documentation of the new [Metrics](./Profiler.md) module.


