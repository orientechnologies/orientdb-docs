# HA Upgrading

This is the guide if you're running in High Availability (HA) mode and you want to upgrade OrientDB Servers to a new version.

## Upgrade to a more recent hotfix version
Unless is expressily mentioned in the release note, the compatibility between hotfix of the same version (for example fro 2.1.12 to 2.1.16) allows you to upgrade your OrientDB servers one by one without stopping the cluster.

## Upgrade to a minor or major
OrientDB doesn't guarantee the compatibility between minor and major versions. The main reasons are the usage of Hazelcast for the discovery which doesn't support binary compatibility between versions. 

### Cold Upgrade
The simplest way to upgrade is stopping the running cluster of OrientDB servers, upgrade all of them, and restart the servers. OrientDB guarantees the compatibility of the database format, so there is no need to export/reimport the database.

### Hot Upgrade
In order to achieve a full hot upgrade, you should run a separate cluster of servers equipped with the new version of OrientDB and then switch the connections to the new cluster.

Steps:
1. Configure a cluster of servers equipped with the newer version of OrientDB. We suggest of using the same number of servers of the running cluster.
1. Before starting the servers, change the cluster name in [hazelcast.xml](Distributed-Configuration.md) file using a different name than what you used for the current cluster. For example if your running cluster has just "orientdb" and you want to upgrade to OrientDB v2.2, you could call the cluster name "orientdb_v22". Example:
   ```xml
   <group>
     <name>orientdb_v22</name>
     <password>mynewpassword</password>
  </group>
  ```
1. TBC

#### HTTP connections
In case of HTTP connections, you have to configure a proxy between your client and OrientDB servers. In this way the proxy cabe configured to redirect the requests to the new cluster when is ready.

#### Binary connections
In case your application is using a binary driver the behavior could be different, based on the driver support for auto-reconnect in case of failure. The following driver supports it:
- Java driver
- Node.js driver

