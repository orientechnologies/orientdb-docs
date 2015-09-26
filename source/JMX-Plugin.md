# JMX plugin

Java class implementation:
```java
com.orientechnologies.orient.server.handler.OJMXPlugin
```
Available since: **v. 1.2.0**.

# Introduction

Expose the OrientDB server configuration through JMX protocol. This task is configured as a [Server handler](DB-Server.md#handlers). The task can be configured in easy way by changing parameters:
- **enabled**: true to turn on, false (default) is turned off
- **profilerManaged**: manage the [Profiler](Profiler.md) instance

Default configuration in orientdb-server-config.xml

```xml
<!-- JMX SERVER, TO TURN ON SET THE 'ENABLED' PARAMETER TO 'true' -->
<handler class="com.orientechnologies.orient.server.handler.OJMXPlugin">
  <parameters>
    <parameter name="enabled" value="false" />
    <parameter name="profilerManaged" value="true" />
  </parameters>
</handler>
```
