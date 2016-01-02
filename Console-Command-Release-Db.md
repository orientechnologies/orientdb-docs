# Console - `RELEASE DATABASE`

Releases database from a frozen state, from where it only allows read operations back to normal mode.  Execution requires server administration rights.

You may find this command useful in the event that you want to perform live database backups.  Run the [`FREEZE DATABASE`](Console-Command-Freeze-Db.md) command to take a snapshot, you can then copy the snapshot anywhere you want.  Use such approach when you want to take short-term backups.

**Syntax**

```sql
RELEASE DATABASE
```

**Example**

- Release the current database from a freeze:

  <pre>
  orientdb> <code class='lang-sql userinput'>RELEASE DATABASE</code>
  </pre>

>To freeze a database, see the [`FREEZE DATABASE`](Console-Command-Freeze-Db.md) command.
>
>For more information on other commands, see [Console](Console-Commands.md) and [SQL](SQL.md) commands.


