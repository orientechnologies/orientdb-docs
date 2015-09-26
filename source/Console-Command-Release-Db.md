# Console - RELEASE DATABASE

Switches database from "[frozen](Console-Command-Freeze-Db.md)" state (where only read operations are allowed) to normal mode.

Execution of this command requires presence of server administration rights.

This command is very usefull in case you would like to do "live" database backups.
You can "freeze" database, do file system snapshot, "release" database, copy snapshot anywhere you want. Using such approach you can perform backup in short term.

## Syntax

```sql
RELEASE DATABASE
```

## See also
- [Freeze Database](Console-Command-Freeze-Db.md), to freeze a database
- [SQL commands](SQL.md)
- [Console-Commands](Console-Commands.md)



## Examples

Release the current database:

```sql
RELEASE DATABASE
```
