# Server Side Script Interpreter Plugin

Java class implementation:
```java
com.orientechnologies.orient.server.handler.OServerSideScriptInterpreter
```
Available since: **v. 1.6.0**.

## Introduction

Allows to execute script on the server.

## Configuration

This plugin is configured as a [Server handler](DB-Server.md#handlers). The plugin can be configured in easy way by changing parameters:

<table>
  <tr><th>Name</th><th>Description</th><th>Type</th><th>Example</th><th>Since</th></tr>
  <tr><td>enabled</td><td>true to turn on, false (default) is turned off</td><td>boolean</td><td>true</td><td>1.6.0</td></tr>
  <tr><td><code>allowedLanguages</code></td><td>Array of languages allowed to be executed on the server</td><td>array of strings</td><td>SQL,Javascript</td><td>1.6.0</td></tr>
</table>

Default configuration in orientdb-server-config.xml. Example:
```xml
<!-- MAIL, TO TURN ON SET THE 'ENABLED' PARAMETER TO 'true' -->
<handler class="com.orientechnologies.orient.server.handler.OServerSideScriptInterpreter">
  <parameters>
  <parameter value="true" name="enabled"/>
  <parameter value="SQL,Javascript" name="allowedLanguages"/>
  </parameters>
</handler>
```

## Usage

Look at [Console Command JSS](Console-Command-Jss.md).

