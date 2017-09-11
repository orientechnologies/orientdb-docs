---
search:
   keywords: ['console', 'console command', 'BACKUP']
---

<!-- proofread 2015-01-05 SAM -->

# Console - `BACKUP`

Executes a complete backup on the currently opened database. It then compresses the backup file using the ZIP algorithm. You can then restore a database from backups, using the [`RESTORE DATABASE`](Console-Command-Restore.md) command. You can automate backups using the [Automatic-Backup](../plugins/Automatic-Backup.md) server plugin.

Backups and restores are similar to the [`EXPORT DATABASE`](Console-Command-Export.md) and [`IMPORT DATABASE`](Console-Command-Import.md), but they offer better performance than these options.  

>**NOTE**: OrientDB Community Edition does not support backing up remote databases.  OrientDB [Enterprise Edition](http://www.orientechnologies.com/orientdb-enterprise/) does support this feature.  For more information on how to implement this with Enterprise Edition, see [Remote Backups](http://www.orientechnologies.com/enterprise/last/servermanagement.html).

**Syntax:**

```
BACKUP DATABASE <output-file> [-incremental] [-compressionLevel=<compressionLevel>] [-bufferSize=<bufferSize>]
```

- **`<output-file>`** Defines the path to the backup file.
- **`-incremental`** Option to execute an [incremental backup](../admin/Incremental-Backup-And-Restore.md).  When enabled, it computes the data to backup as all new changes since the last backup. Available only in the [OrientDB Enterprise Edition](../ee/Enterprise-Edition.md) version 2.2 or later.
- **-`compressionLevel`** Defines the level of compression for the backup file.  Valid levels are `0` to `9`.  The default is `9`.  Available in 1.7 or later.
- **`-bufferSize`** Defines the compression buffer size.  By default, this is set to 1MB.  Available in 1.7 or later.

**Permissions:**

In order to enable a user to execute this command, you must add the permission of `create` for the resource `database.backup` to the [database user](Database-Security.md#users).

**Example:**

- Backing up a database:

<pre>
orientdb> <code class="lang-sql userinput">CONNECT plocal:../databases/mydatabase admin admin</code>
orientdb> <code class="lang-sql userinput">BACKUP DATABASE /backups/mydb.zip</code>

Backing current database to: database mydb.zip
Backup executed in 0.52 seconds
</pre>


### Incremental Backup

Since version 2.2, [OrientDB Enterprise Edition](../ee/Enterprise-Edition.md) supports incremental backups.
For more details see [Incremental Backup and Restore](../admin/Incremental-Backup-And-Restore.md) 


>For more information, see:

> - [Restore Database](Console-Command-Restore.md)
> - [Export Database](Console-Command-Export.md)
> - [Import Database](Console-Command-Import.md)
> - [Console-Commands](Console-Commands.md)
> - [ODatabaseExport Java class](https://github.com/orientechnologies/orientdb/blob/master/core/src/main/java/com/orientechnologies/orient/core/db/tool/ODatabaseExport.java)
