## Restore API

In addition to the console commands, you can also execute restores through the Java API or with any language that can run on top of the JVM using the `restore()` method against the database instance.

```java
db.restore(in, options, callable, listener);
```

- **`in`** Defines the `InputStream` used to read the backup content.  Uses a `FileInputStream` to read the backup content from disk.
- **`options`** Defines backup options, such as `Map<String, Object>` object.
- **`callable`** Defines the callback to execute when the database is locked.
- **`listener`** Listener called for backup messages.
- **`compressionLevel`** Defines the Zip Compression level, between `0` for no compression and `9` for maximum compression.  The greater the compression level, the smaller the final backup content and the greater the CPU and time it takes to execute.
- **`bufferSize`** Buffer size in bytes, the greater the buffer the more efficient the compression.

**Example**


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

