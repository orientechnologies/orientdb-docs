---
search:
   keywords: ['server management', 'service', 'Windows']
---

# Install as a Service on Windows

OrientDB is a Java server application. As most server applications, they have to perform several tasks, before being able to shut down the Virtual Machine process, hence they need a portable way to be notified of the imminent Virtual Machine shutdown.
At the moment, the only way to properly shut down an OrientDB server instance (not embedded) is to execute the *shutdown.bat* (or *shutdown.sh*) script shipped with the OrientDB distribution, but it's up to the user to take care of this. This implies that the server instance isn't  stopped correctly, when the computer on which it is deployed, is shut down without executing the above script.


## Apache Commons Daemon

[Apache Commons Daemon](http://commons.apache.org/daemon/) is a set of applications and API enabling Java server application to run as native non interactive server applications under Unix and Windows. In Unix, server applications running in the background are called *daemons* and are controlled by the operating system with a set of specified *signals*. Under Windows, such programs are called services and are controlled by appropriate calls to specific functions defined in the application binary. Although the ways of dealing with running daemons or services are different, in both cases the operating system can notify a server application of its imminent shutdown, and the underlying application has the ability to perform certain tasks, before its process of execution is destroyed. Wrapping OrientDB as a *Unix daemon* or as a *Windows service* enables the management of this server application lifecycle through the mechanisms provided natively by both Unix and Windows operating systems.


## Installation

This tutorial is focused on Windows, so you have to download *procrun*. [Procrun](http://commons.apache.org/daemon/procrun.html) is a set of applications, which allow Windows users to wrap (mostly) Java applications (e.g. Tomcat) as a Windows service. The service can be set to automatically start, when the machine boots and will continue to run with no user logged onto the machine.

1. Point you browser to the [Apache Commons Daemon download page](http://commons.apache.org/daemon/download_daemon.cgi).
1. Click on **Browse native binaries download area...**: you will see the index **commons/daemon/binaries/** (even if the title in the page reports **Index of dist/commons**).
1. Click on **windows**. Now you can see the index of **commons/daemon/binaries/windows**.
1. Click on **commons-daemon-1.0.7-bin-windows.zip**. The download starts.
1. Unzip the file in a directory of your choice.
The content of the archive is depicted below:

```
commons-daemon-1.0.7-bin-windows
|
\---amd64
    |
    \---prunsrv.exe
|
\---ia64
    |
    \---prunsrv.exe
|
\---LICENCE.txt
|
\---NOTICE.txt
|
\---prunmgr.exe
|
\---prunsrv.exe
|
\---RELEASE-NOTES.txt
```

**prunmgr** is a GUI application for monitoring and configuring Windows services wrapped with procrun. **prunsrv** is a service application for running applications as services. It can convert any application (not just Java applications) to run as a service. The directory **amd64** contains a version of **prunsrv** for x86-64 machines while the directory **ia64** contains a version of **prunsrv** for Itanium 64 machines.

Once you downloaded the applications, you have to put them in a folder under the OrientDB installation folder.

1. Go to the OrientDB folder, in the following referred as _%ORIENTDB_HOME%_
1. Create a new directory and name it **service**
1. Copy there the appropriate versions of **prunsrv** and **prunmgr** according to the architecture of your machine.


## Configuration

In this section, we will show how to wrap OrientDB as a Windows Service.
In order to wrap OrientDB as a service, you have to execute a short script that uses the prunsrv application to configure a Windows Service.

Before defining the Windows Service, you have to rename **prunsrv** and **prunmgr** according to the name of the service. Both applications require the name of the service to manage and monitor as parameter but you can avoid it by naming them with the name of the service. In this case, rename them respectively **OrientDBGraph** and **OrientDBGraphw** as *OrientDBGraph* is the name of the service that you are going to configure with the script below. If you want to use a difference service name, you have to rename both application respectively **myservicename** and **myservicenamew** (for example, if you are wrapping OrientDB and the name of the service is *OrientDB*, you could rename *prunsrv* as *OrientDB* and *prunmgr* as *OrientDBw*).
After that, create the file **%ORIENTDB_HOME%\service\installService.bat** with the content depicted below:

```
:: OrientDB Windows Service Installation
@echo off
rem Remove surrounding quotes from the first parameter
set str=%~1
rem Check JVM DLL location parameter
if "%str%" == "" goto missingJVM
set JVM_DLL=%str%
rem Remove surrounding quotes from the second parameter
set str=%~2
rem Check OrientDB Home location parameter
if "%str%" == "" goto missingOrientDBHome
set ORIENTDB_HOME=%str%

set CONFIG_FILE=%ORIENTDB_HOME%/config/orientdb-server-config.xml
set LOG_FILE=%ORIENTDB_HOME%/config/orientdb-server-log.properties
set LOG_CONSOLE_LEVEL=info
set LOG_FILE_LEVEL=fine
set WWW_PATH=%ORIENTDB_HOME%/www
set ORIENTDB_ENCODING=UTF8
set ORIENTDB_SETTINGS=-Dprofiler.enabled=true -Dcache.level1.enabled=false -Dcache.level2.strategy=1
set JAVA_OPTS_SCRIPT=-XX:+HeapDumpOnOutOfMemoryError

rem Install service
OrientDBGraphX.X.X.exe //IS --DisplayName="OrientDB GraphEd X.X.X" ^
--Description="OrientDB Graph Edition, aka GraphEd, contains OrientDB server integrated with the latest release of the TinkerPop Open Source technology stack supporting property graph data model." ^
--StartClass=com.orientechnologies.orient.server.OServerMain --StopClass=com.orientechnologies.orient.server.OServerShutdownMain ^
--Classpath="%ORIENTDB_HOME%\lib\*" --JvmOptions=-Dfile.encoding=%ORIENTDB_ENCODING%;-Djava.util.logging.config.file="%LOG_FILE%";-Dorientdb.config.file="%CONFIG_FILE%";-Dorientdb.www.path="%WWW_PATH%";-Dlog.console.level=%LOG_CONSOLE_LEVEL%;-Dlog.file.level=%LOG_FILE_LEVEL%;-Dorientdb.build.number="@BUILD@";-DORIENTDB_HOME="%ORIENTDB_HOME%" ^
--StartMode=jvm --StartPath="%ORIENTDB_HOME%\bin" --StopMode=jvm --StopPath="%ORIENTDB_HOME%\bin" --Jvm="%JVM_DLL%" --LogPath="%ORIENTDB_HOME%\log" --Startup=auto

EXIT /B

:missingJVM
echo Insert the JVM DLL location
goto printUsage

:missingOrientDBHome
echo Insert the OrientDB Home
goto printUsage

:printUsage
echo usage:
echo     installService JVM_DLL_location OrientDB_Home
EXIT /B
```

The script requires two input parameters:

1. The location of jvm.dll, for example _C:\Program Files\Java\jdk1.6.0_26\jre\bin\server\jvm.dll_
1. The location of the OrientDB installation folder, for example *D:\orientdb-graphed-1.0rc5*

The service is actually installed when executing **OrientDBGraph.exe** (originally prunsrv) with the appropriate set of command line arguments and parameters.
The command line argument **//IS** states that the execution of that application will result in a service installation.
Below there is the table with the command line parameters used in the above script.
<table><tbody>
  <tr><th>Parameter name</th><th>Description</th><th>Source</th></tr>
  <tr><td>--DisplayName</td><td>The name displayed in the Windows Services Management Console</td><td>Custom</td></tr>
  <tr><td>--Description</td><td>The description displayed in the Windows Services Management Console</td><td>Custom</td></tr>
  <tr><td>--StartClass</td><td>Class that contains the startup method (= the method to be called to start the application). The default method to be called is the <code>main</code> method</td><td>The class invoked in the */bin/server.bat* script</td></tr>
  <tr><td>--StopClass</td><td>Class that will be used when receiving a Stop service signal. The default method to be called is the <code>main</code> method</td><td>The class invoked in the */bin/shutdown.bat* script</td></tr>
  <tr><td>--Classpath</td><td>Set the Java classpath</td><td>The value of the <code>-cp</code> parameter specified in the _%ORIENTDB_HOME%\bin\server.bat_ script</td></tr>
  <tr><td>--JvmOptions</td><td>List of options to be passed to the JVM separated using either # or ; characters</td><td>The list of options in the form of -D or -X specified in the _%ORIENTDB_HOME%\bin\server.bat_ script and the definition of the ORIENTDB_HOME system property</td></tr>
  <tr><td>--StartMode</td><td>Specify how to start the process. In this case, it will start Java in-process and not as a separate image</td><td>Based on Apache Tomcat configuration</td></tr>
  <tr><td>--StartPath</td><td>Working path for the StartClass</td><td>_%ORIENTDB_HOME%\bin_</td></tr>
  <tr><td>--StopMode</td><td>The same as --StartMode</td><td>Based on Apache Tomcat configuration</td></tr>
  <tr><td>--StopPath</td><td>Working path for the StopClass</td><td>_%ORIENTDB_HOME%\bin_</td></tr>
  <tr><td>--Jvm</td><td>Which *jvm.dll* to use: the default one or the one located in the specified full path</td><td>The first input parameter of this script. Ensure that you insert the location of the Java HotSpot Server VM as a full path. We will use the server version for both start and stop.</td></tr>
  <tr><td>--LogPath</td><td>Path used by prunsrv for logging</td><td>The default location of the Apache Commons Daemon log</td></tr>
  <tr><td>--Startup</td><td>States if the service should start at machine start up or manually</td><td>auto</td></tr>
</tbody></table>
For a complete reference to all available parameters and arguments for prunsrv and prunmgr, visit the [Procrun page](http://commons.apache.org/daemon/procrun.html).

In order to install the service:

1. Open the Windows command shell
1. Go to _%ORIENTDB_HOME%\service_, for example typing in the shell <code>> cd D:\orientdb-graphed-1.0rc5\service</code>
1. Execute the *installService.bat* specifying the *jvm.dll* location and the OrientDB Home as full paths, for example typing in the shell <code>> installService.bat "C:\Program Files\Java\jdk1.6.0_26\jre\bin\server\jvm.dll" D:\orientdb-graphed-1.0rc5</code>
1. Open the Windows Services Management Console - from the taskbar, click on *Start*, *Control Panel*, *Administrative Tools* and then *Service* - and check the existance of a service with the same name specified as value of the <code>--DisplayName</code> parameter (in this case **OrientDB GraphEd 1.0rc5**). You can also use _%ORIENTDB_HOME%\service\OrientDBGraphw.exe_ to manage and monitor the *OrientDBGraph* service.



### Other resources
To learn more about how to install OrientDB on specific environment please follow the guide below:
- [Install on Linux Ubuntu](http://famvdploeg.com/blog/2013/01/setting-up-an-orientdb-server-on-ubuntu/)
- [Install on JBoss AS](http://team.ops4j.org/wiki/display/ORIENT/Installation+on+JBoss+AS)
- [Install on GlassFish](http://team.ops4j.org/wiki/display/ORIENT/Installation+on+GlassFish)
- [Install on Ubuntu 12.04 VPS (DigitalOcean)](https://www.digitalocean.com/community/articles/how-to-install-and-use-orientdb-on-an-ubuntu-12-04-vps)
- [Install as service on Unix, Linux and MacOSX](Unix-Service.md)
- [Install as service on Windows](Windows-Service.md)
