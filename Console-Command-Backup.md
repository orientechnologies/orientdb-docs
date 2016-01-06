<!-- proofread 2015-01-05 SAM -->

# Console - `BACKUP`

Executes a complete backup on the currently opened database. It then compresses the backup file using the ZIP algorithm. You can then restore a database from backups, using the [`RESTORE DATABASE`](Console-Command-Restore.md) command. You can automate backups using the [Automatic-Backup](Automatic-Backup.md) server plugin.

Backups and restores are similar to the [`EXPORT DATABASE`](Console-Command-Export.md) and [`IMPORT DATABASE`](Console-Command-Import.md), but they offer better performance than these options.  

>**NOTE**: OrientDB Community Edition does not support backing up remote databases.  OrientDB [Enterprise Edition](http://www.orientechnologies.com/orientdb-enterprise/) does support this feature.  For more information on how to implement this with Enterprise Edition, see [Remote Backups](http://www.orientechnologies.com/enterprise/last/servermanagement.html).

**Syntax:**

```
BACKUP DATABASE <output-file> [-incremental] [-compressionLevel=<compressionLevel>] [-bufferSize=<bufferSize>]
```

- **`<output-file>`** Defines the path to the backup file.
- **`-incremental`** Option to execute an incremental backup.  When enabled, it computes the data to backup as all new changes since the last backup. Available in version 2.2 or later.
- **-`compressionLevel`** Defines the level of compression for the backup file.  Valid levels are `0` to `9`.  The default is `9`.  Available in 1.7 or later.
- **`-bufferSize`** Defines the compression buffer size.  By default, this is set to 1MB.  Available in 1.7 or later.

**Example:**

- Backing up a database:

<pre>
orientdb> <code class="lang-sql userinput">CONNECT plocal:../databases/mydatabase admin admin</code>
orientdb> <code class="lang-sql userinput">BACKUP DATABASE /backups/mydb.zip</code>

Backing current database to: database mydb.zip
Backup executed in 0.52 seconds
</pre>

## Backup API

In addition to backups called through the Console, you can also manage backups through the Java API. Using this, you can perform either a full or incremental backup on your database.

### Full Backup

In Java or any other language that runs on top of the JVM, you can initiate a full backup by using the `backup()` method on a database instance.

```java
db.backup(out, options, callable, listener, compressionLevel, bufferSize);
```

- **`out`** Refers to the `OutputStream` that it uses to write the backup content.  Use a `FileOutputStream` to make the backup persistent on disk.
- **`options`** Defines backup options as a `Map<String, Object>` object.
- **`callable`** Defines the callback to execute when the database is locked.
- **`listener`** Defines the listened called for backup messages.
- **`compressionLevel`** Defines the level of compression for the backup.  It supports levels between `0` and `9`, where `0` equals no compression and `9` the maximum.  Higher compression levels do mean smaller files, but they also mean the backup requires more from the CPU at execution time.
- **`bufferSize`** Defines the buffer size in bytes.  The larger the buffer, the more efficient the comrpession.

**Example:**

```java
ODatabaseDocumentTx db = new ODatabaseDocumentTx("plocal:/temp/mydb");
db.open("admin", "admin");
try{
  OCommandOutputListener listener = new OCommandOutputListener() {
    @Override
    public void onMessage(String iText) {
      System.out.print(iText);
    }
  };

  OutputStream out = new FileOutputStream("/temp/mydb.zip");
  db.backup(out,null,null,listener,9,2048);
} finally {
   db.close();
}
```

### Incremental Backup

As of version 2.2, OrientDB supports incremental backups executed through Java or any language that runs on top of the JVM, using the `incrementalBackup()` method against a database instance.

```java
db.incrementalBackup(backupDirectory);
```

- **`backupDirectory`** Defines the directory where it generates the incremental backup files.  

It is important that previous incremental backup files are present in the same directory, in order to compute the database portion to back up, based on the last incremental backup.

**Example:**

```java
ODatabaseDocumentTx db = new ODatabaseDocumentTx("plocal:/temp/mydb");
db.open("admin", "admin");
try{
  db.backup("/var/backup/orientdb/mydb");
} finally {
   db.close();
}
```

>For more information, see:

> - [Restore Database](Console-Command-Restore.md)
> - [Export Database](Console-Command-Export.md)
> - [Import Database](Console-Command-Import.md)
> - [Console-Commands](Console-Commands.md)
> - [ODatabaseExport Java class](https://github.com/orientechnologies/orientdb/blob/master/core/src/main/java/com/orientechnologies/orient/core/db/tool/ODatabaseExport.java)
