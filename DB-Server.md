---
search:
   keywords: ['internals', 'server', 'OrientDB Server']
---

# OrientDB Server

OrientDB Server (DB-Server from now) is a multi-threaded Java application that listens to remote commands and executes them against the Orient databases. OrientDB Server supports both [binary](Network-Binary-Protocol.md) and [HTTP](OrientDB-REST.md) protocols. The first one is used by the Orient native client and the Orient Console. The second one can be used by any languages since it's based on [HTTP RESTful API](OrientDB-REST.md). The HTTP protocol is used also by the [OrientDB Studio application](Studio-Home-page.md).

Starting from v1.7 OrientDB support [protected SSL connections](Using-SSL-with-OrientDB.md).

|   |   |
|---|---|
|![warning](images/warning.png)|Even thought OrientDB Server is a regular Web Server, it is not recommended to expose it directly on the Internet or public networks. We suggest to always hide OrientDB server in a private network.|

## Install as a service
OrientDB Server is part of Community and Enterprise distributions. To install OrientDB as service follow the following guides

- [Unix, Linux and MacOSX](Unix-Service.md)
- [Windows](Windows-Service.md)

## Start the server

To start the server, execute bin/server.sh (or bin/server.bat on Microsoft Windows systems). By default both the binary and http interfaces are active. If you want to disable one of these change the [Server configuration](#Configuration).

Upon startup, the server runs on port 2424 for the binary protocol and 2480 for the http one. If a port is busy the next free one will be used. The default range is 2424-2430 (binary) and 2480-2490 (http). These default ranges can be changed in in [Server configuration](#Configuration).

## Stop the server

To stop a running server, press CTRL+C in the open shell that runs the Server instance or soft kill the process to be sure that the opened databases close softly. Soft killing on Windows can be done by closing the window. On Unix-like systems, a simple kill is enough (Do not use kill -9 unless you want to force a hard shutdown).

## Connect to the server

### By Console
The OrientDB distribution provides the [Orient Console](Console-Commands.md) tool as a console Java application that uses the binary protocol to work with the database.

### By OrientDB Studio
Starting from the release 0.9.13 Orient comes with the [OrientDB Studio application](Studio-Home-page.md), a client-side web app that uses the HTTP protocol to work with the database.

### By your application
Consider the [native APIs](Java-API.md) if you use Java. For all the other languages you can use the [HTTP RESTful protocol](OrientDB-REST.md).

## Distributed servers

To setup a distributed configuration look at: [Distributed-Architecture](Distributed-Architecture.md).

## Change the Server's database directory

By default OrientDB server manages the database under the directory "$ORIENTDB_HOME/databases" where $ORIENTDB_HOME is the OrientDB installation directory. By setting the configuration parameter <code>"server.database.path"</code> in server orientdb-server-config.xml you can specify a custom path. Example:

```xml
<orient-server>
  ...
  <properties>
    <entry value="C:/temp/databases" name="server.database.path" />
  </properties>
</orient-server>
```

## Configuration


### Plugins

Plug-ins (old name "Handler") are the way the OrientDB Server can be extended.

To write your own plug-in read below [Extend the server](Extend-Server.md).

Available plugins:
- [Automatic-Backup](Automatic-Backup.md)
- [EMail Plugin](Mail-Plugin.md)
- [JMX Plugin](JMX-Plugin.md)
- [Distributed-Server-Manager](Distributed-Server-Manager.md)
- [Server-side script interpreter](Javascript-Command.md#enable_server_side_scripting)
- [Write your own](Extend-Server.md)

### Protocols

Contains the list of protocols used by the [listeners section](#Listeners).
The protocols supported today are:
- **binary**: the Raw binary protocol used by OrientDB clients and console application.
- **http**: the HTTP RESTful protocol used by [OrientDB Studio](Studio-Home-page.md) and direct raw access from any language and browsers.

### Listeners

You can configure multiple listeners by adding items under the <code>&lt;listeners&gt;</code> tag and selecting the ip-address and TCP/IP port to bind. The protocol used must be listed in the [protocols section](#Protocols). Listeners can be configured with single port or port range. If a range of ports is specified, then it will try to acquire the first port available. If no such port is available, then an error is thrown.
By default the Server configuration activates connections from both the protocols:
- **binary**: by default the binary connections are listened to the port range 2424-2430.
- **http**: by default the HTTP connections are listened to the port range 2480-2490.

### Storages

Contains the list of the static configured storages. When the server starts for each storages static configured storage enlisted check if exists. If exists opens it, otherwise creates it transparently.

By convention all the storages contained in the $ORIENT_HOME/databases are visible from the OrientDB Server instance without the need of configure them. So configure storages if:
- are located outside the default folder. You can use any environment variable in the path such the ORIENT_HOME that points to the Orient installation path if defined otherwise to the root directory where the Orient Server starts.
- want to create/open automatically a database when the server start ups

By default the **"temp"** database is always configured as in-memory storage useful to store volatile information.

Example of configuration:
```xml
<storage name="mydb" path="local:C:/temp/databases/mydb"
         userName="admin" userPassword="admin"
         loaded-at-startup="true" />
```

To create a new database use the [CREATE DATABASE console command](Console-Command-Create-Database.md) or create it dinamically using the [Java-API](Java-API.md).

### Users

Starting from v.0.9.15 OrientDB supports per-server users in order to protect sensible operations to the users. In facts the creation of a new database is a server operation as much as the retrieving of server statistics.

#### Automatic password generation

When an OrientDB server starts for the first time, a new user called "root" will be generated and saved in the server configuration. This avoid security problems when, very often, the passwords remain the default ones.

#### Resources

User based authentication checks if the logged user has the permission to access to the requested resource. "*" means access to all the resource. This is the typical setting for the user "root". Multiple resources must be separated by comma.

Example to let to the "root" user to access to all the server commands:

```xml
<user name="root" resources="*" password="095F17F6488FF5416ED24E"/>
```

Example to let to the "guest" user to access only to the "info-server" command:

```xml
<user name="guest" resources="info-server" password="3489438DKJDK4343UDH76"/>
```

Supported resources are:
- <code>info-server</code>, to obtain statistics about the server
- <code>database.create</code>, to create a new database
- <code>database.exists</code>, to check if a database exists
- <code>database.delete</code>, to delete an existent database
- <code>database.share</code>, to share a database to another OrientDB Server node
- <code>database.passthrough</code>, to access to the hosted databases without database's authentication
- <code>server.config.get</code>, to retrieve a configuration setting value
- <code>server.config.set</code>, to set a configuration setting value

### Create new user with some privileges

To configure a new user open the **config/orientdb-server-config.xml** file and add a new XML tag under the tag <code>&lt;users&gt;</code>:

```xml
<users>
    <user name="MyUser" password="MyPassword" resources="database.exists"/>
</users>
```

## Extend the server

To extend the server's features look at [Extends the server](Extend-Server.md).

## Debug the server

To debug the server configure your IDE to execute the class OServerMain:
```java
com.orientechnologies.orient.server.OServerMain
```

Passing these parameters:
```
-server
-Dorientdb.config.file=config/orientdb-server-config.xml
-Dorientdb.www.path=src/site
-DORIENTDB_HOME=url/local/orientdb/releases/orientdb-1.2.0-SNAPSHOT
-Djava.util.logging.config.file=config/orientdb-server-log.properties
-Dcache.level1.enabled=false
-Dprofiler.enabled=true
```

Changing the ORIENTDB_HOME according to your path.
