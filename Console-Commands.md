# Console Tool

The OrientDB Console is a Java Application made to work against OrientDB databases and Server instances.

## Interactive mode

This is the default mode. Just launch the console by executing the script **bin/console.sh** (or **bin/console.bat** in MS Windows systems). Assure to have execution permission on it.

Once started the console is ready to accepts commands.
```
OrientDB console v.1.6.6 www.orientechnologies.com
Type 'help' to display all the commands supported.

orientdb>
```

To know all the supported commands look to [commands](#Console_Commands).

## Batch mode

To execute commands in batch mode run the **bin/console.sh** (or **bin/console.bat** in MS Windows systems) script passing all the commands separated with semicolon ";". Example:

```
> console.bat "connect remote:localhost/demo;select * from profile"
```

Or call the console script passing the name of the file in text format containing the list of commands to execute. Commands must be separated with semicolon ";". Example:

    orientdb> console.bat commands.txt

In batch mode you can ignore errors to let the script to continue the execution by setting the "ignoreErrors" variable to true:

    orientdb> set ignoreErrors true

## Enable echo
When you run console commands in pipeline, you could need to display them. Enable "echo" of commands by setting it as property at the beginning:

    orientdb> set echo true

## Console commands

To know all the commands supported by the Orient console open it and type **help** or **?**.

|Command|Description|
|-------|-----------|
|[alter class](SQL-Alter-Class.md)|Changes the class schema|
|[alter cluster](SQL-Alter-Cluster.md)|Changes the cluster attributes|
|[alter database](SQL-Alter-Database.md)|Changes the database attributes|
|[alter property](SQL-Alter-Property.md)|Changes the class's property schema|
|[begin](Console-Command-Begin.md)|Begins a new transaction|
|[browse class](Console-Command-Browse-Class.md)|Browses all the records of a class|
|[browse cluster](Console-Command-Browse-Cluster.md)|Browses all the records of a cluster|
|[classes](Console-Command-Classes.md)|Displays all the configured classes|
|[cluster status](Console-Command-Cluster-Status.md)|Displays the status of distributed cluster of servers|
|[clusters](Console-Command-Clusters.md)|Displays all the configured clusters|
|[commit](Console-Command-Commit.md)|Commits an active transaction|
|[config](Console-Command-Config.md)|Displays the configuration where the opened database is located (local or remote)|
|[config get](Console-Command-Config-Get.md)|Returns a configuration value|
|[config set](Console-Command-Config-Set.md)|Set a configuration value|
|[connect](Console-Command-Connect.md)|Connects to a database|
|[create class](SQL-Create-Class.md)|Creates a new class|
|[create cluster](Console-Command-Create-Cluster.md)|Creates a new cluster inside a database|
|[create cluster](Console-Command-Create-Cluster.md)|Creates a new record cluster|
|[create database](Console-Command-Create-Db.md)|Creates a new database|
|[create edge](SQL-Create-Edge.md)|Create a new edge connecting two vertices|
|[create index](SQL-Create-Index.md)|Create a new index|
|[create link](SQL-Create-Link.md)|Create a link reading a RDBMS JOIN|
|[create vertex](SQL-Create-Vertex.md)|Create a new vertex|
|[declare intent](Console-Command-Declare-Intent.md)|Declares an intent|
|[delete](SQL-Delete.md)|Deletes a record from the database using the SQL syntax. To know more about the [SQL syntax go here](SQL-Query.md)|
|[dictionary keys](Console-Command-Dictionary-Keys.md)|Displays all the keys in the database dictionary|
|[dictionary get](Console-Command-Dictionary-Get.md)|Loookups for a record using the dictionary. If found set it as the current record|
|[dictionary put](Console-Command-Dictionary-Put.md)|Inserts or modify an entry in the database dictionary. The entry is composed by key=String, value=record-id|
|[dictionary remove](Console-Command-Dictionary-Remove.md)|Removes the association in the dictionary|
|[disconnect](Console-Command-Disconnect.md)|Disconnects from the current database|
|[display record](Console-Command-Display-Record.md)|Displays current record's attributes|
|[display raw record](display-raw-record.md)|Displays current record's raw format|
|[drop class](SQL-Drop-Class.md)|Drop a class|
|[drop cluster](SQL-Drop-Cluster.md)|Drop a cluster|
|[drop database](Console-Command-Drop-Db.md)|Drop a database|
|[drop index](SQL-Drop-Index.md)|Drop an index|
|[drop property](SQL-Drop-Property.md)|Drop a property from a schema class|
|[explain](SQL-Explain.md)|Explain a command by displaying the profiling values while executing it|
|[export database](Console-Command-Export.md)|Exports a database|
|[export record](Console-Command-Export-Record.md)|Exports a record in any of the supported format (i.e. json)|
|[find references](SQL-Find-References.md)|Find the references to a record|
|[freeze database](Console-Command-Freeze-Db.md)|Freezes the database locking all the changes. Use this to raw backup. Once frozen it use the [release database](Console-Release-Database.md) to release it|
|[get](Console-Command-Get.md)|Returns the value of a property|
|[grant](SQL-Grant.md)|Grants a permission to a user|
|[import database](Console-Command-Import.md)|Imports a database previously exported|
|[indexes](Console-Command-Indexes.md)|Displays information about indexes|
|[info](Console-Command-Info.md)|Displays information about current status|
|[info class](Console-Command-Info-Class.md)|Displays information about a class|
|[insert](Console-Command-Insert.md)|Inserts a new record in the current database using the SQL syntax. To know more about the [SQL syntax go here](SQL-Query.md)|
|[js](Javascript-Command.md#via_console)|Executes a Javascript in the console|
|[jss](Javascript-Command.md#via_console)|Executes a Javascript in the server|
|[list databases](Console-Command-List-Databases.md)|List the available databases|
|[load record](Console-Command-Load-Record.md)|Loads a record in memory and set it as the current one|
|[profiler](Console-Command-Profiler.md)|Controls the [Profiler](Profiler.md)|
|[properties](Console-Command-Properties.md)|Returns all the configured properties|
|pwd| | Display current path|
|[rebuild index](SQL-Rebuild-Index.md)|Rebuild an index|
|[Release Database](Console-Command-Release-Db.md)|Releases a [Console Freeze Database](Console-Command-Freeze-Db.md) database|
|[reload record](Console-Command-Reload-Record.md)|Reloads a record in memory and set it as the current one|
|reload schema|Reloads the schema|
|[rollback](Console-Command-Rollback.md)|Rollbacks the active transaction started with [begin](Console-Command-Begin.md)|
|[select](Console-Command-Select.md)|Executes a SQL query against the database and display the results. To know more about the [SQL syntax go here](SQL-Query.md)|
|[revoke](SQL-Revoke.md)|Revokes a permission to a user|
|[set](Console-Command-Set.md)|Changes the value of a property|
|[sleep](Console-Command-Sleep.md)|Sleep for the time specified. Useful on scripts|
|[show holes](Console-Command-Show-Holes.md)|Displays the database's holes|
|[traverse](SQL-Traverse.md)|Traverse a graph of records|
|[truncate class](SQL-Truncate-Class.md)|Remove all the records of a class (by truncating all the underlying configured clusters)|
|[truncate cluster](SQL-Truncate-Cluster.md)|Remove all the records of a cluster|
|[truncate record](SQL-Truncate-Record.md)|Truncate a record you can't delete because it's corrupted|
|[update](Console-Command-Update.md)|Updates a record in the current database using the SQL syntax. To know more about the [SQL syntax go here](SQL-Query.md)|
|help|Prints this help|
|exit|Closes the console|

## Extend the console with custom command

Edit the [OConsoleDatabaseApp](http://www.google.com/codesearch#Q2eMNvxgD0M/trunk/tools/src/main/java/com/orientechnologies/orient/console/OConsoleDatabaseApp.java&q=oconsoleda%20package:http://orient%5C.googlecode%5C.com) class and add a new method. There's an auto discovering system that put the new method between the available commands. To provide a description of the command use the annotations (look below). The command name must follow the Java code convention where to separate works just use the Camel-case.

So, for example, if you want to create the brand new "move cluster" command:

```java
@ConsoleCommand(description = "Move the physical location of cluster files")
public void moveCluster(
  @ConsoleParameter(name = "cluster-name", description = "The name or the id of the cluster to remove") String iClusterName,
  @ConsoleParameter(name = "target-path", description = "path of the new position where to move the cluster files") String iNewPath ) {

  checkCurrentDatabase(); // THE DB MUST BE OPENED

  System.out.println("Moving cluster '" + iClusterName + "' to path " + iNewPath + "...");
}
```
If you type:

    orientdb> help

Your new command will appear. And now try:

```
orientdb> move cluster foo /temp

Moving cluster 'foo' to path /temp...
```

Don't miss to contribute your command to the [OrientDB Community](https://groups.google.com/forum/#!forum/orient-database)! ;-)
