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

As of version 2.2, [OrientDB Enterprise Edition](../ee/Enterprise-Edition.md) supports incremental backups executed through Java or any language that runs on top of the JVM, using the `incrementalBackup()` method against a database instance.

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
