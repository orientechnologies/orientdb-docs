# SysLog Plugin

Java class implementation:
```java
com.orientechnologies.security.syslog.ODefaultSyslog
```
Available since: **v. 2.2.0**.

## Introduction

Allows to send logs to the [Operative System's SYSLOG deamon](https://en.wikipedia.org/wiki/Syslog).

## Configuration

This plugin is configured as a [Server plugin](DB-Server.md#handlers). The plugin can be configured in easy way by changing parameters:

<table>
  <tr><th>Name</th><th>Description</th><th>Type</th><th>Example</th><th>Since</th></tr>
  <tr><td>enabled</td><td>true to turn on, false (default) is turned off</td><td>boolean</td><td>true</td><td>2.2.0</td></tr>
  <tr><td>debug</td><td>Enable the debug mode</td><td>boolean</td><td>false</td><td>2.2.0</td></tr>
  <tr><td>hostname</td><td>Hostname where the syslog is installed</td><td>string</td><td>localhost</td><td>2.2.0</td></tr>
  <tr><td>port</td><td>UDP port</td><td>integer</td><td>514</td><td>2.2.0</td></tr>
  <tr><td>appName</td><td>Name of the application in SysLog logs</td><td>string</td><td>OrientDB</td><td>2.2.0</td></tr>
</table>

Default configuration in orientdb-server-config.xml. Example:
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

Look at [Security Config](Security-Config.md).

