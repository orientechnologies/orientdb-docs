
## Import API

In addition to the Console, you can also manage imports through the Java API, and with any language that runs on top of the JVM, using the [`ODatabaseImport`](https://github.com/orientechnologies/orientdb/blob/master/core/src/main/java/com/orientechnologies/orient/core/db/tool/ODatabaseImport.java) class.

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

  ODatabaseImport import = new ODatabaseImport(db, "/temp/export/export.json.gz", listener);
  import.importDatabase();
  import.close();
} finally {
  db.close();
}
```