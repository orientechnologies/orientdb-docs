---
search:
   keywords: ['server', 'plugin', 'syslog', 'syslog plugin']
---

# SysLog Plugin

Java class implementation:
```java
com.orientechnologies.security.syslog.ODefaultSyslog
```
Available since: **v. 2.2.0**.

## Introduction

Allows sending event logs to the [Operating System's SYSLOG daemon](https://en.wikipedia.org/wiki/Syslog).

## Configuration

This plugin is configured as a [Server plugin](../DB-Server.md#handlers). The plugin can be easily configured by changing parameters in the `orientdb-server-config.xml` file.:

<table>
  <tr><th>Name</th><th>Description</th><th>Type</th><th>Example</th><th>Since</th></tr>
  <tr><td>enabled</td><td>true to turn on, false (default) is turned off</td><td>boolean</td><td>true</td><td>2.2.0</td></tr>
  <tr><td>debug</td><td>Enables debug mode</td><td>boolean</td><td>false</td><td>2.2.0</td></tr>
  <tr><td>hostname</td><td>The hostname of the syslog daemon</td><td>string</td><td>localhost</td><td>2.2.0</td></tr>
  <tr><td>port</td><td>The UDP port of the syslog daemon</td><td>integer</td><td>514</td><td>2.2.0</td></tr>
  <tr><td>appName</td><td>The name of the application submitting the events to SysLog</td><td>string</td><td>OrientDB</td><td>2.2.0</td></tr>
</table>

Default configuration in `orientdb-server-config.xml`. Example:
```xml
<!-- SYS LOG CONNECTOR, TO TURN ON SET THE 'ENABLED' PARAMETER TO 'true' -->
<handler class="com.orientechnologies.security.syslog.ODefaultSyslog">
    <parameters>
        <parameter name="enabled" value="true"/>
        <parameter name="debug" value="false"/>
        <parameter name="hostname" value="localhost"/>
        <parameter name="port" value="514"/>
        <parameter name="appName" value="OrientDB"/>
    </parameters>
</handler>
```

## Usage

Look at [Security Config](../Security-Config.md).

