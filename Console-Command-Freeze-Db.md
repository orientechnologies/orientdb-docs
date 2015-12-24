# Console - `FREEZE DATABASE`

Flushes all cached content to disk and restricts permitted operations to read commands.  With the exception of reads, none of the commands made on a frozen database execute.  It remains in this state until you run the [`RELEASE`](Console-Command-Release-Db.md) command.

Executing this command requires server administration rights.  You can only execute it on remote databases.  If you would like to freeze or release a local database, use the `ODatabase.freeze()` and `ODatabase.release()` methods directly through the OrientDB API.

>You may find this command useful in the event that you would like to perform backups on a live database.  To do so, freeze the database, perform a file system snapshot, then release the database.  You can now copy the snapshot anywhere you want.  

>This works best when the backup doesn't take very long to run.

**Syntax**

```sql
FREEZE DATABASE
```

**Example**

- Freezes the current database:
 
  <pre>
  orientdb> <code class='lang-sql userinput'>FREEZE DATABASE</code>
  </pre>

>To unfreeze a database, use the [`RELEASE DATABASE`](Console-Command-Release-Db.md) command.

>For more information on other commands, see [SQL](SQL.md) and [Console](Console-Commands.md) commands.

