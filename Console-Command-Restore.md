# Console - RESTORE DATABASE

Executes a restore of a database. The restore operation must be done against a new database. Merging of databases with restore operation is not supported. For this reason, use the [export](Console-Command-Export.md)/[import](Console-Command-Import.md) database. 

The backup file is created using the [BACKUP DATABASE](Console-Command-Backup.md). Look also to [EXPORT DATABASE](Console-Command-Export.md) and [IMPORT DATABASE](Console-Command-Import.md) commands.

## Syntax

```sql
RESTORE DATABASE <backup-file>
```

Where:
- *backup-file* is the backup input file path to restore

## Example

```
orientdb> CREATE DATABASE plocal:/temp/mydb
orientdb> RESTORE DATABASE /backups/mydb.zip

Restore executed in 6,33 seconds
```

## Restore API
Restore can be executed in Java and any language on top of the JVM by using the method restore() against the database instance:

```java
db.restore(in, options, callable, listener);
```

Where:
- **in**: InputStream used to read the backup content. Use a FileInputStream to read the backup content from disk
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

  InputStream out = new FileInputStream("/temp/mydb.zip");
  db.restore(in,null,null,listener);
} finally {
   db.close();
}
```

## See also
- [BACKUP DATABASE](Console-Command-Backup.md)
- [EXPORT DATABASE](Console-Command-Export.md)
- [IMPORT DATABASE](Console-Command-Import.md)
- [Console-Commands](Console-Commands.md)
