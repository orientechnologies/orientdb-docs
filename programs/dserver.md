# OrientDB Server - dserver.sh

In situations where an individual host is insufficient for your storage or performance needs, you can run OrientDB on multiple hosts distributing the load between them.  Where the [`server`](server.md) script starts OrientDB as an individual Server, the `dserver` script does the same, while configuring Server to operate in a distributed environment.

OrientDB provides a `dserver.sh` shell script for Linux operating systems and `dserver.bat` batch file for the Windows operating system.


## Configuration Environmental Variables

OrientDB manages most of its configuration options through various XML configuration files.  However, there are a handful of environmental variables that it utilizes when starting the Server.  When the script runs, it check these variables to determine whether any value has been set on them.  In the event that it finds none, it instead sets a sensible default value.

On Linux, you can set the environmental variable using the `export` commnd:

```sh
$ export ORIENTDB_HOME=/opt/orientdb/{{ book.currentVersion }}/
```

The following environmental variables are used by `server.sh`:

| Variable Name | Default  | Description|
|---|---|---|
| `$CONFIG_FILE` | `$ORIENTDB_HOME/config/orientdb-server-config.xml` | XML configuration file for the server |
| `$JAVA_HOME`   | `$PATH/java` | Path to Java home directory, used when you have multiple installations of Java available on the host |
| `$JAVA_OPTS_SCRIPT` | `-Djna.nosys=true -XX:+HeapDumpOnOutOfMemoryError -Djava.awt.headless=true -Dfile.encoding=UTF8 -Drhino.opt.level=9` | Defines  |
| `$ORIENTDB_HOME` | current working directory | OrientDB installation directory |
| `$ORIENTDB_LOG_CONF`    | `$ORIENTDB_HOME/config/orientdb-server-log.properties` | Path to Java properties file you want to use |
| `$ORIENTDB_OPTS_MEMORY` | `-Xms2G -Xmx2G`| Memory options, defaults to 2GB of heap |
| `$ORIENTDB_PID`         | `$ORIENTDB_HOME/bin/orient.pid` | Path to the process id (`.pid`) file   |
| `$ORIENTDB_SETTINGS`    |  | Default settings for OrientDB |
| `$ORIENTDB_WWW_PATH`    | `$ORIENTDB_HOME/www/` | Path to web resources, defaults to the interface to launch OrientDB Studio  |


The [`dserver.sh`](dserver.md) script also accepts argument.  If one of the arguments is `debug`, the script enables the following Java options `-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=1044`.  Any additional arguments are passed directly to the `java` program. 

