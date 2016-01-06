<!-- proofread 2015-01-05 SAM -->

# Console Tool

OrientDB provides a Console Tool, which is a Java application that connects to and operates on OrientDB databases and Server instances.

## Console Modes

There are two modes available to you, while executing commands through the OrientDB Console: interactive mode and batch mode.

### Interactive Mode

By default, the Console starts in interactive mode.  In this mode, the Console loads to an `orientdb>` prompt.  From there you can execute commands and SQL statements as you might expect in any other database console.

You can launch the console in interactive mode by executing the `console.sh` for Linux OS systems or `console.bat` for Windows systems in the `bin` directory of your OrientDB installation. Note that running this file requires execution permissions.

<pre>
$ <code class="lang-sh userinput">cd $ORIENTDB_HOME/bin</code>
$ <code class="lang-sh userinput">./console.sh</code>

OrientDB console v.X.X.X (build 0) www.orientdb.com
Type 'HELP' to display all the commands supported.
Installing extensions for GREMLIN language v.X.X.X

orientdb>
</pre>

From here, you can begin running SQL statements or commands.  For a list of these commands, see [commands](#Consoel_Commands).

### Batch mode

When the Console runs in batch mode, it takes commands as arguments on the command-line or as a text file and executes the commands in that file in order.  Use the same `console.sh` or `console.bat` file found in `bin` at the OrientDB installation directory.

- **Command-line**: To execute commands in batch mode from the command line, pass the commands you want to run in a string, separated by a semicolon.
  <pre>
  $ <code class="lang-sh userinput">$ORIENTDB_HOME/bin/console.sh "CONNECT REMOTE:localhost/demo;SELECT FROM Profile"</code>
  </pre>

- **Script Commands**: In addition to entering the commands as a string on the command-line, you can also save the commands to a text file as a semicolon-separated list.

  <pre>
  $ <code class="lang-sh userinput">vim commands.txt</code>
  <code class="lang-sql userinput">
    CONNECT REMOTE:localhost/demo;SELECT FROM Profile
  </code>
  $ <code class="lang-sh userinput">$ORIENTDB_HOME/bin/console.sh commands.txt</code>
  </pre>

#### Ignoring Errors

When running commands in batch mode, you can tell the console to ignore errors, allowing the script to continue the execution, with the `ignoreErrors` setting.

<pre>
$ <code class="lang-sh userinput">vim commands.txt</code>
<code class="lang-sql userinput">
  SET ignoreErrors TRUE
</code>
</pre>


#### Enabling Echo

Regardless of whether you call the commands as an argument or through a file, when you run console commands in batch mode, you may also need to display them as they execute.  You can enable this feature using the `echo` setting, near the start of your commands list.

<pre>
$ <code class='lang-sh userinput'>vim commands.txt</code>
<code class="lang-sql userinput">
  SET echo TRUE
</code>
</pre>



## Console commands

OrientDB implements a number of SQL statements and commands that are available through the Console. In the event that you need information while working in the console, you can access it using either the `HELP` or `?` command.


|Command|Description|
|-------|-----------|
|[`ALTER CLASS`](SQL-Alter-Class.md)|Changes the class schema|
|[`ALTER CLUSTER`](SQL-Alter-Cluster.md)|Changes the cluster attributes|
|[`ALTER DATABASE`](SQL-Alter-Database.md)|Changes the database attributes|
|[`ALTER PROPERTY`](SQL-Alter-Property.md)|Changes the class's property schema|
|[`BACKUP DATABASE`](Console-Command-Backup.md)|Backup a database|
|[`BEGIN`](Console-Command-Begin.md)|Begins a new transaction|
|[`BROWSE CLASS`](Console-Command-Browse-Class.md)|Browses all the records of a class|
|[`BROWSE CLUSTER`](Console-Command-Browse-Cluster.md)|Browses all the records of a cluster|
|[`CLASSES`](Console-Command-Classes.md)|Displays all the configured classes|
|[`CLUSTER STATUS`](Console-Command-Cluster-Status.md)|Displays the status of distributed cluster of servers|
|[`CLUSTERS`](Console-Command-Clusters.md)|Displays all the configured clusters|
|[`COMMIT`](Console-Command-Commit.md)|Commits an active transaction|
|[`CONFIG`](Console-Command-Config.md)|Displays the configuration where the opened database is located (local or remote)|
|[`CONFIG GET`](Console-Command-Config-Get.md)|Returns a configuration value|
|[`CONFIG SET`](Console-Command-Config-Set.md)|Set a configuration value|
|[`CONNECT`](Console-Command-Connect.md)|Connects to a database|
|[`CREATE CLASS`](SQL-Create-Class.md)|Creates a new class|
|[`CREATE CLUSTER`](Console-Command-Create-Cluster.md)|Creates a new cluster inside a database|
|[`CREATE CLUSTER`](Console-Command-Create-Cluster.md)|Creates a new record cluster|
|[`CREATE DATABASE`](Console-Command-Create-Database.md)|Creates a new database|
|[`CREATE EDGE`](SQL-Create-Edge.md)|Create a new edge connecting two vertices|
|[`CREATE INDEX`](SQL-Create-Index.md)|Create a new index|
|[`CREATE LINK`](SQL-Create-Link.md)|Create a link reading a RDBMS JOIN|
|[`CREATE VERTEX`](SQL-Create-Vertex.md)|Create a new vertex|
|[`DECLARE INTENT`](Console-Command-Declare-Intent.md)|Declares an intent|
|[`DELETE`](SQL-Delete.md)|Deletes a record from the database using the SQL syntax. To know more about the [SQL syntax go here](SQL-Query.md)|
|[`DICTIONARY KEYS`](Console-Command-Dictionary-Keys.md)|Displays all the keys in the database dictionary|
|[`DICTIONARY GET`](Console-Command-Dictionary-Get.md)|Loookups for a record using the dictionary. If found set it as the current record|
|[`DICTIONARY PUT`](Console-Command-Dictionary-Put.md)|Inserts or modify an entry in the database dictionary. The entry is composed by key=String, value=record-id|
|[`DICTIONARY REMOVE`](Console-Command-Dictionary-Remove.md)|Removes the association in the dictionary|
|[`DISCONNECT`](Console-Command-Disconnect.md)|Disconnects from the current database|
|[`DISPLAY RECORD`](Console-Command-Display-Record.md)|Displays current record's attributes|
|[`DISPLAY RAW RECORD`](Console-Command-Display-Raw-Record.md)|Displays current record's raw format|
|[`DROP CLASS`](SQL-Drop-Class.md)|Drop a class|
|[`DROP CLUSTER`](SQL-Drop-Cluster.md)|Drop a cluster|
|[`DROP DATABASE`](Console-Command-Drop-Database.md)|Drop a database|
|[`DROP INDEX`](SQL-Drop-Index.md)|Drop an index|
|[`DROP PROPERTY`](SQL-Drop-Property.md)|Drop a property from a schema class|
|[`EXPLAIN`](SQL-Explain.md)|Explain a command by displaying the profiling values while executing it|
|[`EXPORT DATABASE`](Console-Command-Export.md)|Exports a database|
|[`EXPORT RECORD`](Console-Command-Export-Record.md)|Exports a record in any of the supported format (i.e. json)|
|[`FIND REFERENCES`](SQL-Find-References.md)|Find the references to a record|
|[`FREEZE DATABASE`](Console-Command-Freeze-Db.md)|Freezes the database locking all the changes. Use this to raw backup. Once frozen it uses the [`RELEASE DATABASE`](Console-Command-Release-Db.md) to release it|
|[`GET`](Console-Command-Get.md)|Returns the value of a property|
|[`GRANT`](SQL-Grant.md)|Grants a permission to a user|
|[`GREMLIN`](Console-Command-Gremlin.md)|Executes a Gremlin script|
|[`IMPORT DATABASE`](Console-Command-Import.md)|Imports a database previously exported|
|[`INDEXES`](Console-Command-Indexes.md)|Displays information about indexes|
|[`INFO`](Console-Command-Info.md)|Displays information about current status|
|[`INFO CLASS`](Console-Command-Info-Class.md)|Displays information about a class|
|[`INSERT`](Console-Command-Insert.md)|Inserts a new record in the current database using the SQL syntax. To know more about the [SQL syntax go here](SQL-Query.md)|
|[`JS`](Javascript-Command.md#via_console)|Executes a Javascript in the console|
|[`JSS`](Javascript-Command.md#via_console)|Executes a Javascript in the server|
|[`LIST DATABASES`](Console-Command-List-Databases.md)|List the available databases|
|[`LIST CONNECTIONS`](Console-Command-List-Connections.md)|List the available connections|
|[`LOAD RECORD`](Console-Command-Load-Record.md)|Loads a record in memory and set it as the current one|
|[`PROFILER`](Console-Command-Profiler.md)|Controls the [Profiler](Profiler.md)|
|[`PROPERTIES`](Console-Command-Properties.md)|Returns all the configured properties|
|`pwd`|Display current path|
|[`REBUILD INDEX`](SQL-Rebuild-Index.md)|Rebuild an index|
|[`RELEASE DATABASE`](Console-Command-Release-Db.md)|Releases a [Console Freeze Database](Console-Command-Freeze-Db.md) database|
|[`RELOAD RECORD`](Console-Command-Reload-Record.md)|Reloads a record in memory and set it as the current one|
|`RELOAD SCHEMA`|Reloads the schema|
|[`ROLLBACK`](Console-Command-Rollback.md)|Rollbacks the active transaction started with [begin](Console-Command-Begin.md)|
|[`RESTORE DATABASE`](Console-Command-Restore.md)|Restore a database|
|[`SELECT`](SQL-Query.md)|Executes a SQL query against the database and display the results. To know more about the [SQL syntax go here](SQL-Query.md)|
|[`REVOKE`](SQL-Revoke.md)|Revokes a permission to a user|
|[`SET`](Console-Command-Set.md)|Changes the value of a property|
|[`SLEEP`](Console-Command-Sleep.md)|Sleep for the time specified. Useful on scripts|
|[`TRAVERSE`](SQL-Traverse.md)|Traverse a graph of records|
|[`TRUNCATE CLASS`](SQL-Truncate-Class.md)|Remove all the records of a class (by truncating all the underlying configured clusters)|
|[`TRUNCATE CLUSTER`](SQL-Truncate-Cluster.md)|Remove all the records of a cluster|
|[`TRUNCATE RECORD`](SQL-Truncate-Record.md)|Truncate a record you can't delete because it's corrupted|
|[`UPDATE`](SQL-Update.md)|Updates a record in the current database using the SQL syntax. To know more about the [SQL syntax go here](SQL-Query.md)|
|`HELP`|Prints this help|
|`EXIT`|Closes the console|


## Custom Commands

In addition to the commands implemented by OrientDB, you can also develop custom commands to extend features in your particular implementation. To do this, edit the [OConsoleDatabaseApp](https://github.com/orientechnologies/orientdb/blob/master/tools/src/main/java/com/orientechnologies/orient/console/OConsoleDatabaseApp.java) class and add to it a new method.  There's an auto-discovery system in place that adds the new method to the available commands. To provide a description of the command, use annotations. The command name must follow the Java code convention of separating words using camel-case.

For instance, consider a case in which you might want to add a `MOVE CLUSTER` command to the console:

```java
@ConsoleCommand(description = "Move the physical location of cluster files")
public void moveCluster(
   @ConsoleParameter(name = "cluster-name", description = "The name or the id of the cluster to remove") String iClusterName,
   @ConsoleParameter(name = "target-path", description = "path of the new position where to move the cluster files") String iNewPath ) {

   checkCurrentDatabase(); // THE DB MUST BE OPENED

   System.out.println("Moving cluster '" + iClusterName + "' to path " + iNewPath + "...");
   }
```

Once you have this code in place, `MOVE CLUSTER` now appears in the listing of available commands shown by `HELP`.

<pre>
orientdb> <code class="lang-sql userinput">HELP</code>

AVAILABLE COMMANDS:
AVAILABLE COMMANDS:
 * alter class <command-text>   Alter a class in the database schema
 * alter cluster <command-text> Alter class in the database schema
 ...                            ...
 * move cluster                 Move the physical location of cluster files
 ...                            ...
 * help                         Print this help
 * exit                         Close the console

orientdb> <code class="lang-sql userinput">MOVE CLUSTER foo /temp</code>

Moving cluster 'foo' to path /tmp...
</pre>

In the event that you develop a custom command and find it especially useful in your deployment, you can contribute your code to the [OrientDB Community](https://groups.google.com/forum/#!forum/orient-database)!

