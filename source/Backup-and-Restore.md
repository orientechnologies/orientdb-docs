# Backup & Restore

OrientDB supports backup and restore operations like any RDBMS.

Backup executes a complete backup against the currently opened database. The backup file is compressed using the ZIP algorithm. To restore the database use the [Restore Database command](Console-Command-Restore.md). Backup is much faster than [Export Database](Console-Command-Export.md). Look also to [Export Database](Console-Command-Export.md) and [Import Database](Console-Command-Import.md) commands. Backup can be done automatically by enabling the [Automatic-Backup](Automatic-Backup.md) Server plugin.

## When to use backup and when export?
Backup does a consistent copy of database, all further write operations are locked waiting to finish it. The database is in read-only mode during backup operation. If you need an read/write database during backup setup a distributed cluster of nodes.

Export, instead, doesn't lock the database and allows concurrent writes during the export process. This means the exported database could have changes executed during the export.

## Backup database
Starting from v1.7.8, OrientDB comes with the script "backup.sh" under the "bin" directory. This script executes the backup by using the console. Syntax:

```
./backup.sh <dburl> <user> <password> <destination> [<type>]
```

Where:
- **dburl**: database URL
- **user**: database user allowed to run the backup
- **password**: database password for the specified user
- **destination**: destination file path (use .zip as extension) where the backup is created
- **type**: optional backup type, supported types are:
 - **default**, locks the database during the backup
 - **lvm**, uses LVM copy-on-write snapshot to execute in background

Example of backup against a database open with "plocal":
```
./backup.sh plocal:../database/testdb admin admin /dest/folder/backup.zip
```

### Non-Blocking Backup
backup.sh script supports non-blocking backup if the OS supports [LVM](http://en.wikipedia.org/wiki/Logical_Volume_Manager_%28Linux%29). Example:

```
./backup.sh plocal:../database/testdb admin admin /dest/folder/backup.zip lvm
```

Same example like before, but against a remote database hosted on localhost:
```
./backup.sh remote:localhost/testdb root rootpwd /dest/folder/backup.zip lvm
```

For more information about [LVM](http://en.wikipedia.org/wiki/Logical_Volume_Manager_%28Linux%29) and Copy On Write (COS) look at:
- [File system snapshots with LVM](http://arstechnica.com/information-technology/2004/10/linux-20041013/)
- [LVM snapshot backup](http://www.tldp.org/HOWTO/LVM-HOWTO/snapshots_backup.html)

### Using the console
You can also use the [console](Console-Command-Backup.md) to execute a backup. Below the same backup like before, but using the console.
```sql
orientdb> CONNECT plocal:../database/testdb admin admin
orientdb> BACKUP DATABASE /dest/folder/backup.zip
Backup executed in 0.52 seconds
```

## Restore database
Use the [console](Console-Command-Restore.md) to restore a database or Java API. The restore operation must be done against a new database. Merging of databases with restore operation is not supported. For this reason, use the [export](Console-Command-Export.md)/[import](Console-Command-Import.md) database. Example:

```
orientdb> RESTORE DATABASE /backups/mydb.zip
Restore executed in 6.33 seconds
```

## See also
- [BACKUP DATABASE](Console-Command-Backup.md)
- [RESTORE DATABASE](Console-Command-Restore.md)
- [EXPORT DATABASE](Console-Command-Export.md)
- [IMPORT DATABASE](Console-Command-Import.md)
- [Console-Commands](Console-Commands.md)
