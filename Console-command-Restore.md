# Console - RESTORE

Executes a restore of current opened database. The backup file is created using the [Backup Database command](Console-Command-Backup.md). Look also to [Export Database](Console-Command-Export.md) and [Import Database](Console-Command-Import.md) commands.

## Syntax

```sql
restore database <backup-file>
```

Where:
- *backup-file* is the backup input file path to restore

## Example

```
orientdb> restore database /backups/mydb.zip

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
- [Backup Database](Console-command-Backup.md)
- [Export Database](Console-command-Export.md)
- [Import Database](Console-command-Import.md)
- [Console-Commands](Console-Commands.md)
