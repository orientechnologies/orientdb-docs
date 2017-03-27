
## Console Commands

OrientDB implements a number of SQL statements and commands that are available through the Console. In the event that you need information while working in the console, you can access it using either the `HELP` or `?` command.


|Command|Description|
|-------|-----------|
|[`BACKUP DATABASE`](Console-Command-Backup.md)|Backup a database|
|[`BROWSE CLASS`](Console-Command-Browse-Class.md)|Browses all the records of a class|
|[`BROWSE CLUSTER`](Console-Command-Browse-Cluster.md)|Browses all the records of a cluster|
|[`CLASSES`](Console-Command-Classes.md)|Displays all the configured classes|
|[`CLUSTER STATUS`](Console-Command-Cluster-Status.md)|Displays the status of distributed cluster of servers|
|[`CLUSTERS`](Console-Command-Clusters.md)|Displays all the configured clusters|
|[`CONFIG`](Console-Command-Config.md)|Displays the configuration where the opened database is located (local or remote)|
|[`CONFIG GET`](Console-Command-Config-Get.md)|Returns a configuration value|
|[`CONFIG SET`](Console-Command-Config-Set.md)|Set a configuration value|
|[`CONNECT`](Console-Command-Connect.md)|Connects to a database|
|[`CREATE DATABASE`](Console-Command-Create-Database.md)|Creates a new database|
|[`DECLARE INTENT`](Console-Command-Declare-Intent.md)|Declares an intent|
|[`DICTIONARY KEYS`](Console-Command-Dictionary-Keys.md)|Displays all the keys in the database dictionary|
|[`DICTIONARY GET`](Console-Command-Dictionary-Get.md)|Loookups for a record using the dictionary. If found set it as the current record|
|[`DICTIONARY PUT`](Console-Command-Dictionary-Put.md)|Inserts or modify an entry in the database dictionary. The entry is composed by key=String, value=record-id|
|[`DICTIONARY REMOVE`](Console-Command-Dictionary-Remove.md)|Removes the association in the dictionary|
|[`DISCONNECT`](Console-Command-Disconnect.md)|Disconnects from the current database|
|[`DISPLAY RECORD`](Console-Command-Display-Record.md)|Displays current record's attributes|
|[`DISPLAY RAW RECORD`](Console-Command-Display-Raw-Record.md)|Displays current record's raw format|
|[`DROP DATABASE`](Console-Command-Drop-Database.md)|Drop a database|
|[`EXPORT DATABASE`](Console-Command-Export.md)|Exports a database|
|[`EXPORT RECORD`](Console-Command-Export-Record.md)|Exports a record in any of the supported format (i.e. json)|
|[`FREEZE DATABASE`](Console-Command-Freeze-Db.md)|Freezes the database locking all the changes. Use this to raw backup. Once frozen it uses the [`RELEASE DATABASE`](Console-Command-Release-Db.md) to release it|
|[`GET`](Console-Command-Get.md)|Returns the value of a property|
|[`IMPORT DATABASE`](Console-Command-Import.md)|Imports a database previously exported|
|[`INDEXES`](Console-Command-Indexes.md)|Displays information about indexes|
|[`INFO`](Console-Command-Info.md)|Displays information about current status|
|[`INFO CLASS`](Console-Command-Info-Class.md)|Displays information about a class|
|[`JS`](../js/Javascript-Command.md#via_console)|Executes a Javascript in the console|
|[`JSS`](../js/Javascript-Command.md#via_console)|Executes a Javascript in the server|
|[`LIST DATABASES`](Console-Command-List-Databases.md)|List the available databases|
|[`LIST CONNECTIONS`](Console-Command-List-Connections.md)|List the available connections|
|[`LOAD RECORD`](Console-Command-Load-Record.md)|Loads a record in memory and set it as the current one|
|[`PROFILER`](Console-Command-Profiler.md)|Controls the [Profiler](../tuning/Profiler.md)|
|[`PROPERTIES`](Console-Command-Properties.md)|Returns all the configured properties|
|`pwd`|Display current path|
|[`RELEASE DATABASE`](Console-Command-Release-Db.md)|Releases a [Console Freeze Database](Console-Command-Freeze-Db.md) database|
|[`RELOAD RECORD`](Console-Command-Reload-Record.md)|Reloads a record in memory and set it as the current one|
|`RELOAD SCHEMA`|Reloads the schema|
|[`RESTORE DATABASE`](Console-Command-Restore.md)|Restore a database|
|[`SET`](Console-Command-Set.md)|Changes the value of a property|
|`HELP`|Prints this help|
|`EXIT`|Closes the console|
|[SQL Statements](../sql/Commands.md)|

