# Console - BACKUP

Executes a complete backup against the currently opened database. The backup file is compressed using the ZIP algorithm. To restore the database use the [Restore Database command](Console-Command-Restore.md). Backup is much faster than [Export Database](Console-Command-Export.md). Look also to [Export Database](Console-Command-Export.md) and [Import Database](Console-Command-Import.md) commands. Backup can be done automatically by enabling the [Automatic-Backup](Automatic-Backup.md) Server plugin.

NOTE: _Backup of remote databases is not supported in Community Edition, but only in [Enterprise Edition](http://www.orientechnologies.com/orientdb-enterprise/). If you're using the Enterprise Edition look at [Remote Backup](http://www.orientechnologies.com/enterprise/last/servermanagement.html)._

## Syntax

```
backup database <output-file> [-incremental] [-compressionLevel=<compressionLevel>] [-bufferSize=<bufferSize>]
```

Where:
- **-incremental** execute an incremental backup. The incremental data to backup is computed as all new changes since the last backup. Since v2.2
- **output-file** is the output file path
- **compressionLevel** the compression level between 0 and 9. Default is 9. Since v1.7
- **bufferSize** the compression buffer size. Default is 1MB. Since v1.7


## Example ##

```sql
orientdb> connect plocal:../databases/mydatabase admin admin
orientdb> backup database /backups/mydb.zip

Backuping current database to: database mydb.zip...

Backup executed in 0,52 seconds
```

## Backup API
### Full Backup
Backup can be executed in Java and any language on top of the JVM by using the method `backup()` against the database instance:

```java
db.backup(out, options, callable, listener, compressionLevel, bufferSize);
```

Where:
- **out**: OutputStream used to write the backup content. Use a FileOutputStream to make the backup persistent on disk
- **options**: Backup options as Map<String, Object> object
- **callable**: Callback to execute when the database is locked
iListener: Listener called for backup messages
- **compressionLevel**: ZIP Compression level between 0 (no compression) and 9 (maximum). The bigger is the compression, the smaller will be the final backup content, but will consume more CPU and time to execute
- **bufferSize**: Buffer size in bytes, the bigger is the buffer, the more efficient will be the compression

Example:

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

### Incremental backup
(Since v2.2.)

```java
db.incrementalBackup(backupDirectory);
```

## See also
- [Restore Database](Console-Command-Restore.md)
- [Export Database](Console-Command-Export.md)
- [Import Database](Console-Command-Import.md)
- [Console-Commands](Console-Commands.md)
- [ODatabaseExport Java class](https://github.com/orientechnologies/orientdb/blob/master/core/src/main/java/com/orientechnologies/orient/core/db/tool/ODatabaseExport.java)
