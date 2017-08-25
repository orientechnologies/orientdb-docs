
# Custom Console Commands

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

