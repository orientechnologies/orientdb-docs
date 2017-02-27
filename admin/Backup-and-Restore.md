---
search:
   keywords: ['backup', 'restore']
---


# Backup & Restore

OrientDB supports backup and and restore operations, like any database management system.

The [`BACKUP DATABASE`](../console/Console-Command-Backup.md) command executes a complete backup on the currently open database.  It compresses the backup the backup using the ZIP algorithm.  To restore the database from the subsequent `.zip` file, you can use the [`RESTORE DATABASE`](../console/Console-Command-Restore.md) command.

Backups and restores are much faster than the [`EXPORT DATABASE`](../console/Console-Command-Export.md) and [`IMPORT DATABASE`](../console/Console-Command-Import.md) commands.  You can also automate backups using the [Automatic Backup](../plugins/Automatic-Backup.md) server plugin.  Additionally, beginning with version 2.2 of [Enterprise Edition](../ee/Enterprise-Edition.md) OrientDB introduces major support for [incremental backups](Incremental-Backup-And-Restore.md).

>**NOTE**: OrientDB Community Edition does not support backing up remote databases.  OrientDB [Enterprise Edition](http://www.orientechnologies.com/orientdb-enterprise/) does support this feature.  For more information on how to implement this with Enterprise Edition, see [Remote Backups](http://www.orientechnologies.com/enterprise/last/servermanagement.html).

## Backups versus Exports

During backups, the [`BACKUP DATABASE`](../console/Console-Command-Backup.md) command produces a consistent copy of the database.  During this process, the database locks all write operations, waiting for the backup to finish.  If you need perform reads and writes on the database during backups, set up a distributed cluster of nodes.  To access to the non blocking backup feature, use the [Enterprise Edition](Incremental-Backup-And-Restore.md).

By contrast, the [`EXPORT DATABASE`](../console/Console-Command-Export.md) command doesn't lock the database, allowing concurrent writes to occur during the export process.  Consequentially, the export may include changes made after you initiated the export, which may result in inconsistencies.

## Using the Backup Script

Beginning in version 1.7.8, OrientDB introduces a `backup.sh` script found in the `$ORIENTDB_HOME/bin` directory.  This script allows you to initiate backups from the system console.

**Syntax**

```
./backup.sh <db-url> <user> <password> <destination> [<type>]
```

- **`<db-url>`** Defines the URL for the database to backup.
- **`<user>`** Defines the user to run the backup.
- **`<password>`** Defines the password for the user.
- **`<destination>`** Defines the path to the backup file the script creates, (use the `.zip` extension).
- **`<type>`** Defines the backup type.  Supported types:
  - *`default`* Locks the database during the backup.
  - *`lvm`* Executes an LVM copy-on-write snapshot in the background.

>**NOTE** Non-blocking backups require that the operating system support LVM.  For more information, see
>- [LVM](http://en.wikipedia.org/wiki/Logical_Volume_Manager_%28Linux%29)
>- [File system snapshots with LVM](http://arstechnica.com/information-technology/2004/10/linux-20041013/) 
>- [LVM snapshot backup](http://www.tldp.org/HOWTO/LVM-HOWTO/snapshots_backup.html)


**Examples**

- Backup a database opened using `plocal`:

  <pre>
  $ <code class="lang-sh userinput">$ORIENTDB_HOME/bin/backup.sh plocal:../database/testdb \
        admin adminpasswd \
		/path/to/backup.zip</code>
  </pre>

- Perform a non-blocking LVM backup, using `plocal`:

  <pre>
  $ <code class='lang-sh userinput'>$ORIENTDB_HOME/bin/backup.sh plocal:../database/testdb \
        admin adminpasswd \
		/path/to/backup.zip \
		lvm</code>
  </pre>


- Perform a backup using the OrientDB Console with the [`BACKUP`](../console/Console-Command-Backup.md) command:

  <pre>
  orientdb> <code class='lang-sql userinput'>CONNECT PLOCAL:../database/testdb/ admin adminpasswd</code>
  orientdb> <code class='lang-sql userinput'>BACKUP DATABASE /path/to/backup.zip</code>
  
  Backup executed in 0.52 seconds.
  </pre>



## Restoring Databases

Once you have created your `backup.zip` file, you can restore it to the database either through the OrientDB Console, using the [`RESTORE DATABASE`](../console/Console-Command-Restore.md) command.  

<pre>
orientdb> <code class='lang-sql userinput'>RESTORE DATABASE /backups/mydb.zip</code>

Restore executed in 6.33 seconds
</pre>

Bear in mind that OrientDB does not support merging during restores.  If you need to merge the old data with new writes, instead use [`EXPORT DATABASE`](../console/Console-Command-Export.md) and [`IMPORT DATABASE`](../console/Console-Command-Export.md) commands, instead.


>For more information, see
>
>- [`BACKUP DATABASE`](../console/Console-Command-Backup.md)
>- [`RESTORE DATABASE`](../console/Console-Command-Restore.md)
>- [`EXPORT DATABASE`](../console/Console-Command-Export.md)
>- [`IMPORT DATABASE`](../console/Console-Command-Import.md)
>- [Console Commands](../console/Console-Commands.md)
