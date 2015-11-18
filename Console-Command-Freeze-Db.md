# Console - FREEZE DATABASE

Flushes all cached content to the disk storage and allows to perform only read commands.
Database will be "frozen" till release database command will not been executed.

This command requires presence of server administration rights and can be executed only on remote DBs. If you would like to freeze/release local DB use methods ```ODatabase.freeze()``` and ```ODatabase.release()``` directly from OrientDB API.

This command is very useful in case you would like to do "live" database backups.
You can "freeze" database, do file system snapshot, "release" database, copy snapshot anywhere you want. Using such approach you can perform backup in short term.


## Syntax

```sql
FREEZE DATABASE
```

## See also
- [RELEASE DATABASE](Console-Command-Release-Db.md), to release the frozen database
- [SQL commands](SQL.md)
- [Console-Commands](Console-Commands.md)

## Examples

Freezes the current database:

```sql
FREEZE DATABASE
```
