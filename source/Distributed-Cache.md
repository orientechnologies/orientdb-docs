# Distributed Cache

OrientDB has own more [Cache](Caching.md) levels. When OrientDB runs in [Distributed-Architecture](Distributed-Architecture.md), each server has own cache. All the caches in each server are independent.

### Distributed 2nd Level cache

You can also have a shared cache among servers, by enabling the Hazelcast's 2nd level cache. To enable it set the **cache.level2.impl** property in [orientdb-dserver-config.xml](Distributed-Configuration.md#orientdb-dserver-configxml) file with value **com.orientechnologies.orient.server.hazelcast.OHazelcastCache**:

Note that this will slow down massive insertion but will improve query and lookup operations.

Example in **[orientdb-dserver-config.xml](Distributed-Configuration.md#orientdb-dserver-configxml)** file:
```xml
...
<properties>
  <!-- Uses the Hazelcast distributed cache as 2nd level cache -->
  <entry name="cache.level2.impl" value="com.orientechnologies.orient.server.hazelcast.OHazelcastCache" />
</properties>
```
