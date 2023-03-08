
# Console - `RESTORE DATABASE`

Restores a database from a backup.  It must be done against a new database.  It does not support restores that merge with an existing database.  If you need to backup and restore to an existing database, use the [`EXPORT DATABASE`](Console-Command-Export.md) and [`IMPORT DATABASE`](Console-Command-Import.md) commands.

[OrientDB Enterprise Edition](../ee/Enterprise-Edition.md) version 2.2 and major, support [incremental backup](../admin/Incremental-Backup-And-Restore.md).

To create a backup file to restore from, use the [`BACKUP DATABASE`](Console-Command-Backup.md) command.

**Syntax**

```sql
RESTORE DATABASE <backup-file>|<incremental-backup-directory>
```

- **`<backup-file>`** Defines the database file you want to restore.
- **`<incremental-backup-directory>`** Defines the database directory you want to restore from an incremental backup. Available only in [OrientDB Enterprise Edition](../ee/Enterprise-Edition.md) version 2.2 and major.

**Permissions:**

In order to enable a user to execute this command, you must add the permission of `create` for the resource `database.restore` to the [database user](../security/Database-Security.md#users).

**Example of full restore**

- Create a new database to receive the restore:

  <pre>
  orientdb> <code class='lang-sql userinput'>CREATE DATABASE PLOCAL:/tmp/mydb</code>
  </pre>

- Restore the database from the `mydb.zip` backup file:

  <pre>
  orientdb {db=/tmp/mydb}> <code class='lang-sql userinput'>RESTORE DATABASE /backups/mydb.zip</code>
  </pre>

**Example of incremental restore**

This is available only in [OrientDB Enterprise Edition](../ee/Enterprise-Edition.md) version 2.2 and major.

- Open a database to receive the restore:

  <pre>
  orientdb> <code class='lang-sql userinput'>CONNECT PLOCAL:/tmp/mydb</code>
  </pre>

- Restore the database from the `/backup` backup directory:

  <pre>
  orientdb {db=/tmp/mydb}> <code class='lang-sql userinput'>RESTORE DATABASE /backup</code>
  </pre>

>For more information, see the [`BACKUP DATABASE`](Console-Command-Backup.md), [`EXPORT DATABASE`](Console-Command-Export.md), [`IMPORT DATABASE`](Console-Command-Import.md) commands.  For more information on other commands, see [Console Commands](Console-Commands.md).


