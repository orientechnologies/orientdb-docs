# Distributed Architecture Plugin

Java class: <code>com.orientechnologies.orient.server.hazelcast.OHazelcastPlugin</code>

## Introduction

This is part of [Distributed Architecture](Distributed-Architecture.md). Configure a distributed clustered architecture. This task is configured as a [Server handler](DB-Server.md#handlers). The task can be configured easily by changing these parameters:
- **enabled**: Enable the plugin: `true` to enable, `false` to disable it.
- **configuration.hazelcast**: The location of the [Hazelcast configuration file](Distributed-Configuration.md#hazelcast-configuration) (`hazelcast.xml`).
- **alias**: An alias for the current node within the cluster name. Default value is the IP address and port for OrientDB on this node.
- **configuration.db.default**: The location of a file that describes, using JSON syntax, the synchronization [configuration](Distributed-Configuration.md#default-distributed-db-configjson) of the various clusters in the database.

Default configuration in [orientdb-dserver-config.xml](Distributed-Configuration.md#orientdb-dserver-configxml):

```xml
   <handler class="com.orientechnologies.orient.server.hazelcast.OHazelcastPlugin">
      <parameters>
         <!-- <parameter name="alias" value="europe1" /> -->
         <parameter name="enabled" value="true" />
         <parameter name="configuration.db.default" value="${ORIENTDB_HOME}/config/default-distributed-db-config.json" />
         <parameter name="configuration.hazelcast" value="${ORIENTDB_HOME}/config/hazelcast.xml" />
      </parameters>
   </handler>
```